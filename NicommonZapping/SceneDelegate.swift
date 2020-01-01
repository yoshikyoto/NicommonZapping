import UIKit
import AVKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var player: AVPlayer?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        let audioData = AudioData()
        let audioList = AudioList().environmentObject(audioData)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: audioList)
            self.window = window
            window.makeKeyAndVisible()
        }

        let commons = NicoCommonsClient()
        commons.searchAudio(onSuccess: {data in
            var audios: [Audio] = []
            for material in data.materials {
                // サンプル再生
                // https://commons.nicovideo.jp/api/preview/get?cid=208577&ts=20191228103003
                //  - これだとflvが降ってくる
                //  - 再生できねぇ
                // フル再生
                // https://deliver.commons.nicovideo.jp/download/nc208577
                //  - ログインが必要
                //  - mp3とかwavとかが降ってくる
                var urlComponents = commons.getDownloadUrl(material: material)
                let audio = Audio(
                    id: material.id,
                    globalId: material.globalId,
                    title: material.title,
                    url: urlComponents.url! // エラーにはならないはず
                )
                audios.append(audio)
            }
            
            //audioList.audios = audios
            DispatchQueue.main.async {
                // audiosをリストに表示
                audioData.audios = audios
                let selectedAudio = audios[0]
                
                // print("http cookie storage")
                // ユーザーセッションを新しく取得する
                let userSession = commons.refreshUserSession()
                // print("userSession is")
                // print(userSession)
                
                // cookieにユーザーセッションを追加する
                // set-cookie の cookie を作成
                let cookie = "user_session=\(userSession);Secure"
                // print("set cookie:")
                // print(cookie)
                let cookieHeaderField = ["Set-Cookie": cookie]
                
                let commonsUrl = URL(string: "https://commons.nicovideo.jp")!
                let cookies = HTTPCookie.cookies(
                    withResponseHeaderFields: cookieHeaderField,
                    for: commonsUrl
                )
                HTTPCookieStorage.shared.setCookies(
                    cookies,
                    for: commonsUrl,
                    mainDocumentURL: commonsUrl
                )
                
                
                let deliverUrl = URL(string: "https://deliver.commons.nicovideo.jp")!
                let deliverCcookies = HTTPCookie.cookies(
                    withResponseHeaderFields: cookieHeaderField,
                    for: deliverUrl
                )
                HTTPCookieStorage.shared.setCookies(
                    cookies,
                    for: deliverUrl,
                    mainDocumentURL: deliverUrl
                )
                
                // 同意
                let agreement = NicoCommonsMaterialDownloader()
                agreement.agree(id: selectedAudio.id) { () in
                    let storage = MaterialStorage()
                    print("agreeできたのでファイルを再生します")
                    guard let url = storage.getUrl(globalId: selectedAudio.globalId) else {
                        return
                    }
                    print(url)
                    self.player = AVPlayer(url: url)
                    self.player!.play()
                }
            }
        })
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

