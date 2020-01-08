import Foundation

/**
 ログイン周りを全ていい感じにやるやつ
 */
class NicoAccountService {
    let commons: NicoCommonsClient
    let urlSession: URLSession
    let setting: SettingData
    let sessionParser: RegexProcessor
    let cookieStorage: HTTPCookieStorage
    
    static let shared = NicoAccountService()
    
    public init (
        commons: NicoCommonsClient = NicoCommonsClient(),
        urlSession: URLSession = URLSession.shared,
        setting: SettingData = SettingData.shared,
        sessionParser: RegexProcessor = RegexProcessor(),
        cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared
    ) {
        self.commons = commons
        self.urlSession = urlSession
        self.setting = setting
        self.sessionParser = sessionParser
        self.cookieStorage = cookieStorage
    }
    
    // SettingData からパスワードとかをとってきて、ログインして、
    // 結果を SettingData に保存
    public func login() {
        let mail = SettingData.shared.email
        let password = SettingData.shared.password
        self.commons.login(
            mail: mail,
            password: password,
            onSuccess: self.onLoginSucceess,
            onFail: self.onLoginFailed
        )
    }
    
    private func onLoginSucceess(userSession: String) {
        // userSessionを端末で保持
        self.setting.userSession = userSession
        
        // userIdを端末で保持
        // sessionが取れているのでuserIdが取れないってことはないはず
        let userId = self.sessionParser.getUserIdFromSession(userSession: userSession)!
        self.setting.userId = userId
        self.setSessionToCookieStorage()
    }
    
    /// UserData に入っている Cookie を使ってリクエストするように設定
    public func setSessionToCookieStorage() {
        let cookie = "user_session=\(self.setting.userSession);Secure"
        let cookieHeaderField = ["Set-Cookie": cookie]
        
        let commonsUrl = URL(string: "https://commons.nicovideo.jp")!
        let cookies = HTTPCookie.cookies(
            withResponseHeaderFields: cookieHeaderField,
            for: commonsUrl
        )
        self.cookieStorage.setCookies(
            cookies,
            for: commonsUrl,
            mainDocumentURL: commonsUrl
        )
        let deliverUrl = URL(string: "https://deliver.commons.nicovideo.jp")!
        let deliverCcookies = HTTPCookie.cookies(
            withResponseHeaderFields: cookieHeaderField,
            for: deliverUrl
        )
        self.cookieStorage.setCookies(
            deliverCcookies,
            for: deliverUrl,
            mainDocumentURL: deliverUrl
        )
    }
    
    private func onLoginFailed(message: String) {
        print(message)
    }
}
