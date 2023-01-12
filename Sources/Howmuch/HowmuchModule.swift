import Foundation

internal class HowmuchModule {

    private let configurationManager: ConfigurationManagerType
    private let exchangeMoneyRepository: ExchangeMoneyRepositoryType
    private let exchangeMoneyService: ExchangeMoneyServiceType

    init(configurationManager: ConfigurationManager,
         exchangeMoneyRepository: ExchangeMoneyRepositoryType,
         exchangeMoneyService: ExchangeMoneyServiceType) {
        self.configurationManager = configurationManager
        self.exchangeMoneyRepository = exchangeMoneyRepository
        self.exchangeMoneyService = exchangeMoneyService
    }

    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Double {
        let result = exchangeMoneyService.convertCurrency(from: from, to: to, amount: amount)
        return 0.0
    }
}
