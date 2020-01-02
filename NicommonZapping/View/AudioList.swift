import SwiftUI
import UIKit
import AVKit


struct PlayerView: View {
    @EnvironmentObject var audioData: AudioData
    var body: some View {
        HStack {
            TimeView(seconds: audioData.playerCurrentTimeSeconds)
            Text("/")
            TimeView(seconds: audioData.playerItemDurationSeconds)
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
                        // Listの中にButtonを置くと領域全部がボタンになってしまうみたいなので
                        // ImageにonTapGestureをつけている
                        Image(systemName: "star.fill")
                            .imageScale(.medium)
                            .foregroundColor(.yellow)
                            .frame(width: 44, height: 44)
                            .onTapGesture {
                                print("お気に入り")
                            }
                        // 再生はList全体に判定があって問題無いのでButtonで実装している
                        // Buttonのサイズは適当にしているが、
                        // List全体似判定が起こるのは仕様じゃないかもしれない
                        Button(action: {
                            print("再生します")
                            MaterialPlayer.shared.play(id: audio.id)
                        }) {
                            HStack {
                                Text(audio.title)
                                Spacer()
                            }
                        }// .background(Color.gray) // 見やすくするためのカラー
                    }
                }
                PlayerView().environmentObject(self.audioData)
                    
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
