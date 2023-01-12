import Foundation

internal protocol ExchangeMoneyRepositoryType: AnyObject {
    var defaultHttpSessionConfiguration: URLSessionConfiguration { get }

    func saveApiKey(_ config: HowmuchModuleConfiguration)
    func getApiKey() -> String?
}

internal class ExchangeMoneyRepository: ExchangeMoneyRepositoryType {

    private(set) var howmuchModuleConfiguration: HowmuchModuleConfiguration?
    private(set) var defaultHttpSessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        return configuration
    }()

    func saveApiKey(_ config: HowmuchModuleConfiguration) {
        self.howmuchModuleConfiguration = config
    }

    func getApiKey() -> String? {
        return howmuchModuleConfiguration?.apiKey
    }
    
}
