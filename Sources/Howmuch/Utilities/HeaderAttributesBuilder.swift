enum HeaderAttributesBuilderError: Error {
    case emptyApiKey
}

struct HeaderAttributesBuilder {
    private typealias Keys = Constants.Request.Header
    private(set) var addedHeaders: [HeaderAttribute] = []

    mutating func add(apiKey: String) {
        addedHeaders.append(HeaderAttribute(key: Keys.apikey, value: apiKey))
    }
}
