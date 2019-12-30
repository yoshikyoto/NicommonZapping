import Foundation

/// 設定を保存する
final class SettingData: ObservableObject {
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
    
    /// シングルトン
    static let shared = SettingData()
    
    /// シングルトンなので外部での初期化禁止
    private init() {
    }
}

class SettingRepository {
    let userDefaults: UserDefaults
    
    /// シングルトン
    static let shared = SettingRepository()
    
    /// シングルトンなので init は private
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
}
