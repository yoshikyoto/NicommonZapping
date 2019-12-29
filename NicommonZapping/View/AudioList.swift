import SwiftUI
import UIKit

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    @State private var isShowingSettingModal = false
    
    var body: some View {
        NavigationView {
            List(self.audioData.audios, id: \.id) { audio in
                NavigationLink(destination: ContentView()) {
                    AudioRow(audio: audio)
                }
            }
            // NavigationViewにタイトルをつける
            // NavigationView{} の中に書くので注意
            .navigationBarTitle(Text("音声"))
                
            // NavigationView の右上にボタンを配置する
            // action と中身を必ず設定しなければならない
            .navigationBarItems(trailing: Button(action: {
                // クリックした時のアクション
                self.isShowingSettingModal.toggle()
            }){
                // ボタンの文字
                Text("設定")
            }.sheet(isPresented: self.$isShowingSettingModal) {
                SettingView().environmentObject(SettingData.shared)
            })
        }
    }
}


struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
