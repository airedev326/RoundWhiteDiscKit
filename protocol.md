# Libre 3 Protocol Notes

> [!CAUTION]
> **Not from Abbott.** These notes come from independent interoperability work.
> They are not Abbott documentation and are not affiliated with or endorsed by
> Abbott. See [NOTICE.md](NOTICE.md).

This document summarizes the Libre 3 NFC, BLE, authorization, and data-plane
behavior modeled by RoundWhiteDiscKit. It intentionally focuses on protocol structure
and integration knowledge.

The names here are library-facing names. Some fields are still labeled as raw
or provisional where their clinical meaning is not fully grounded.

## Integration Model

A complete app-level session has four stages:

1. NFC scan the sensor and read patch metadata.
2. Send an NFC activation or switch-receiver command to obtain BLE connection
   metadata.
3. Connect over BLE and complete the security handshake.
4. Subscribe to encrypted data-plane characteristics and decode realtime,
   status, and backfill frames.

Apps should persist enough state to reconnect without repeating onboarding:

- Receiver ID, stored and shown as 4-byte little-endian hex.
- Sensor serial number.
- BLE address returned by NFC.
- 4-byte BLE PIN returned by NFC.
- Last accepted realtime glucose life count and value.
- Lifecycle metadata as more fields become named.

The receiver ID is the protocol identity value used in the NFC activation or
switch command. A LibreView account is not required by the protocol paths
currently modeled by this package.

An app that does mirror an Abbott app's account has to fold the LibreView
Account ID the way that app does, because the sensor stores the receiver ID it
was activated with and answers a later `0xA0`/`0xA8` carrying a different one
with NFC error `0xB1`. Two folds are known, exposed as
`Libre3ReceiverID.Derivation`:

| Derivation | App | Fold over the lowercased account ID |
| --- | --- | --- |
| `freeStyleLibre3` | FreeStyle Libre 3 | `h = (h * 0x811c9dc5) ^ byte`, seeded 0 |
| `libreByAbbott` | Libre by Abbott (US) | sum of consecutive 4-byte big-endian words, wrapped to 32 bits |

The `libreByAbbott` fold was reverse-engineered and confirmed on live hardware
on 2026-08-19: a US Libre 3 Plus (firmware 1.4.2.30) activated in that app,
paired in Parallel mode, completed the full first-pair handshake through Phase 6
and streamed. The `03 03` v1 certificate path covers these sensors unchanged.

Because that fold sums four-byte words, permutations of complete four-byte
chunks collide; byte order within a word still matters. This weak structure
suggests the observed sum is an intermediate from a larger routine rather than
the app's final value — it is nevertheless what the sensor accepts. Reading the
words as signed rather than unsigned makes no difference, since the two
interpretations differ by a multiple of 2^32 and the sum wraps to 32 bits.

Sample vectors, using DiaBLE's documented sample account
`2977dec2-492a-11ea-9702-0242ac110002` (not a real one):

| Derivation | Value | On the wire |
| --- | --- | --- |
| `freeStyleLibre3` | `0x1f416d8d` | `8d6d411f` |
| `libreByAbbott` | `0x8356f9c7` | `c7f95683` |

## NFC Layer

Libre 3 sensors are scanned as ISO 15693 NFC tags.

### Patch Info

Patch info is read with the Abbott manufacturer code `0x7a` and command `0xa1`.
CoreNFC supplies the manufacturer code separately for `customCommand`, so the
app-level request parameters for this read are empty.

The normalized patch-info response starts with:

```text
00 a5 ...
```

Known fields in the normalized response:

| Offset | Size | Meaning |
| --- | ---: | --- |
| 9 | 2 | Wear duration / life count in minutes, little-endian |
| 12 | 1 | Raw status byte |
| 13 | 4 | Firmware version bytes, displayed as `b13.b14.b15.b16` |
| 17 | 1 | Sensor state byte |
| 18 | 9 | ASCII sensor serial number |

The current command choice rule is:

- State `0x01`: send activation command `0xa0`.
- Other expected active states: send switch-receiver command `0xa8`.

### Activation And Switch-Receiver Commands

The activation and switch-receiver commands carry the same 10-byte body:

```text
timeSeconds_LE4 || receiverID_LE4 || abbottCRC16_LE2
```

Command codes:

