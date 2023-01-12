import Foundation

internal protocol ExchangeMoneyRepositoryType: AnyObject {
    var defaultHttpSessionConfiguration: URLSessionConfiguration { get }
}

internal class ExchangeMoneyRepository: ExchangeMoneyRepositoryType {

    private(set) var defaultHttpSessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        return configuration
    }()
    
}
