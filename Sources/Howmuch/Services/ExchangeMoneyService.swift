import Foundation
import RLogger

internal protocol ExchangeMoneyServiceType {
    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Result<Double, ExchangeMoneyServiceError>
}

internal enum ExchangeMoneyServiceError: Error {
    case requestError(RequestError)
    case missingOrInvalidConfigURL
}

internal struct ExchangeMoneyService: ExchangeMoneyServiceType {

    private let exchangeMoneyRepository: ExchangeMoneyRepositoryType
    private(set) var httpSession: URLSession
    private typealias ApiEndpoint = Constants.ApiEndpoint

    init(exchangeMoneyRepository: ExchangeMoneyRepositoryType) {
        self.exchangeMoneyRepository = exchangeMoneyRepository
        self.httpSession = URLSession(configuration: exchangeMoneyRepository.defaultHttpSessionConfiguration)
    }

    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Result<Double, ExchangeMoneyServiceError> {
        let convertCurrencyURLString = ApiEndpoint.baseURL + "/convert"
//        guard let apiKey = exchangeMoneyRepository.get
            guard let convertCurrencyURL = URL(string: convertCurrencyURLString) else {
            return.failure(.missingOrInvalidConfigURL)
        }

        let response = requestFromServerSync(url: convertCurrencyURL, httpMethod: .get, addtionalHeaders: <#T##[HeaderAttribute]?#>)
        
        
        return .success(0)
    }

}

extension ExchangeMoneyService: HttpRequestable {
    
    func requestFromServerSync(url: URL,
                               httpMethod: HttpMethod,
                               parameters: [String: Any]? = nil,
                               addtionalHeaders: [HeaderAttribute]?) -> RequestResult {

        if Thread.current.isMainThread {
            RLogger.debug(message: "Performing HTTP task synchronously on main thread. This should be avoided.")
            assertionFailure()
        }

        var result: RequestResult?

        requestFromServer(
            url: url,
            httpMethod: httpMethod,
            parameters: parameters,
            addtionalHeaders: addtionalHeaders,
            completion: { result = $0 })

        guard let unwrappedResult = result else {
            RLogger.debug(message: "Error: Didn't get any result - completion handler not called!")
            assertionFailure()
            return .failure(.unknown)
        }

        return unwrappedResult
    }

    func buildHttpBody(with parameters: [String : Any]?) -> Result<Data, Error> {
        .failure(RequestError.bodyIsNil)
    }

}
