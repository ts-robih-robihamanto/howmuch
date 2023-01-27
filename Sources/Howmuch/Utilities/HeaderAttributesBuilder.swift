struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private(set) var addedHeaders: [HeaderAttribute] = []

    @discardableResult
    mutating func addApiKey(currencyExchangeRepository: CurrencyExchangeRepositoryType) -> Bool {
        guard let apiKey = currencyExchangeRepository.apiKey() else {
            return false
        }
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
        return true
    }
}
