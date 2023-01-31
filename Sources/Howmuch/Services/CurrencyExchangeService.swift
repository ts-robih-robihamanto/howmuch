import Foundation
import RLogger

internal protocol CurrencyExchangeServiceType {
    func convertCurrency(
        from fromCode: CurrencyCode,
        to toCode: CurrencyCode,
        amount: Int,
        completion: @escaping (Result<Double, CurrencyExchangeServiceError>) -> Void)
}

internal enum CurrencyExchangeServiceError: Error {
    case jsonDecodingError(Error)
    case requestError(RequestError)
    case missingOrInvalidApiURL
    case internalServerError(UInt)
}

internal struct CurrencyExchangeService: CurrencyExchangeServiceType {

    internal enum ParametersKey: String {
        case from
        case to
        case amount
    }

    private let currencyExchangeRepository: CurrencyExchangeRepositoryType
    private(set) var httpSession: URLSession
    private typealias ApiEndpoint = Constants.ApiEndpoint

    init(currencyExchangeRepository: CurrencyExchangeRepositoryType) {
        self.currencyExchangeRepository = currencyExchangeRepository
        self.httpSession = URLSession(configuration: currencyExchangeRepository.defaultHttpSessionConfiguration)
    }

    func convertCurrency(from fromCode: CurrencyCode, to toCode: CurrencyCode, amount: Int, completion: @escaping (Result<Double, CurrencyExchangeServiceError>) -> Void) {
        let convertCurrencyURLString = ApiEndpoint.baseURLString + "/convert"
        guard let convertCurrencyURL = URL(string: convertCurrencyURLString) else {
            completion(.failure(.missingOrInvalidApiURL))
            return
        }

        let parameters: [String: Any] = [
            ParametersKey.from.rawValue: fromCode.code,
            ParametersKey.to.rawValue: toCode.code,
            ParametersKey.amount.rawValue: amount
        ]

        var headers: [HeaderAttribute] = []
        do {
            headers = try buildRequestHeader()
        } catch {
            completion(.failure(CurrencyExchangeServiceError.requestError(RequestError.missingMetadata)))
        }

        requestFromServer(
            url: convertCurrencyURL,
            httpMethod: .get,
            parameters: parameters,
            addtionalHeaders: headers) { result in
                switch result {
                case .success((let data, _)):
                    switch parseResponse(data) {
                    case .success(let result):
                        completion(.success(result))
                    case .failure(let error):
                        completion(.failure(CurrencyExchangeServiceError.jsonDecodingError(error)))
                    }
                case .failure(let requestError):
                    switch requestError {
                    case .httpError(let statusCode, _, _) where statusCode >= 500:
                        completion(.failure(.internalServerError(statusCode)))
                    default:
                        completion(.failure(.requestError(requestError)))
                    }
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

    func buildHttpBody(with parameters: [String : Any]?) -> Result<Data, Error> {
        .failure(RequestError.bodyIsNil)
    }

    private func buildRequestHeader() throws -> [HeaderAttribute] {
        var headerBuilder = HeaderAttributesBuilder()
        try headerBuilder.addApiKey(currencyExchangeRepository: currencyExchangeRepository)
        return headerBuilder.addedHeaders
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
            RLogger.debug(message: "Failed creating a request - \(error)")
            return .failure(error)
        }
    }
    
    private func getCurrencyDataConvertRequest(parameters: [String: Any]?) throws -> CurrencyDataConvertRequest {
        guard let parameters,
              let from = parameters[ParametersKey.from.rawValue] as? String,
              let to = parameters[ParametersKey.to.rawValue] as? String,
              let amount = parameters[ParametersKey.amount.rawValue] as? Int else {
            throw RequestError.missingMetadata
        }
        
        return CurrencyDataConvertRequest(
            from: from,
            to: to,
            amount: amount)
    }

}
