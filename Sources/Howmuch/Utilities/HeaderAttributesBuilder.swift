enum HeaderAttributesBuilderError: Error {
    case emptyApiKey
}

struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private(set) var addedHeaders: [HeaderAttribute] = []

    mutating func addApiKey(currencyExchangeRepository: CurrencyExchangeRepositoryType) throws {
        let apiKey = try currencyExchangeRepository.apiKey()
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
    }
}