| Code | Name | Use |
| --- | --- | --- |
| `0xa0` | Activate | Initial activation/pairing of a new sensor |
| `0xa8` | Switch receiver | Recovery or pairing against an already active sensor |

The CRC is a CRC-CCITT style 16-bit checksum with initial value `0xffff`, byte
bit reversal before each byte enters the CRC, polynomial `0x1021`, and
little-endian output.

The normalized activation/switch response is 19 bytes:

```text
00 a5 00 || bleAddress_LE6 || blePIN4 || activationTime4 || crc2
```

Known response fields:

| Offset | Size | Meaning |
| --- | ---: | --- |
| 3 | 6 | BLE address in little-endian byte order |
| 9 | 4 | BLE PIN used in the BLE authorization tail |
| 13 | 4 | Activation time / sensor time raw field |
| 17 | 2 | Trailing CRC/raw checksum |

The BLE address is displayed by reversing the six address bytes.

The sensor advertises that address as its BLE local name, uppercase hex without
separators (`E4:64:47:6E:2C:FE` advertises as `E464476E2CFE`). iOS does not
expose peripheral addresses, so match the advertised local name to pick the
NFC-scanned sensor; other Libre-family sensors nearby advertise the same
service UUID.

## BLE GATT

Libre 3 uses UUIDs under the base:

```text
0898xxxx-EF89-11E9-81B4-2A2AE2DBCCE4
```

Services:

| UUID prefix | Library name | Role |
| --- | --- | --- |
| `089810cc` | `serviceUUID` | Primary Libre 3 data service, used for scanning |
| `0898203a` | `securityServiceUUID` | Security handshake service |
| `08982400` | `debugServiceUUID` | Debug/service-adjacent UUID exposed by the sensor |

Data characteristics:

| UUID prefix | Library name | Direction | Role |
| --- | --- | --- | --- |
| `0898177a` | `glucoseData` | Notify | Realtime glucose data |
| `08981482` | `patchStatus` | Notify | Patch status and lifecycle/disconnect data |
| `08981338` | `patchControl` | Write | Data-plane control commands |
| `0898195a` | `historicData` | Notify | Historical backfill pages |
| `08981bee` | `eventLog` | Notify | Event-log records |
| `08981ab8` | `clinicalData` | Notify | Clinical/backfill stream |
| `08981d24` | `factoryData` | Notify | Factory data stream |

Security characteristics:

| UUID prefix | Library name | Direction | Role |
| --- | --- | --- | --- |
| `089823fa` | `secCertData` | Write/notify | Phone certificate, sensor certificate, ephemeral public keys |
| `089822ce` | `secChallengeData` | Write/notify | Phase 5 challenge and Phase 6 response |
| `08982198` | `secCommandResponse` | Write/notify | Single-byte security command and response clock |

## BLE Fragmentation

Logical messages are fragmented at the GATT layer.

Phone-to-sensor writes:

```text
offset_LE2 || payload_chunk
```

The default payload chunk size is 18 bytes.

Sensor-to-phone notifications:

```text
sequence1 || payload_chunk
```

The default payload chunk size is 19 bytes. The sequence byte increments by one
for each fragment in a logical message.

The realtime `glucoseData` notification is additionally split at the data-plane
level in the current implementation: a 15-byte prefix followed by a 20-byte
suffix. Concatenate those two notifications before parsing the encrypted
data-frame trailer and verifying the CCM tag.

## BLE Authorization

The authorization flow uses a phone certificate, sensor certificate, phone and
sensor ephemeral P-256 public keys, a challenge/response exchange, and a final
session-material response.

### Certificate And Ephemeral Exchange

The basic exchange is:

1. Phone writes its 162-byte certificate to `secCertData`.
2. Sensor notifies a 140-byte sensor certificate on `secCertData`.
3. Phone writes a 65-byte uncompressed P-256 ephemeral public key padded to 72
   bytes.
4. Sensor notifies a 65-byte uncompressed P-256 ephemeral public key.

The sensor certificate layout is:

```text
header11 || sensor_static_public_key65 || signature64
```

The signature is standard ECDSA-P256(SHA-256), raw `r || s`, over
`header || sensor_static_public_key`. RoundWhiteDiscKit verifies it with the bundled
Abbott patch-signing public keys before accepting the static public key.

The implementation derives:

