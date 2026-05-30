import SwiftUI

struct WatchContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "waveform.path.ecg")
                .font(.title2)

            Text(AppInfo.name)
                .font(.headline)

            Text("Watch app")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
    }
}
