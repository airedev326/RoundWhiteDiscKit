import SwiftUI
import RoundWhiteDiscKit

@main
struct RoundWhiteDiscApp: App {
    init() {
        installRuntimeTables()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    /// RoundWhiteDiscKit needs its remote runtime tables before pairing. A shipping host
    /// app downloads the blob (and caches it); this demo app bundles it instead.
    private func installRuntimeTables() {
        guard let url = Bundle.main.url(forResource: "roundwhitedisckit-runtime-tables-v2", withExtension: "xz") else {
            print("RoundWhiteDisc: runtime tables blob not bundled; run Scripts/build_runtime_tables_blob.py")
            return
        }
        do {
            try RoundWhiteDiscKit.installRuntimeTables(Data(contentsOf: url))
        } catch {
            print("RoundWhiteDisc: failed to install runtime tables: \(error)")
        }
    }
}
