import Foundation

public enum CurrencyCode: String {
    case jpy
    case usd
    case gbp
    case eur
    case idr

    var code: String {
        self.rawValue.uppercased()
    }
}
