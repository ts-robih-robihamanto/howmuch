import Foundation
extension NSError {

    static func iamError(description: String, data: Any? = nil, callerClass: AnyClass = NSError.self) -> NSError {
        let prefix = "Howmuch: "
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: prefix + description]
        if let data = data {
            userInfo["data"] = data
        }

        return NSError(domain: "Howmuch.\(callerClass)",
                       code: 0,
                       userInfo: userInfo)
    }
}
