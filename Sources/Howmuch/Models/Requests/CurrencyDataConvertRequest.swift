import Foundation

struct CurrencyDataConvertRequest {
    let from: String
    let to: String
    let amount: Int
}

extension CurrencyDataConvertRequest {
    var toQueryItems: [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "from", value: from))
        queryItems.append(URLQueryItem(name: "to", value: to))
        queryItems.append(URLQueryItem(name: "amount", value: "\(amount)"))
        return queryItems
    }
}
