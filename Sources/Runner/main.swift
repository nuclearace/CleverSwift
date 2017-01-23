import Foundation
import Cleverbot

var bot: Cleverbot!
var queue = DispatchQueue(label: "readQuee")

bot = Cleverbot {
    print("cleverbot is ready")
}

func readAsync() {
    queue.async {
        guard let input = readLine(strippingNewline: true) else { fatalError() }

        bot.say(input) {answer in
            print(answer)
        }

        readAsync()
    }
}

readAsync()

CFRunLoopRun()
