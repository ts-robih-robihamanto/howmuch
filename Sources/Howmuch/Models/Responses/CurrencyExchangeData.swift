import Foundation

struct CurrencyExchangeResponse: Codable {
    let success: Bool
    let query: CurrencyExchangeQuery
    let result: Double
}

struct CurrencyExchangeQuery: Codable {
    let from, to: String
    let amount: Int
}
