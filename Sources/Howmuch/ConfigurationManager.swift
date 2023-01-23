import Foundation

internal protocol ConfigurationManagerType {
    func saveHowmuchModuleConfiguration(_ config: HowmuchModuleConfiguration)
}

internal class ConfigurationManager: ConfigurationManagerType {
    private let currencyExchangeService: CurrencyExchangeServiceType
    private let currencyExchangeRepository: CurrencyExchangeRepositoryType

    init(currencyExchangeService: CurrencyExchangeServiceType,
         currencyExchangeRepository: CurrencyExchangeRepositoryType) {
        self.currencyExchangeService = currencyExchangeService
        self.currencyExchangeRepository = currencyExchangeRepository
    }

    func saveHowmuchModuleConfiguration(_ configuration: HowmuchModuleConfiguration) {
        currencyExchangeRepository.saveHowmuchModuleConfiguration(configuration)
    }

}
