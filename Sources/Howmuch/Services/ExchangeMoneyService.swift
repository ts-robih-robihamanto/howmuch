import Foundation

internal protocol ExchangeMoneyServiceType {
    func convert(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Result<Double, ExchangeMoneyServiceError>
}

internal enum ExchangeMoneyServiceError: Error {
    case requestError(RequestError)
    case missingOrInvalidConfigURL
}

internal struct ExchangeMoneyService: ExchangeMoneyServiceType {

    private let exchangeMoneyRepository: ExchangeMoneyRepositoryType
    private(set) var httpSession: URLSession

    init(exchangeMoneyRepository: ExchangeMoneyRepositoryType) {
        self.exchangeMoneyRepository = exchangeMoneyRepository
        self.httpSession = URLSession(configuration: exchangeMoneyRepository.defaultHttpSessionConfiguration)
    }

    func convert(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Result<Double, ExchangeMoneyServiceError> {
        
//        let response = requeasy
        
        return .success(0)
    }

}
