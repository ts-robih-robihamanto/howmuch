struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private var addedHeaders: [HeaderAttribute] = []

    @discardableResult
    mutating func addApiKey(exchangeMoneyRepository: ExchangeMoneyRepositoryType) -> Bool {
        guard let apiKey = exchangeMoneyRepository.getApiKey() else {
            return false
        }
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
        return true
    }

    func build() -> [HeaderAttribute] {
        addedHeaders
    }
}