- `ECDH(phone_ephemeral_private, sensor_static_public)`
- `ECDH(phone_ephemeral_private, sensor_ephemeral_public)`

Those shared secrets feed the later key material.

### Command-Gated Sequence

The security command characteristic clocks the certificate and challenge flow.
The modeled full command sequence is:

| Step | Phone command | Expected sensor response | Data side effect |
| --- | --- | --- | --- |
| 1 | `0x01` StartAuthentication | | |
| 2 | `0x02` LoadCertificate | | Phone writes certificate |
| 3 | `0x03` SendCertificateLoadDone | Prefix `0x04` CertificateAccepted | |
| 4 | `0x09` GetCertificate | Prefix `0x0a` CertificateReady | Sensor notifies certificate |
| 5 | `0x0d` ValidateCertificate | | Phone writes ephemeral public key |
| 6 | `0x0e` SendEphemeralDone | Prefix `0x0f` EphemeralReady | Sensor notifies ephemeral public key |
| 7 | `0x11` StartAuthorization | Prefix `0x08` ChallengeLoadDone | Sensor notifies R1 challenge |
| 8 | `0x08` SendChallengeLoadDone | Prefix `0x08` PatchChallengeLoadDone | Sensor notifies Phase 6 |

### App Credential And Phase 5 Key

The phone certificate written at step 2 is the 162-byte certificate of the
host-supplied app credential (`AppIdentity`); its embedded uncompressed P-256
point is the app's static public key. A sensor that does not accept the
certificate drops the link right after `SendCertificateLoadDone`.

The Phase 5/6 AES-CCM key is derived from two ECDH secrets:

```text
Ze   = ECDH(phone ephemeral private, sensor ephemeral public)
Zs   = ECDH(app static private,     sensor static public)
kAuth = SHA-256(00 00 00 01 || Ze || Zs)[0..<16]
```

The sensor static public key comes from the sensor certificate (step 4) and the
sensor ephemeral from step 6. `AppIdentity.authKey(...)` computes `kAuth`;
`AppIdentity.phase5Cipher` wraps it as standard AES-128.

### Cached Direct Reconnect

Pristine post-pairing reconnect captures also show a shorter cached/direct path
when the app already has accepted receiver/session state. It skips certificate
and ephemeral exchange and starts directly at authorization:

| Step | Phone command | Expected sensor response | Data side effect |
| --- | --- | --- | --- |
| 1 | `0x11` StartAuthorization | Prefix `0x08` ChallengeLoadDone | Sensor notifies R1 challenge |
| 2 | `0x08` SendChallengeLoadDone | Prefix `0x08` PatchChallengeLoadDone | Sensor notifies Phase 6 |

RoundWhiteDiscKit exposes this as `PairingFlow.runCachedReconnectPreamble(...)` and
`PairingFlow.runCachedReconnectHandshake(...)`. If the cached/direct path is
rejected before Phase 6, integrations should fall back to the full command-gated
authorization sequence above. The cached path reuses the `kAuth` saved from the
pairing that established it.

### Phase 5 Phone Challenge

The sensor emits a 23-byte authorization challenge:

```text
R1_16 || nonce7
```

The phone generates `R2_16` and sends a Phase 5 message to `secChallengeData`.
The logical plaintext is:

```text
R1_16 || R2_16 || tail4
```

For the supported pairing/recovery flows, `tail4` is the 4-byte BLE PIN from
the NFC activation/switch response or persisted sensor state.

The wire form is:

```text
ccm_ciphertext36 || ccm_tag4 || zero_pad14
```

The CCM tag length is 4 bytes. The 14-byte zero pad brings the message to 54
bytes so it fragments into three 18-byte write chunks. The CCM nonce is the
7-byte nonce from the sensor's R1 challenge.

### Phase 6 Sensor Response

The sensor Phase 6 response on `secChallengeData` is 67 bytes:

```text
ccm_ciphertext56 || ccm_tag4 || nonce7
```

After CCM decrypt and tag verification, the plaintext is:

```text
R2_16 || R1_16 || kEnc16 || ivEnc8
```

The phone must verify that Phase 6 echoes the phone's R2 and the sensor's R1.
`kEnc` and `ivEnc` are then used for the encrypted post-authorization data
plane.

