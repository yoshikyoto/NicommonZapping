import SwiftUI
import UIKit

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    
    var body: some View {
        NavigationView {
            List(self.audioData.audios, id: \.id) { audio in
                NavigationLink(destination: ContentView()) {
                    AudioRow(audio: audio)
                }
            }
            .navigationBarTitle(Text("音声"))
            .navigationBarItems(trailing: Button(action: {
                // 何もしない
            }){
                Text("設定")
            })
            
        }
    }
}


struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
