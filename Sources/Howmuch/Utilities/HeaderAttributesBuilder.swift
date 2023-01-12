struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private var addedHeaders: [HeaderAttribute] = []

    @discardableResult
    mutating func addApiKey(currencyExchangeRepository: CurrencyExchangeRepositoryType) -> Bool {
        guard let apiKey = currencyExchangeRepository.getApiKey() else {
            return false
        }
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
        return true
    }

    func build() -> [HeaderAttribute] {
        addedHeaders
    }
}
