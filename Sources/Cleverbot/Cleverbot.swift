import Foundation

public class Cleverbot {
    private let apiUrlString: String
    private let session = URLSession(configuration: .default, delegate: nil,
                                     delegateQueue: OperationQueue())

    private var cs = ""

    public init(apiKey: String) {
        apiUrlString =  "https://www.cleverbot.com/getreply?key=\(apiKey)"
    }

    public func say(_ input: String, callback: @escaping (String) -> Void) {
        let escaped = input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var urlString = apiUrlString + "&input=\(escaped)"
        if cs != "" {
            urlString += "&cs=\(cs)"
        }

        let request = URLRequest(url: URL(string: urlString)!)

        session.dataTask(with: request) {data, res, err in
            guard let data = data else {
                return callback("Cleverbot failed.")
            }

            guard let json = (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any] else {
                return callback("Cleverbot failed.")
            }

            if let cs = json["cs"] as? String {
                self.cs = cs
            }

            guard let response = json["output"] as? String else {
                return callback("Cleverbot failed.")
            }

            callback(response)
        }.resume()
    }

}
