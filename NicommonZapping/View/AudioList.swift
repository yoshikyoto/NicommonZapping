import SwiftUI
import UIKit
import AVKit

struct PlayerView: View {
    @EnvironmentObject var audioData: AudioData
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                TimeView(seconds: audioData.playerCurrentTimeSeconds)
                Text("/")
                TimeView(seconds: audioData.playerItemDurationSeconds)
                Spacer().frame(width: 20)
            }
        }
    }
}

struct Stared: View {
    var body: some View {
        Image(systemName: "star.fill")
        .imageScale(.medium)
        .foregroundColor(.yellow)
        .frame(width: 44, height: 44)
    }
}

struct NotStared: View {
    var body: some View {
        Image(systemName: "star.fill")
        .imageScale(.medium)
        .foregroundColor(.gray)
        .frame(width: 44, height: 44)
    }
}

struct Pending: View {
    var body: some View {
        return Indicator().frame(width: 44, height: 44)
    }
}

struct AudioDownloading: View {
    var body: some View {
        return Indicator().frame(width: 44, height: 44)
    }
}

struct AudioPlaying: View {
    var body: some View {
        return Text("p").frame(width: 44, height: 44)
    }
}

struct AudioNothing: View {
    var body: some View {
        return Text("").frame(width: 44, height: 44)
    }
}

struct AudioList: View {
    @EnvironmentObject var audioData: AudioData
    @State private var isShowingSettingModal = false
    @State private var isStaring = false
    @State private var starComment = ""
    
    /// 曲名の前に表示するべきビューを返す
    func audioPrefix(audio: Audio) -> AnyView {
        // 再生中の曲
        if self.audioData.playingGlobalId == audio.globalId {
            return AnyView(AudioPlaying())
        }
        // ダウンロード中の曲
        if self.audioData.downloadingIds.contains(audio.id) {
            return AnyView(AudioDownloading())
        }
        // それ以外（何も表示しない）
        return AnyView(AudioNothing())
    }
    
    /// お気に入りボタンの状態を返す
    func starButton(audio: Audio) -> AnyView {
        guard let star = audioData.stars[audio.id] else {
            return AnyView(NotStared().onTapGesture {
                print("お気に入り")
                StarRepository.shared.save(materialId: audio.id)
            })
        }
        
        switch star {
        case .stared:
            return AnyView(Stared().onTapGesture {
                print("お気に入り解除")
            })
        case .pending:
            return AnyView(Pending())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.audioData.audios, id: \.id) { audio in
                    HStack {
                        self.audioPrefix(audio: audio)
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
                        
                        // Listの中にButtonを置くと領域全部がボタンになってしまうみたいなので
                        // ImageにonTapGestureをつけている
                        // タップしやすいように右端に設置する
                        self.starButton(audio: audio)
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