Observed reconnect/recovery can use either the cached/direct sequence or the
full command-gated authorization sequence. In both cases, `StartAuthorization`,
Phase 5, and Phase 6 are still required before subscribing to post-auth
data-plane traffic.

## Data Plane

After authorization, enable notifications on the data characteristics. The
package refreshes CCCDs for `patchControl`, `eventLog`, `historicData`,
`clinicalData`, `factoryData`, `glucoseData`, and `patchStatus`.

### Frame Trailer

Encrypted notification bodies use a two-byte little-endian sequence trailer:

```text
encrypted_payload || sequence_lo || sequence_hi
```

RoundWhiteDiscKit exposes those bytes as `seq`, `type`, and `sequenceNumber`.

### Data-Plane Encryption

Data-plane payloads use AES-CCM-128 with a 4-byte tag. The CCM key is Phase 6
`kEnc`. The 13-byte nonce is:

```text
sequence_LE2 || packetDescriptor3 || ivEnc8
```

Known packet descriptors:

| Kind | Descriptor |
| --- | --- |
| `kind0` | `00 00 00` |
| `handshake` | `00 00 0f` |
| `kind2` | `00 00 f0` |
| `kind3` | `00 0f 00` |
| `kind4` | `00 f0 00` |
| `kind5` | `0f 00 00` |
| `kind6` | `f0 00 00` |
| `patchData` | `44 00 00` |

Preferred inbound descriptors currently used by the decoder:

| Channel | Preferred kind |
| --- | --- |
| `patchStatus` | `kind2` |
| `glucoseData` | `kind3` |
| `historicData` | `kind4` |

If the preferred descriptor fails CCM verification, RoundWhiteDiscKit can try all
known descriptors and accept the first one that validates.

### Patch Status Plaintext

`patchStatus` plaintext is 12 bytes:

| Offset | Size | Field |
| --- | ---: | --- |
| 0 | 2 | `lifeCount` |
| 2 | 2 | `errorData` |
| 4 | 2 | `eventDataRaw`; app display value is currently `4000 + eventDataRaw` |
| 6 | 1 | Event index |
| 7 | 1 | Patch state |
| 8 | 2 | Current life count in minutes |
| 10 | 1 | Stack disconnect reason |
| 11 | 1 | App disconnect reason |

The disconnect-reason bytes are diagnostic signal/reconnect evidence. They do
not by themselves indicate sensor shutdown, and RoundWhiteDiscKit keeps them separate
from patch-state and `errorData` terminal-state decoding.

Known patch state:

| Value | Meaning / handling |
| --- | --- |
| `3` | Expired/error handling state; clients may request backfill before shutdown |
| `4` | Active |
| `5` | Expired/error handling state; distinct from the terminated state |
| `6` | Terminated / shut down |
| `7` | Expired/error handling state |
| `8` | Terminated / shut down |

RoundWhiteDiscKit names only state `4` as `.active` and exposes other patch-state
values raw. Convenience helpers group states `3`, `5`, and `7` as
expired/error handling states, and states `6` and `8` as already terminated.
Integrations should keep unknown patch-state values visible in logs rather than
coercing them into a terminal state.

The `errorData` field carries the sensor error/condition code. The patch-status
record shares the `lifeCount` / `errorData` / `eventData` / `index` shape of the
sensor's event-log record, and `errorData` is the error field of that record.
Current compatibility mapping for `errorData`:

| `errorData` | Meaning | BLE advertising / session note |
| --- | --- | --- |
| `0` | No error | Active/normal |
| `3` | Insertion failure (sensor failed to start) | Check-sensor / replacement condition |
| `5` | Expired (normal end-of-wear) | Sensor-ended notification; can still advertise over BLE after wear duration |
| `6` | Terminated / shut down | Sensor-ended/terminated condition; stops advertising after shutdown |
| `7` | Transmission error vocabulary, but replace-sensor UI handling | Replace-sensor notification condition in observed Android app response |
| `8` | Terminated / shut down | Replace-sensor / termination condition; stops advertising after shutdown |

