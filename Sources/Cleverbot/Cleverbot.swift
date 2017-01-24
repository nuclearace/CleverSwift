import CryptoSwift
import Foundation
import HTMLEntities

public class Cleverbot {
    private static let apiUrl = URL(string: base + resource)!
    private static let base = "http://www.cleverbot.com"
    private static let resource = "/webservicemin?uc=3210&botapi=swift-bot"
    private static let url = URL(string: base)!
    private static let header = [
        "User-Aget": "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0)",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Charset": "ISO-8859-1,utf-8;q=0.7,*;q=0.7",
        "Accept-Language": "en-us,en;q=0.8,en-us;q=0.5,en;q=0.3",
        "Cache-Control": "no-cache",
        "Host": "www.cleverbot.com",
        "Referer": "http://www.cleverbot.com/",
        "Pragma": "no-cache"
    ]

    public var onReady: () -> Void

    var data = [
            ("stimulus", ""),
            ("cb_settings_language", ""),
            ("cb_settings_scripting", "no"),
            ("islearning", "1"),
            ("icognoid", "wsf"),
            ("icognocheck", ""),

            ("start", "y"),
            ("sessionid", ""),
            ("vText8", ""),
            ("vText7", ""),
            ("vText6", ""),
            ("vText5", ""),
            ("vText4", ""),
            ("vText3", ""),
            ("vText2", ""),
            ("fno", "0"),
            ("prevref", ""),
            ("emotionaloutput", ""),
            ("emotionalhistory", ""),
            ("asbotname", ""),
            ("ttsvoice", ""),
            ("typing", ""),
            ("lineref", ""),
            ("sub", "Say"),
            ("cleanslate", "False")
    ]

    private let session = URLSession.shared

    private var conversation = ["", "", "", "", "", "", ""]

    public init(onReady: @escaping () -> Void) {
        self.onReady = onReady

        setup()
    }

    private func encodeData() -> String {
        return data.reduce("", {cur, dict in
            return "\(cur)&\(dict.0)=\(dict.1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
        })
    }

    @discardableResult
    private func addToConversation(_ answer: String) -> String {
        conversation.insert(answer, at: 0)

        return conversation.popLast()!
    }

    public func say(_ message: String, callback: @escaping (String) -> Void) {
        func postParse(response: String, sessionId: String) {
            callback(response)
            addToConversation(response)

            if data[7] == ("sessionid", "") {
                data[7] = ("sessionid", sessionId)
            }
        }

        data[0] = ("stimulus", message)
        var base = 14

        for answer in conversation {
            guard answer != "" else { break }

            data[base] = (data[base].0, answer)

            base -= 1
        }

        let encoded = String(encodeData().characters.dropFirst())
        let start = encoded.index(encoded.startIndex, offsetBy: 9)
        let finish = encoded.index(encoded.startIndex, offsetBy: 35)

        data[5] = ("icognocheck", String(encoded[start..<finish]).md5())

        let reencoded = String(encodeData().characters.dropFirst())
        var request = URLRequest(url: Cleverbot.apiUrl)

        request.httpMethod = "POST"
        request.allHTTPHeaderFields = Cleverbot.header
        request.httpBody = reencoded.data(using: .utf8)

        let task = session.dataTask(with: request) {data, response, error in
            guard let data = data, let unParsed = String(data: data, encoding: .utf8) else {
                callback("I fucked up")

                return
            }

            let parsed = unParsed.htmlUnescape().components(separatedBy: "\r\r\r\r\r\r").map({
                $0.components(separatedBy: "\r")
            })

            postParse(response: parsed[0][0], sessionId: parsed[0][1])
        }

        task.resume()
    }

    private func setup() {
        session.dataTask(with: URLRequest(url: Cleverbot.url)) {data, response, error in
            self.onReady()
        }.resume()
    }
}
