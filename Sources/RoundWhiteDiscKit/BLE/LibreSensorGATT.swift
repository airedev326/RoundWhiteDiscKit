import Foundation
import CoreBluetooth

// GATT inventory for the Libre 3 sensor.
//
// All characteristics share the same base, with only bytes 2-3 varying:
//   0898XXXX-EF89-11E9-81B4-2A2AE2DBCCE4
//
// The role labels below come from `MSLibre3Constants.java` in the
// decompiled Abbott app (the AUTHORITATIVE source). Verified 2026-05-02
// by reading the constant declarations in
// `com.adc.trident.app.frameworks.mobileservices.libre3.MSLibre3Constants`.
// Earlier role guesses based on ATT handle inference were partially
// wrong; this file is the corrected version.

public enum LibreSensorGATT {

    /// Primary service UUID (`LIBRE3_DATA_SERVICE`) — used for scanning.
    public static let serviceUUID = CBUUID(string: "089810CC-EF89-11E9-81B4-2A2AE2DBCCE4")

    /// Two services exposed by the sensor — primary data + dedicated security.
    public static let securityServiceUUID = CBUUID(string: "0898203A-EF89-11E9-81B4-2A2AE2DBCCE4")
    public static let debugServiceUUID    = CBUUID(string: "08982400-EF89-11E9-81B4-2A2AE2DBCCE4")

    public enum Char {
        // ── DATA SERVICE characteristics ─────────────────────────────────
        /// Glucose data (per-minute encrypted readings).
        public static let glucoseData    = CBUUID(string: "0898177A-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Patch status notify (encrypted; one-minute reading channel in capture).
        public static let patchStatus    = CBUUID(string: "08981482-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Patch control write channel.
        public static let patchControl   = CBUUID(string: "08981338-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Historical data (the post-auth backfill burst on handle 0x0023).
        public static let historicData   = CBUUID(string: "0898195A-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Event log notify.
        public static let eventLog       = CBUUID(string: "08981BEE-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Clinical data (ad-hoc clinical events).
        public static let clinicalData   = CBUUID(string: "08981AB8-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Factory data.
        public static let factoryData    = CBUUID(string: "08981D24-EF89-11E9-81B4-2A2AE2DBCCE4")

        // ── SECURITY SERVICE characteristics ─────────────────────────────
        /// Phase 1/2 cert exchange (handle 0x002d in observed captures).
        public static let secCertData       = CBUUID(string: "089823FA-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Phase 5/6 challenge data (handle 0x002a in observed captures).
        public static let secChallengeData  = CBUUID(string: "089822CE-EF89-11E9-81B4-2A2AE2DBCCE4")
        /// Single-byte command/response (handle 0x0027 in observed captures —
        /// the protocol state-machine clock from `MSLibre3Constants`).
        public static let secCommandResponse = CBUUID(string: "08982198-EF89-11E9-81B4-2A2AE2DBCCE4")

        public static let all: [CBUUID] = [
            glucoseData, patchStatus, patchControl, historicData,
            eventLog, clinicalData, factoryData,
            secCertData, secChallengeData, secCommandResponse,
        ]

        /// Data-plane notify characteristics enabled after Phase 6 (or any
        /// subsequent re-handshake) before the sensor starts broadcasting
        /// glucose/status. Without this kick the BLE session stays open but
        /// the sensor is silent.
        ///
        /// Used by `SensorSession.refreshDataPlaneNotifications()`.
        public static let dataPlaneNotifying: [CBUUID] = [
            patchControl, eventLog, factoryData, glucoseData, patchStatus,
        ]

        /// Characteristics the security handshake reads its responses on — the
        /// only ones that must be notifying *before* the handshake runs. The
        /// data-plane characteristics are deliberately left unsubscribed at
        /// connect and enabled once afterwards (see
        /// `SensorSession.refreshDataPlaneNotifications`), so their post-handshake
        /// CCCD enable is a fresh first-time write that kicks streaming — no
        /// off→on toggle needed.
        public static let handshakeNotifying: [CBUUID] = [
            secCertData, secChallengeData, secCommandResponse,
        ]

        // ── PairingFlow alias mapping (now grounded in MSLibre3Constants) ──
        /// Cert + ephemeral exchange (Phases 1-4).
        public static let certHandshake = secCertData
        /// Challenge response (Phases 5-6).
        public static let challenge     = secChallengeData
    }
}
