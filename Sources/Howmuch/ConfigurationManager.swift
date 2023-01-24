import Foundation

internal protocol ConfigurationManagerType {
    func save(_ config: HowmuchModuleConfiguration)
}

internal class ConfigurationManager: ConfigurationManagerType {
    private let currencyExchangeService: CurrencyExchangeServiceType
    private let currencyExchangeRepository: CurrencyExchangeRepositoryType

    init(currencyExchangeService: CurrencyExchangeServiceType,
         currencyExchangeRepository: CurrencyExchangeRepositoryType) {
        self.currencyExchangeService = currencyExchangeService
        self.currencyExchangeRepository = currencyExchangeRepository
    }

    func save(_ configuration: HowmuchModuleConfiguration) {
        currencyExchangeRepository.saveHowmuchModuleConfiguration(configuration)
    }
}