`5` and `6` are distinct states. Code `5` is the normal end-of-wear condition
at the end of `wearDuration`; Libre 3 sensors can still advertise over BLE after
that transition. Codes `6` and `8` are terminated/shutdown conditions. The
matching patch-control shutdown command is `05 00 00 00 00 00 00`, and that
command is reachable from the app's shutdown/end-session handling. However,
the live ordering of any outbound shutdown write versus the sensor's own
terminate has not been captured, so integrations should not assume that every
physical failure or removal trigger is preceded by an outbound shutdown write. RoundWhiteDiscKit exposes the decode as
`PatchStatus.sensorError` (`Libre3SensorError`) plus
`PatchStatus.isShutdownTerminated` and `PatchStatus.isInsertionFailure`
convenience flags.

For product notifications, RoundWhiteDiscKit also exposes
`PatchStatus.sensorAttention` and `PatchStatus.shouldNotifyReplaceSensor`.
This keeps the raw protocol code visible while matching the current Abbott-app
response layer: `3 -> checkSensor`, `5/6 -> sensorEnded`, and
`7/8 -> replaceSensor`. When `errorData == 0`, patch-state fallback treats
state `3` as check-sensor, states `5`/`6` as sensor-ended, and states `7`/`8`
as replace-sensor. The recovered Android alarm alert record does not expose the
underlying Abbott `replaceSensorError` bit directly, so this mapping is the
stable RoundWhiteDiscKit surface for prompt client notifications.

Lifecycle helpers currently model a 60-minute warmup and optional total wear
duration supplied by the app.

### Realtime Glucose Plaintext

`glucoseData` plaintext is 29 bytes.

Known fields:

| Offset | Size | Field |
| --- | ---: | --- |
| 0 | 2 | Realtime life count |
| 2 | 2 | Current packed glucose/status word |
| 4 | 2 | Signed rate of change, hundredths of mg/dL/min |
| 6 | 2 | Temperature/status raw field |
| 8 | 2 | Projected glucose raw field |
| 10 | 2 | Historical life count |
| 12 | 2 | Historical packed glucose/status word |
| 14 | 1 | Trend and actionability bits |
| 15 | 2 | Uncapped current glucose raw value |
| 17 | 2 | Uncapped historical glucose raw value |
| 19 | 2 | Temperature raw field |
| 21 | 8 | Fast/raw data bytes |

Packed current glucose word:

- Bits 0...12: displayed glucose value candidate.
- Bits 13...14: sensor condition/status bits.
- Bit 15 set: non-displayable data-quality status.

Packed historical glucose word:

- Bits 0...12: historical glucose value candidate.
- Bits 13...14: historical result range status.
- Bit 15 set: non-displayable data-quality status.

Trend/actionability byte:

- Bits 0...2: trend.
- Bit 3: actionable flag.
- Bits 4...7: additional status bits.

Known trend values:

| Value | Meaning |
| --- | --- |
| `0` | Not determined |
| `1` | Falling quickly |
| `2` | Falling |
| `3` | Stable |
| `4` | Rising |
| `5` | Rising quickly |

Known sensor condition values:

| Value | Meaning |
| --- | --- |
| `0` | OK |
| `1` | Invalid |
| `2` | ESA |

Known historical result-range values:

| Value | Meaning |
| --- | --- |
| `0` | In range |
| `1` | Below range |
| `2` | Above range |

Current usability rule in RoundWhiteDiscKit:

```text
current glucose is displayable
AND current data-quality status is good
AND sensor condition is OK
AND no lifecycle block such as warmup or expiry is active
```

When a `SensorLifecycle` is available, the framework's high-level quality
assessment also blocks current glucose during warmup and after expiry. This is
intentionally separate from the raw `glucoseData` quality bits: warmup comes
from lifecycle timing, typically the `patchStatus.currentLifeCount` field and a
60-minute default warmup window.

`RealtimeGlucoseReading.currentGlucoseQualityAssessment(lifecycle:)` returns a
structured `Libre3GlucoseQualityAssessment` with `isUsable`, raw evidence, one
or more blocking issues, and advisory issues:

| Issue | Meaning |
| --- | --- |
| `sensorWarmup(remainingMinutes:)` | Lifecycle is still inside the warmup window |
| `sensorExpired` | Lifecycle is past the supplied wear duration |
| `currentGlucoseUnavailable` | Raw current glucose is outside displayable handling |
| `currentDataQuality` | Packed current word has a non-good data-quality state |
| `sensorCondition` | Packed current word reports a non-OK sensor condition |
| `notActionable` | Advisory: trend/status byte says current glucose is not actionable |

