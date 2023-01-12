import Foundation

internal protocol ConfigurationManagerType {
    func saveHowmuchModuleConfiguration(_ config: HowmuchModuleConfiguration)
}

internal class ConfigurationManager: ConfigurationManagerType {
    private let exchangeMoneyService: ExchangeMoneyServiceType
    private let exchangeMoneyRepository: ExchangeMoneyRepositoryType

    init(exchangeMoneyService: ExchangeMoneyServiceType,
         exchangeMoneyRepository: ExchangeMoneyRepositoryType) {
        self.exchangeMoneyService = exchangeMoneyService
        self.exchangeMoneyRepository = exchangeMoneyRepository
    }

    func saveHowmuchModuleConfiguration(_ config: HowmuchModuleConfiguration) {
        exchangeMoneyRepository.saveHowmuchModuleConfiguration(config)
    }

}
