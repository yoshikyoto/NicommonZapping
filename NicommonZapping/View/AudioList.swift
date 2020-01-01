import SwiftUI
import UIKit
import AVKit

struct PlayerView: View {
    var body: some View {
        HStack {
            Text("Player")
        }
    }
}

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    @State private var isShowingSettingModal = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.audioData.audios, id: \.id) { audio in
                    HStack {
                        Image(systemName: "star.fill")
                            .imageScale(.medium)
                            .foregroundColor(.yellow)
                            .frame(width: 44, height: 44)
                            .onTapGesture {
                                print("お気に入り")
                            }
                        Text(audio.title).onTapGesture {
                            print(audio.title + "を再生します")
                            MaterialPlayer.shared.play(id: audio.id)
                        }
                    }
                }
                PlayerView()
                    
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
}


struct AudioList_Previews: PreviewProvider {
    static var previews: some View {
        AudioList()
    }
}
