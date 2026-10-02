#!/usr/bin/env python3
"""Build the remote runtime-tables blob consumed by RoundWhiteDiscKit.installRuntimeTables(_:).

The package bundles no data files. Every runtime table (and the two phone
certs) ships in this blob. Four of the large tables are overlapping dumps of
one library region, so the blob stores that region once plus small byte
patches; all other tables are stored verbatim by name. Everything is
compressed as a single xz stream (decodable on Apple platforms via
NSData.decompressed(using: .lzma)).

Layout of the decompressed payload (little-endian), format version 2:

    magic        8 bytes  b"RWDKTBL\\0"
    version      u32      2
    image_len    u32      0x220001  sbox19[0:0x20001] + sbox12_full
    vm_desc_len  u32
    program_len  u32
    patch_count  u32
    named_count  u32
    image | vm_desc | program
    patch_count x { target u8 (0 = ttable_b_ext, 1 = bytecode), offset u32, length u16, bytes }
    named_count x { name_len u16, name utf8, length u32, bytes }   sorted by name

RuntimeTables.swift pins the SHA-256 of the whole decompressed payload; this
script prints it (update `expectedPayloadSHA256` whenever the blob changes).

Derived tables (offsets must match RuntimeTables.swift):
    sbox19       = image[0 : 0x80000]
    sbox12       = image[0x20001 : 0x220001]
    ttable_b_ext = image[0x20001 : 0x120001]               + patches(0)
    bytecode     = image[0x20001 + 0x17f506 : ... + 413696] + patches(1)

Usage:
    Scripts/build_runtime_tables_blob.py                       # originals from RemoteTables/source
    Scripts/build_runtime_tables_blob.py --tables-dir DIR -o out.xz
"""

import argparse
import hashlib
import lzma
import os
import struct
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_TABLES_DIR = os.path.join(REPO, "RemoteTables", "source")
DEFAULT_OUT = os.path.join(REPO, "RemoteTables", "roundwhitedisckit-runtime-tables-v2.xz")

MAGIC = b"RWDKTBL\0"
VERSION = 2
SBOX19_PREFIX = 0x20001          # sbox19 starts 0x20001 bytes before sbox12_full in the library
SBOX19_LEN = 0x80000
SBOX12_LEN = 0x200000
TTABLE_B_EXT_LEN = 0x100000
BYTECODE_IN_SBOX12 = 0x17F506    # 0xb25d20 - 0x9a681a
BYTECODE_LEN = 413_696
PATCH_TTABLE_B_EXT = 0
PATCH_BYTECODE = 1

# The four overlapping tables + two more stored in the shared section, with the
# SHA-256 of each original file. Every other .bin in the source dir is stored by name.
TABLES = {
    "sbox_19bit_lib_986819": "a81bbfaed9510a8f0fb1edb67f8f29d4ebf25119b2976eb948b37f5b1ddaf003",
    "sbox_12bit_full": "41208d43a503c443d605806f633b98e2cdcec44617d6a085e02718222f796c34",
    "child23_ttable_b_ext_976ea8_100000": "e22a373103902384e273a86fa5bb19b542620d1881228fa90df3a37bbe247328",
    "bytecode_lib_b25d20": "fad53682e2b68022f1545757186283b94cab2a0c78a95b5402d74a32151f2592",
    "child23_71fb38_vm_desc_d84770": "2d3d164afde9e212399e8e4e1016e84a8c6d44f7cc839cc6925cf4937764dbcb",
    "child23_program_region_435cf0": "1dfb31c177f6e1dd8acf576c6a47ed3e6e12c8cd4c2571ce8deca4339222ba80",
}


def read_tables(tables_dir):
    out = {}
    for fn in sorted(os.listdir(tables_dir)):
        if fn.endswith(".bin"):
            with open(os.path.join(tables_dir, fn), "rb") as f:
                out[fn[:-4]] = f.read()
    for name, digest in TABLES.items():
        if name not in out:
            sys.exit(f"{name}.bin missing from {tables_dir}")
        if hashlib.sha256(out[name]).hexdigest() != digest:
            sys.exit(f"{name}: SHA-256 mismatch")
    return out


def diff_runs(base, actual):
    """Contiguous runs where actual differs from base, as (offset, bytes)."""
    runs = []
    i = 0
    while i < len(actual):
        if actual[i] != base[i]:
            j = i
            while j < len(actual) and actual[j] != base[j]:
                j += 1
            runs.append((i, actual[i:j]))
            i = j
        else:
            i += 1
    return runs


