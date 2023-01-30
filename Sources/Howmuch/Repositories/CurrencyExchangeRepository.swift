import Foundation

internal protocol CurrencyExchangeRepositoryType: AnyObject {
    var defaultHttpSessionConfiguration: URLSessionConfiguration { get }

    func save(_ configuration: HowmuchModuleConfiguration)
    func apiKey() throws -> String
}

internal class CurrencyExchangeRepository: CurrencyExchangeRepositoryType {

    private(set) var howmuchModuleConfiguration: HowmuchModuleConfiguration?
    private(set) var defaultHttpSessionConfiguration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        return configuration
    }()

    func save(_ configuration: HowmuchModuleConfiguration) {
        self.howmuchModuleConfiguration = configuration
    }

    func apiKey() throws -> String {
        guard let howmuchModuleConfiguration else {
            throw HeaderAttributesBuilderError.emptyApiKey
        }
        return howmuchModuleConfiguration.apiKey
    }
    
}
