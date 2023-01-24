import Foundation

internal protocol ConfigurationManagerType {
    func save(_ config: HowmuchModuleConfiguration)
}

internal class ConfigurationManager: ConfigurationManagerType {
    private let currencyExchangeRepository: CurrencyExchangeRepositoryType

    init(currencyExchangeRepository: CurrencyExchangeRepositoryType) {
        self.currencyExchangeRepository = currencyExchangeRepository
    }

    func save(_ configuration: HowmuchModuleConfiguration) {
        currencyExchangeRepository.saveHowmuchModuleConfiguration(configuration)
    }
}
