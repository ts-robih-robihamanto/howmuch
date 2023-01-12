import Foundation

internal class HowmuchModule {

    private let configurationManager: ConfigurationManagerType
    private let currencyExchangeRepository: CurrencyExchangeRepositoryType
    private let currencyExchangeService: CurrencyExchangeServiceType

    init(configurationManager: ConfigurationManager,
         currencyExchangeRepository: CurrencyExchangeRepositoryType,
         currencyExchangeService: CurrencyExchangeServiceType) {
        self.configurationManager = configurationManager
        self.currencyExchangeRepository = currencyExchangeRepository
        self.currencyExchangeService = currencyExchangeService
    }

    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Double {
        let result = currencyExchangeService.convertCurrency(from: from, to: to, amount: amount)
        return 0.0
    }
}
