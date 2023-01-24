import Foundation
import Quick
import Nimble
import RSDKUtilsTestHelpers
@testable import Howmuch

class CurrencyExchangeServiceSpec: QuickSpec {

    override func spec() {
        let moduleConfig = HowmuchModuleConfiguration(apiKey: "api_key")

        var service: CurrencyExchangeService!
        var httpSession: URLSessionMock!
        var repository: CurrencyExchangeRepository!

        describe("CurrencyExchangeService") {

            beforeEach {
                URLSessionMock.startMockingURLSession()

                repository = CurrencyExchangeRepository()
                repository.save(moduleConfig)
                service = CurrencyExchangeService(currencyExchangeRepository: repository)
                httpSession = URLSessionMock.mock(originalInstance: service.httpSession)
            }

            afterEach {
                URLSessionMock.stopMockingURLSession()
            }

            context("when request succeeds") {

                beforeEach {
                    httpSession.httpResponse = CurrenctExchangeURLResponse(statusCode: 200)
                }

                context("and payload is valid") {

                    var currencyExchangeResult: Double?

                    beforeEach {
                        currencyExchangeResult = nil
                    }

                    func fetchCurrencyExchange() {
                        service.convertCurrency(from: CurrencyCode.jpy, to: CurrencyCode.usd, amount: 1000) { result in
                            switch result {
                            case .success(let data):
                                currencyExchangeResult = data
                            case .failure(_):
                                ()
                            }
                        }
                    }

                    it("will return a valid response with correct result value") {
                        httpSession.responseData = TestHelpers.getJSONData(fileName: "currency_exchange_convert_success")
                        fetchCurrencyExchange()

                        expect(currencyExchangeResult).to(equal(11647700.9))
                    }

                }
            }
        }

    }

}

private class CurrenctExchangeURLResponse: HTTPURLResponse {
    init?(statusCode: Int) {
        super.init(url: URL(string: "https://api.apilayer.com/currency_data/convert")!,
                   statusCode: statusCode,
                   httpVersion: nil,
                   headerFields: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
