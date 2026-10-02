import SwiftUI
import RoundWhiteDiscKit
import CoreBluetooth

struct ContentView: View {
    @State private var selectedTab = RootTab.nfc

    var body: some View {
        TabView(selection: $selectedTab) {
            NFCActivationView()
                .tabItem { Label("NFC", systemImage: "wave.3.right") }
                .tag(RootTab.nfc)
            ScanDebugView()
                .tabItem { Label("Scan (debug)", systemImage: "antenna.radiowaves.left.and.right") }
                .tag(RootTab.scan)
        }
    }

    private enum RootTab: Hashable {
        case nfc
        case scan
    }
}

/// Original scan-only debug view (kept for BLE diagnostics).
struct ScanDebugView: View {
    @StateObject private var model = ScanViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                statusLine
                discoveredList
                Spacer()
                controls
            }
            .padding()
            .navigationTitle("Scan")
        }
    }

    private var statusLine: some View {
        HStack {
            Circle()
                .fill(model.isReady ? Color.green : Color.orange)
                .frame(width: 10, height: 10)
            Text(model.statusText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    private var discoveredList: some View {
        Group {
            if model.discovered.isEmpty {
                Text(model.scanning ? "Scanning…" : "No sensors yet")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                List(model.discovered, id: \.id) { d in
                    Button {
                        model.connect(d)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(d.name ?? "Unknown").font(.body)
                            Text("\(d.id.uuidString.prefix(8))… · RSSI \(d.rssi)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                            if !d.advertisedServices.isEmpty {
                                Text("svc: " + d.advertisedServices.map { $0.uuidString }.joined(separator: ", "))
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var controls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle("Scan all (debug)", isOn: $model.scanAll)
                .font(.caption)
                .disabled(model.scanning)
            HStack {
                Button(model.scanning ? "Stop scan" : "Scan for sensor") {
                    model.toggleScan()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!model.isReady && !model.scanning)
                Spacer()
                Text("RoundWhiteDiscKit \(RoundWhiteDiscKit.version)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

@MainActor
final class ScanViewModel: ObservableObject {
    @Published var statusText: String = "Initializing…"
    @Published var isReady = false
    @Published var scanning = false
    @Published var scanAll = false
    @Published var discovered: [DiscoveredSensor] = []

    private let scanner = SensorScanner()
    private var scanTask: Task<Void, Never>?

    init() {
        Task { await self.bootstrap() }
    }

    func bootstrap() async {
        do {
            try await scanner.waitUntilReady()
            isReady = true
            statusText = "Bluetooth ready"
        } catch {
            statusText = "BLE error: \(error)"
        }
    }

    func toggleScan() {
        if scanning {
            scanner.stopScan()
            scanTask?.cancel()
            scanning = false
            statusText = "Scan stopped"
        } else {
            discovered.removeAll()
            scanning = true
            statusText = scanAll ? "Scanning for ALL BLE devices…" : "Scanning for Libre 3 sensor…"
            let filter: [CBUUID]? = scanAll ? nil : [LibreSensorGATT.serviceUUID]
            scanTask = Task { [weak self] in
                guard let self else { return }
                let stream = self.scanner.startScan(filter: filter)
                for await found in stream {
                    if !self.discovered.contains(where: { $0.id == found.id }) {
                        self.discovered.append(found)
                    }
                }
            }
        }
    }

    func connect(_ d: DiscoveredSensor) {
        scanner.stopScan()
        scanning = false
        statusText = "Connecting to \(d.name ?? String(d.id.uuidString.prefix(8)))…"
        Task { [weak self] in
            guard let self else { return }
            do {
                let session = try await self.scanner.connect(d.peripheral)
                self.statusText = "Connected. \(session.peripheral.services?.count ?? 0) services discovered."
            } catch {
                self.statusText = "Connect failed: \(error)"
            }
        }
    }
}

#Preview {
    ContentView()
}
