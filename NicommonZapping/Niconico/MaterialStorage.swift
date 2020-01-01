import Foundation

/// ファイルの保存などを行うクラス
public class MaterialStorage {
    let cachesDir: URL
    let filenameRepository: MaterialFilenameRepository
    
    public init() {
        self.cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.filenameRepository = MaterialFilenameRepository()
    }
    
    private func getUrl(filename: String) -> URL {
        return self.cachesDir.appendingPathComponent(filename)
    }
    
    public func save(data: Data, globalId: String, filename: String) -> URL?{
        self.filenameRepository.set(globalId: globalId, filename: filename)
    
        do {
            let url = self.getUrl(filename: filename)
            print(url)
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
