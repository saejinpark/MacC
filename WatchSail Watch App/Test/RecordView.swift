import SwiftUI

struct RecordView: View {
    @ObservedObject var recordingManager = RecordingManager()
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sailing Recorder")
                .font(.title)
            
            if isRecording {
                Text("Recording in Progress...")
                    .foregroundColor(.red)
                Text("Data Points: \(recordingManager.currentSession.count)")
                    .font(.headline)
            } else {
                Text("Recording Stopped")
                    .foregroundColor(.green)
            }
            
            Button(action: {
                if isRecording {
                    recordingManager.stopRecording()
                } else {
                    recordingManager.startRecording()
                }
                isRecording.toggle()
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .font(.headline)
                    .padding()
                    .background(isRecording ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

#Preview {
    RecordView()
}
