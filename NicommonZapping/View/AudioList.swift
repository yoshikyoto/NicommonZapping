import SwiftUI

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    var body: some View {
        NavigationView {
            List(self.audioData.audios, id: \.id) { audio in
                NavigationLink(destination: ContentView()) {
                    AudioRow(audio: audio)
                }
            }
        }.navigationBarTitle(Text("音声"))
    }
}

struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
