import Foundation
public class StarRepository {
    let urlSession: URLSession
    let jsonDecoder: JSONDecoder
    let urlString: String = "https://nicommon-zapping.herokuapp.com"
    let setting: SettingData
    let audioData: AudioData
    
    static let shared = StarRepository()
    
    /// 別にシングルトンではない
    public init(
        urlSession: URLSession = URLSession.shared,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        setting: SettingData = SettingData.shared,
        audioData: AudioData = AudioData.shared
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
        self.setting = setting
        self.audioData = audioData
    }
    
    public func save(materialId: Int, comment: String = "") {
        let urlComponents = URLComponents(
            string: self.urlString + "/api/users/" + self.setting.userId + "/stars"
        )!
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        let formData = "material_id=\(materialId)&comment=\(comment)"
        print(formData)
        request.httpBody = formData.data(using: .utf8)!
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let data = data else {
                print("herokuからのレスポンスのデータが空っぽ")
                return
            }
            do {
                let response = try self.jsonDecoder.decode(
                    StarResponse.self,
                    from: data
                )
                self.processResponse(response: response)
            } catch {
                print("herokuレスポンスのパースエラー")
                return
            }
        }
        task.resume()
    }
    
    public func get() {
        let urlComponents = URLComponents(
            string: self.urlString + "/api/users/" + self.setting.userId + "/stars"
        )!

        let request = URLRequest(url: urlComponents.url!)
        let task = self.urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard let data = data else {
                print("herokuからのレスポンスのデータが空っぽ")
                return
            }
            do {
                let response = try self.jsonDecoder.decode(
                    StarResponse.self,
                    from: data
                )
                self.processResponse(response: response)
            } catch {
                print("herokuレスポンスのパースエラー")
                return
            }
        }
        task.resume()
    }
    
    private func processResponse(response: StarResponse) {
        let staredIds = response.materials.map { $0.id }
        print(staredIds)
        for (id, _) in audioData.stars {
            if staredIds.contains(id) {
                audioData.stars.removeValue(forKey: id)
            }
        }
        for staredId in staredIds {
            self.audioData.stars[staredId] = .stared
        }
    }
}

struct StaredMaterial: Codable {
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "material_id"
    }
}

struct StarResponse: Codable {
    let count: Int
    let materials: [StaredMaterial]
}
