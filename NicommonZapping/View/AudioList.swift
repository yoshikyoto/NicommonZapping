import SwiftUI
import UIKit

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    var body: some View {
        List(self.audioData.audios, id: \.id) { audio in
            NavigationLink(destination: ContentView()) {
                AudioRow(audio: audio)
            }
        }
    }
}


struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
