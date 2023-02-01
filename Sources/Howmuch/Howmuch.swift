import Foundation
import RLogger
import RSDKUtilsMain

public final class Howmuch {

    internal private(set) static var initializedModule: HowmuchModule?
    private(set) static var dependencyManager: TypedDependencyManager?

    private init() { }

    /// Funtions to be called by host application to start a new thread
    /// that configure Howmuch SDK.
    /// - Parameter apiKey: your APILayer api key
    public static func configure(apiKey: String) {
        guard initializedModule == nil else {
            return
        }
        let config = HowmuchModuleConfiguration(apiKey: apiKey)
        let dependencyManager = TypedDependencyManager()
        let mainContainer = MainContainerFactory.create(dependencyManager: dependencyManager)
        dependencyManager.appendContainer(mainContainer)
        configure(dependencyManager: dependencyManager, moduleConfig: config)
    }

    private static func notifyIfModuleNotInitialized() -> Bool {
        guard initializedModule == nil else {
            return true
        }
        let description = "⚠️ API method called before calling `configure()`"
        RLogger.debug(message: description)
        return false
    }

    internal static func configure(dependencyManager: TypedDependencyManager, moduleConfig: HowmuchModuleConfiguration) {
        self.dependencyManager = dependencyManager
        guard initializedModule == nil else {
            return
        }

        guard let currencyExchangeRepository = dependencyManager.resolve(type: CurrencyExchangeRepositoryType.self),
              let currencyExchangeService = dependencyManager.resolve(type: CurrencyExchangeServiceType.self) else {
            assertionFailure("Howmuch Messaging SDK module initialization failure: Dependencies could not be resolved")
            return
        }
        currencyExchangeRepository.save(moduleConfig)

        initializedModule = HowmuchModule(
            currencyExchangeRepository: currencyExchangeRepository,
            currencyExchangeService: currencyExchangeService)
    }
    
    /// Convert any amount from one currency to another.
    /// - Parameters:
    ///   - from: The currency code of the currency you would like to convert from.
    ///   - to: The currency code of the currency you would like to convert to.
    ///   - amount: The amount to be converted.
    /// - Returns: Returning the conversion result, will be returning nil if the process failed
    public static func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Result<Double, Error>) -> (Void)) {
        guard notifyIfModuleNotInitialized() else {
            completion(.failure(NSError.howmuchError(description: "⚠️ API method called before calling `configure()`")))
            return
        }
        initializedModule?.convertCurrency(from: from, to: to, amount: amount) { result in
            switch result {
            case .success(let convertedCurrency):
                completion(.success(convertedCurrency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
