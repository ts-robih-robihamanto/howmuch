import Foundation

public enum CurrencyCode: String {
    case jpy
    case usd
    case gbp
    case eur
    case idr

    public var code: String {
        rawValue.uppercased()
    }
}
