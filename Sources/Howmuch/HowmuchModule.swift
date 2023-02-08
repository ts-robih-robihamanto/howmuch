import Foundation

internal class HowmuchModule {

    private let currencyExchangeRepository: CurrencyExchangeRepositoryType
    private let currencyExchangeService: CurrencyExchangeServiceType

    init(currencyExchangeRepository: CurrencyExchangeRepositoryType,
         currencyExchangeService: CurrencyExchangeServiceType) {
        self.currencyExchangeRepository = currencyExchangeRepository
        self.currencyExchangeService = currencyExchangeService
    }

    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Result<Double, CurrencyExchangeServiceError>) -> Void) {
        currencyExchangeService.convertCurrency(from: from, to: to, amount: amount) { result in
            switch result {
            case .success(let convertedCurrency):
                completion(.success(convertedCurrency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
