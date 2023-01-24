import Quick
import Nimble
@testable import Howmuch

class CurrencyExchangeRepositorySpec: QuickSpec {

    override func spec() {

        describe("CurrencyExchangeRepository") {

            var currencyExchangeRepository: CurrencyExchangeRepository!

            beforeEach {
                currencyExchangeRepository = CurrencyExchangeRepository()
            }

            it("will not return default URLSessionConfiguration") {
                expect(currencyExchangeRepository.defaultHttpSessionConfiguration).toNot(equal(.default))
            }

            context("when calling saveHowmuchModuleConfiguration()") {

                it("will properly save api key()") {
                    let config = HowmuchModuleConfiguration(apiKey: "api_key")
                    currencyExchangeRepository.save(config)

                    expect(currencyExchangeRepository.getApiKey()).to(equal("api_key"))
                }

            }

        }

    }

}
