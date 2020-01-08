import Foundation

/// ログイン情報などの設定を保存する
public final class SettingData: ObservableObject {
    // UserDefault から値をとってくる
    @Published var email: String = SettingRepository.shared.getEmail() {
        // 値が変更された時は UserDefaultに に保存する
        didSet {
            SettingRepository.shared.setEmail(email: self.email)
        }
    }
    
    @Published var password: String = SettingRepository.shared.getPassword() {
        didSet {
            SettingRepository.shared.setPassword(password: self.password)
        }
    }
    
    @Published var userSession: String = SettingRepository.shared.getUserSession() {
        didSet {
            SettingRepository.shared.setUserSession(userSession: self.userSession)
        }
    }
    
    @Published var userId: String = SettingRepository.shared.getUserId() {
        didSet {
            SettingRepository.shared.setUserId(userId: userId)
        }
    }
    
    @Published var message: String = ""
    
    /// シングルトン
    public static let shared = SettingData()
    
    /// シングルトンなので外部での初期化禁止
    private init() {
    }
}

/// パスワードやcookieの情報を保存するリポジトリ
class SettingRepository {
    let userDefaults: UserDefaults
    
    /// シングルトン
    static let shared = SettingRepository()
    
    /// シングルトンなので外部での初期化禁止
    private init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    private func getString(key: String) -> String {
    let optional = self.userDefaults.string(forKey: key)
        if let str = optional {
            return str
        } else {
            return ""
        }
    }
    
    public func getEmail() -> String {
        return self.getString(key: "email")
    }
    
    public func setEmail(email: String) {
        self.userDefaults.set(email, forKey: "email")
    }
    
    public func getPassword() -> String {
        return self.getString(key: "password")
    }
    
    public func setPassword(password: String) {
        self.userDefaults.set(password, forKey: "password")
    }
    
    public func getUserSession() -> String {
        return self.getString(key: "userSession")
    }
    
    public func setUserSession(userSession: String) {
        self.userDefaults.set(userSession, forKey: "userSession")
    }
    
    public func getUserId() -> String {
        return self.getString(key: "userId")
    }
    
    public func setUserId(userId: String) {
        self.userDefaults.set(userId, forKey: "userId")
    }
}