def build_payload(t):
    sbox19 = t["sbox_19bit_lib_986819"]
    sbox12 = t["sbox_12bit_full"]
    if sbox19[SBOX19_PREFIX:] != sbox12[: SBOX19_LEN - SBOX19_PREFIX]:
        sys.exit("sbox19 tail no longer overlaps sbox12_full")
    image = sbox19[:SBOX19_PREFIX] + sbox12
    vm_desc = t["child23_71fb38_vm_desc_d84770"]
    program = t["child23_program_region_435cf0"]

    patches = [(PATCH_TTABLE_B_EXT, off, b) for off, b in
               diff_runs(sbox12[:TTABLE_B_EXT_LEN], t["child23_ttable_b_ext_976ea8_100000"])]
    patches += [(PATCH_BYTECODE, off, b) for off, b in
                diff_runs(sbox12[BYTECODE_IN_SBOX12:BYTECODE_IN_SBOX12 + BYTECODE_LEN],
                          t["bytecode_lib_b25d20"])]

    named = sorted((n, d) for n, d in t.items() if n not in TABLES)

    out = bytearray(MAGIC)
    out += struct.pack("<IIIIII", VERSION, len(image), len(vm_desc), len(program), len(patches), len(named))
    out += image + vm_desc + program
    for target, off, b in patches:
        out += struct.pack("<BIH", target, off, len(b)) + b
    for name, data in named:
        n = name.encode()
        out += struct.pack("<H", len(n)) + n + struct.pack("<I", len(data)) + data
    return bytes(out)


def expand_payload(p):
    """Reference decoder mirroring RuntimeTables.swift; used to self-check the blob."""
    assert p[:8] == MAGIC
    version, image_len, vm_len, prog_len, n, named_count = struct.unpack_from("<IIIIII", p, 8)
    assert version == VERSION
    pos = 32
    image = p[pos:pos + image_len]; pos += image_len
    vm_desc = p[pos:pos + vm_len]; pos += vm_len
    program = p[pos:pos + prog_len]; pos += prog_len
    sbox12 = image[SBOX19_PREFIX:SBOX19_PREFIX + SBOX12_LEN]
    ttb = bytearray(sbox12[:TTABLE_B_EXT_LEN])
    bytecode = bytearray(sbox12[BYTECODE_IN_SBOX12:BYTECODE_IN_SBOX12 + BYTECODE_LEN])
    for _ in range(n):
        target, off, length = struct.unpack_from("<BIH", p, pos); pos += 7
        dst = ttb if target == PATCH_TTABLE_B_EXT else bytecode
        dst[off:off + length] = p[pos:pos + length]; pos += length
    named = {}
    for _ in range(named_count):
        (name_len,) = struct.unpack_from("<H", p, pos); pos += 2
        name = p[pos:pos + name_len].decode(); pos += name_len
        (length,) = struct.unpack_from("<I", p, pos); pos += 4
        named[name] = p[pos:pos + length]; pos += length
    assert pos == len(p)
    return named | {
        "sbox_19bit_lib_986819": image[:SBOX19_LEN],
        "sbox_12bit_full": sbox12,
        "child23_ttable_b_ext_976ea8_100000": bytes(ttb),
        "bytecode_lib_b25d20": bytes(bytecode),
        "child23_71fb38_vm_desc_d84770": vm_desc,
        "child23_program_region_435cf0": program,
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tables-dir", default=DEFAULT_TABLES_DIR, help="directory holding the original .bin files")
    ap.add_argument("-o", "--output", default=DEFAULT_OUT)
    args = ap.parse_args()

    tables = read_tables(args.tables_dir)
    payload = build_payload(tables)
    # Plain LZMA2 preset with CRC32 check: what Apple's COMPRESSION_LZMA decoder expects.
    blob = lzma.compress(payload, format=lzma.FORMAT_XZ, check=lzma.CHECK_CRC32,
                         preset=9 | lzma.PRESET_EXTREME)

    if expand_payload(lzma.decompress(blob)) != tables:
        sys.exit("self-check failed: blob does not reproduce the source tables")

    os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
    with open(args.output, "wb") as f:
        f.write(blob)
    raw = sum(len(d) for d in tables.values())
    print(f"{args.output}: {len(blob):,} bytes from {len(tables)} tables ({raw:,} raw, payload {len(payload):,})")
    print(f"blob sha256    {hashlib.sha256(blob).hexdigest()}")
    print(f"payload sha256 {hashlib.sha256(payload).hexdigest()}  (expectedPayloadSHA256)")


if __name__ == "__main__":
    main()
