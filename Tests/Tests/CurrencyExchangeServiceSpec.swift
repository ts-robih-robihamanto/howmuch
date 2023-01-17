import Foundation
import Quick
import Nimble
import RSDKUtilsTestHelpers
@testable import Howmuch

class CurrencyExchangeServiceSpec: QuickSpec {

    override func spec() {
        let requestQueue = DispatchQueue(label: "howmuch.test.request")
        let moduleConfig = HowmuchModuleConfiguration(apiKey: "api_key")

        var service: CurrencyExchangeService!
        var httpSession: URLSessionMock!
        var repository: CurrencyExchangeRepository!

        describe("CurrencyExchangeService") {

            beforeEach {
                URLSessionMock.startMockingURLSession()

                repository = CurrencyExchangeRepository()
                repository.saveHowmuchModuleConfiguration(moduleConfig)
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
                        waitUntil { done in
                            requestQueue.async {
                                let response = service.convertCurrency(
                                    from: CurrencyCode.jpy,
                                    to: CurrencyCode.usd,
                                    amount: 1000)
                                expect {
                                    currencyExchangeResult = try response.get()
                                }.notTo(throwError())
                                done()
                            }
                        }
                    }


                }
            }
        }

    }

}

private class CurrenctExchangeURLResponse: HTTPURLResponse {
    init?(statusCode: Int) {
        super.init(url: URL(string: "http://apiLayer.com/currency_data/convert")!,
                   statusCode: statusCode,
                   httpVersion: nil,
                   headerFields: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
