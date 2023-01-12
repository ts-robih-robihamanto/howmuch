import Foundation

internal protocol ExchangeMoneyRepositoryType: AnyObject {
    var defaultHttpSessionConfiguration: URLSessionConfiguration { get }

    func saveApiKey(forKey key: String)
    func getApiKey() -> String?
}

internal class ExchangeMoneyRepository: ExchangeMoneyRepositoryType {

    private(set) var apiKey: String?
    private(set) var defaultHttpSessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        return configuration
    }()

    func saveApiKey(forKey key: String) {
        self.apiKey = key
    }

    func getApiKey() -> String? {
        return apiKey
    }
    
}
