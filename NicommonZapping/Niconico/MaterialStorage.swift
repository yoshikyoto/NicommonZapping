import Foundation

/// ファイルの保存などを行うクラス
public class MaterialStorage {
    let cachesDir: URL
    let filenameRepository: MaterialFilenameRepository
    
    public init() {
        self.cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.filenameRepository = MaterialFilenameRepository()
    }
    
    /// 素材のファイル名を渡すとファイルへのURLを返す
    private func getUrl(filename: String) -> URL {
        return self.cachesDir.appendingPathComponent(filename)
    }
    
    /// 素材を保存する。保存できたら保存先のURLを返す
    public func save(data: Data, globalId: String, filename: String) -> URL?{
        // globalId と filename の対応を保存しておく
        self.filenameRepository.set(globalId: globalId, filename: filename)
    
        do {
            // ファイル名からファイルパスを取得し、そこに保存す
            let url = self.getUrl(filename: filename)
            try data.write(to: url)
            print("ファイルを保存しました")
            print(url)
            return url
        } catch {
            // TODO 保存失敗
            print("ファイルの保存に失敗しました")
            return nil
        }
    }
    
    /// globalId を渡すとその素材が保存されているかどうかを返す
    public func exists(globalId: String) -> Bool {
        guard let url = self.getUrl(globalId: globalId) else {
            // ファイル名が保存されていないということはファイルも存在しないということである
            print("ファイル名が保存されていない")
            return false
        }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// globalId からキャッシュされているファイル名を取得する
    public func getUrl(globalId: String) -> URL? {
        guard let filename = self.filenameRepository.get(globalId: globalId) else {
            print("ファイル名がUserDefaultには保持されていなかった")
            return nil
        }
        return self.getUrl(filename: filename)
    }
}

class MaterialFilenameRepository {
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    public func get(globalId: String) -> String? {
        return self.userDefaults.string(forKey: "filename:" + globalId)
    }
    
    public func set(globalId: String, filename: String) {
        print("ファイル名を保存しました globalId:\(globalId) filename:\(filename)")
        self.userDefaults.set(filename, forKey: "filename:" + globalId)
    }
}
