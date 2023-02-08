import Foundation
import Quick
import Nimble
import RLogger
import RSDKUtilsTestHelpers

@testable import Howmuch

class HttpRequestableSpec: QuickSpec {

    override func spec() {

        describe("HttpRequestableObject") {

            var httpRequestable: HttpRequestableObject!
            let url = URL(string: "https://apiLayer.com/currency_data")!

            beforeEach {
                httpRequestable = HttpRequestableObject()
            }

            afterEach {
                httpRequestable = nil
            }

            context("whan calling requestFromServer") {

                it("will send a request with provided URL") {
                    httpRequestable.requestFromServer(url: url, httpMethod: .get, parameters: nil, addtionalHeaders: nil, completion: {_ in})
                    let request = httpRequestable.httpSessionMock.sentRequest
                    expect(request).notTo(beNil())
                    expect(request?.url).to(equal(url))
                }

                it("will send a request with provided method") {
                    httpRequestable.requestFromServer(url: url, httpMethod: .put, parameters: nil, addtionalHeaders: nil, completion: {_ in})
                    let request = httpRequestable.httpSessionMock.sentRequest
                    expect(request).notTo(beNil())
                    expect(request?.httpMethod).to(equal(HttpMethod.put.rawValue))
                }

                it("will send a request with provided data") {
                    let data = "data".data(using: .ascii)!
                    httpRequestable.bodyData = data
                    httpRequestable.requestFromServer(url: url, httpMethod: .put, parameters: nil, addtionalHeaders: nil, completion: {_ in})
                    let request = httpRequestable.httpSessionMock.sentRequest
                    expect(request).notTo(beNil())
                    expect(request?.httpBody).to(equal(data))
                }

                it("will always send requests with application/json Content-Type header") {
                    httpRequestable.requestFromServer(url: url, httpMethod: .put, parameters: nil, addtionalHeaders: nil, completion: {_ in})
                    let request = httpRequestable.httpSessionMock.sentRequest
                    expect(request).toNot(beNil())
                    expect(request?.allHTTPHeaderFields).to(equal(["Content-Type": "application/json"]))
                }
            }

        }

    }

}

enum HttpRequestableObjectError: Error{
    case bodyError
    case sessionError
}

class HttpRequestableObject: HttpRequestable {
    private(set) var httpSession: URLSession = URLSessionMock.mock(originalInstance: .shared)
    var httpSessionMock: URLSessionMock {
        httpSession as! URLSessionMock
    }
    var bodyError: HttpRequestableObjectError?
    var bodyData = Data()
    
    func buildHttpBody(with parameters: [String : Any]?) -> Result<Data, Error> {
        guard let bodyError else {
            return .success(bodyData)
        }
        return .failure(bodyError)
    }

    func buildURLRequest(url: URL, with parameters: [String : Any]?) -> Result<URLRequest, Error> {
        .success(URLRequest(url: url))
    }

    func requestFromServer(url: URL, httpMethod: HttpMethod, parameters: [String : Any]?, addtionalHeaders: [HeaderAttribute]?, completion: @escaping (RequestResult) -> Void) {
        var request: URLRequest
        let result = buildURLRequest(url: url)
        switch result {
        case .success(let urlRequest):
            request = urlRequest
        case .failure(let error):
            completion(.failure(.urlBuildingError(error)))
            return
        }

        if httpMethod != .get {
            let bodyResult = buildHttpBody(with: parameters)
            switch bodyResult {
            case .success(let body):
                request.httpBody = body
            case .failure(let error):
                completion(.failure(.bodyEncodingError(error)))
                return
            }
        }

        request.httpMethod = httpMethod.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let addtionalHeaders {
            request.allHTTPHeaderFields = addtionalHeaders.reduce(into: [String: String]()) { $0[$1.key] = $1.value }
        }

        httpSession.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(.taskFailed(error)))
                RLogger.debug(message: error.localizedDescription)
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

            guard 100..<300 ~= statusCode, let data, let response = response as? HTTPURLResponse else {
                completion(.failure(.httpError(UInt(statusCode), response, data)))
                let errorMessage = data != nil ? String(data: data!, encoding: .utf8) : ""
                RLogger.debug(message: "HTTP call failed (\(statusCode))\n\(errorMessage ?? "")")
                return
            }
            completion(.success((data, response)))
        }
    }

}
