import Foundation
import RLogger

internal protocol CurrencyExchangeServiceType {
    func convertCurrency(from fromCode: CurrencyCode, to toCode: CurrencyCode, amount: Int) -> Result<Double, CurrencyExchangeServiceError>
}

internal enum CurrencyExchangeServiceError: Error {
    case jsonDecodingError(Error)
    case requestError(RequestError)
    case missingOrInvalidApiURL
    case internalServerError(UInt)
}

internal struct CurrencyExchangeService: CurrencyExchangeServiceType {

    private let currencyExchangeRepository: CurrencyExchangeRepositoryType
    private(set) var httpSession: URLSession
    private typealias ApiEndpoint = Constants.ApiEndpoint

    init(currencyExchangeRepository: CurrencyExchangeRepositoryType) {
        self.currencyExchangeRepository = currencyExchangeRepository
        self.httpSession = URLSession(configuration: currencyExchangeRepository.defaultHttpSessionConfiguration)
    }

    func convertCurrency(from fromCode: CurrencyCode, to toCode: CurrencyCode, amount: Int) -> Result<Double, CurrencyExchangeServiceError> {
        let convertCurrencyURLString = ApiEndpoint.baseURL + "/convert"
        guard let convertCurrencyURL = URL(string: convertCurrencyURLString) else {
            return.failure(.missingOrInvalidApiURL)
        }

        let parameters: [String: Any] = [
            "from" : fromCode.code,
            "to": toCode.code,
            "amount": amount
        ]

        let response = requestFromServerSync(
            url: convertCurrencyURL,
            httpMethod: .get,
            parameters: parameters,
            addtionalHeaders: buildRequestHeader())
        
        switch response {
        case .success((let data, _)):
            return parseResponse(data).mapError {
                return CurrencyExchangeServiceError.jsonDecodingError($0)
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

extension CurrencyExchangeService: HttpRequestable {
    
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

        if !headerBuilder.addApiKey(currencyExchangeRepository: currencyExchangeRepository) {
            RLogger.debug(message: "Must contain a valid apiKey for ApiLayer")
            assertionFailure()
        }

        return headerBuilder.build()
    }

    func buildURLRequest(url: URL, with parameters: [String: Any]?) -> Result<URLRequest, Error> {
        do {
            let request = try getCurrencyDataConvertRequest(parameters: parameters)
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = request.toQueryItems
            guard let url = urlComponents?.url else {
                return .failure(RequestError.urlIsNil)
            }
            return .success(URLRequest(url: url))
        } catch let error {
            RLogger.debug(message: "failed creating a request - \(error)")
            return .failure(error)
        }
    }
    
    private func getCurrencyDataConvertRequest(parameters: [String: Any]?) throws -> CurrencyDataConvertRequest {
        guard let parameters,
              let from = parameters["from"] as? String,
              let to = parameters["to"] as? String,
              let amount = parameters["amount"] as? Int else {
            throw RequestError.missingMetadata
        }
        
        return CurrencyDataConvertRequest(
            from: from,
            to: to,
            amount: amount)
    }

}
