import UIKit
import AVKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


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
        commons.login()
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
                var urlComponents = URLComponents(string: "https://deliver.commons.nicovideo.jp/download/nc208577")!
                urlComponents.queryItems = [
                    URLQueryItem(name: "cid", value: String(material.id)),
                    // TODO tsの値をちゃんと設定する
                    URLQueryItem(name: "ts", value: "20191228103003")
                ]
                
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
                audioData.audios = audios
                let selectedAudio = audios[0]
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

