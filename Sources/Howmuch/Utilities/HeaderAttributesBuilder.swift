enum HeaderAttributesBuilderError: Error {
    case emptyApiKey
}

struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private(set) var addedHeaders: [HeaderAttribute] = []

    mutating func addApiKey(currencyExchangeRepository: CurrencyExchangeRepositoryType) throws {
        guard let apiKey = currencyExchangeRepository.apiKey() else {
            throw HeaderAttributesBuilderError.emptyApiKey
        }
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
    }
}