The non-good data-quality and sensor-condition values are deliberately exposed
as raw/provisional enums where their precise clinical labels are not yet
grounded. Apps should treat blocking issues as suppressing automated use unless
they have stronger product-specific evidence. Actionability is advisory in
RoundWhiteDiscKit: an otherwise clean non-actionable reading remains usable, while the
`notActionable` issue is exposed through `advisories` for callers that want a
stricter policy.

Apps that process decoded data-plane packets can use `Libre3DataPlaneState` to
remember the latest `patchStatus` lifecycle and apply it automatically to each
subsequent realtime glucose reading. This avoids treating a technically
well-formed glucose frame as usable while the sensor is still in warmup.

Display glucose range handling:

| Raw value | Display behavior |
| --- | --- |
| `1...38` | Below display range, display as 39 mg/dL |
| `39...501` | Valid displayed mg/dL |
| `502...999` | Above display range, display as 501 mg/dL |
| Other values | Unavailable |

The temperature/status and fast-data fields are exposed as raw evidence until
their units and clinical semantics are fully named.

### Historical Backfill

Historical and clinical backfill are requested by encrypted `patchControl`
writes. Patch-control plaintext commands are 7 bytes before data-plane
encryption.

Known command builders:

| Command | Plaintext shape |
| --- | --- |
| Historical backfill greater/equal | `01 00 selector lifeCount_LE2 00 00` |
| Clinical backfill greater/equal | `01 01 selector lifeCount_LE2 00 00` |
| Event log from index | `04 index 00 00 00 00 00` |
| Factory data | `06 00 00 00 00 00 00` |
| Shutdown patch | `05 00 00 00 00 00 00` |

Known client builders encode shutdown as command byte `0x05` with six zero
payload bytes. That identifies the terminal command format; it does not imply
that every terminal status was caused by an outbound write.

The shutdown command is terminal session control. It is not part of routine
disconnect, reconnect, or bounded backfill.

Historical reading pages are 14-byte plaintext records:

```text
startLifeCount_LE2 || value0_LE2 || value1_LE2 || ... || value5_LE2
```

Samples are spaced by 5 life-count minutes:

```text
startLifeCount, startLifeCount + 5, ..., startLifeCount + 25
```

Factory data is a separate stream on `factoryData`; do not treat the first-pair
factory-data push as a historical burst. Its decrypted payload appears to carry
factory calibration parameters plus a trailing CRC16, but individual fields are
not yet part of the public model.

RoundWhiteDiscKit can summarize ordered backfill samples and identify gaps larger than
the 5-minute sample spacing.

`Libre3DataPlaneState` tracks the last usable realtime glucose life count and
can produce bounded historical/clinical backfill commands for reconnect. The
commands intentionally request `>= lastAcceptedGlucoseLifeCount`, accepting one
possible duplicate sample so an integration does not accidentally skip the
handoff boundary. Apps that persist `Libre3SensorState` can seed
`Libre3DataPlaneState` from the saved last glucose point on launch, then write
the newest accepted point back before suspension or after each emitted sample.

## Background Operation On iOS

Libre 3 appears to remain connected after authorization and emit minute-spaced
`glucoseData` notifications. For iOS apps, the expected background strategy is:

- Enable `bluetooth-central`.
- Use a stable `CBCentralManagerOptionRestoreIdentifierKey`.
- Create the central manager early during app launch.
- Restore connected or pending peripherals from CoreBluetooth state restoration.
- Keep notifications subscribed after authorization.
- On disconnect, register for CoreBluetooth connection events for the known
  peripheral and/or Libre 3 service UUID, then issue a bounded reconnect.
- Track the last accepted glucose life count so reconnect backfill can request a
  bounded range rather than draining all available history.

## Open Protocol Questions

Known areas that need more grounding before app integrations should present a
fully polished clinical model:

- Exact clinical semantics for every non-zero data-quality and sensor-condition
  value.
- Units/calibration for temperature and temperature-status fields.
- Complete patch-state and error-state enum coverage, especially for uncommon
  physical failure and removal scenarios.
- Live ordering between patch-status failure states, optional backfill, shutdown
  patch-control writes, patch-control responses, and BLE disconnect.
- Completion markers and all record variants for event, clinical, and factory
  data streams.
