import Foundation
import RLogger

internal protocol ExchangeMoneyServiceType {
    func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int) -> Result<Double, ExchangeMoneyServiceError>
}

internal enum ExchangeMoneyServiceError: Error {
    case jsonDecodingError(Error)
    case requestError(RequestError)
    case missingOrInvalidApiURL
    case internalServerError(UInt)
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
        guard let convertCurrencyURL = URL(string: convertCurrencyURLString) else {
            return.failure(.missingOrInvalidApiURL)
        }

        let response = requestFromServerSync(
            url: convertCurrencyURL,
            httpMethod: .get,
            addtionalHeaders: buildRequestHeader())
        
        switch response {
        case .success((let data, _)):
            return parseResponse(data).mapError {
                return ExchangeMoneyServiceError.jsonDecodingError($0)
            }
        case .failure(let requestError):
            switch requestError {
            case .httpError(let statusCode, _, _) where statusCode >= 500:
                return .failure(.internalServerError(statusCode))
            default:
                return .failure(.requestError(requestError))
            }
        }
    }

    private func parseResponse(_ response: Data) -> Result<Double, Error> {
        do {
            let response = try JSONDecoder().decode(CurrencyExchangeResponse.self, from: response)
            return .success(response.result)
        } catch {
            let description = "Failed to parse json"
            RLogger.debug(message: "\(description): \(error)")
            return .failure(error)
        }
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

    private func buildRequestHeader() -> [HeaderAttribute] {
        var headerBuilder = HeaderAttributesBuilder()

        if !headerBuilder.addApiKey(exchangeMoneyRepository: exchangeMoneyRepository) {
            RLogger.debug(message: "Must contain a valid apiKey for ApiLayer")
            assertionFailure()
        }

        return headerBuilder.build()
    }

}
