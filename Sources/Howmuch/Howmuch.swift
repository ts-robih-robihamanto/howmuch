import Foundation
import RSDKUtilsMain

public final class Howmuch: NSObject {

    internal private(set) static var initializedModule: HowmuchModule?
    private(set) static var dependencyManager: TypedDependencyManager?
    internal static let inAppQueue = DispatchQueue(label: "Howmuch.Main", qos: .utility, attributes: [])

    private override init() { super.init() }

    /// Funtions to be called by host application to start a new thread
    /// thad configure Howmuch SDK.
    /// - Parameter apiKey: your APILayer api key
    public static func configure(apiKey: String? = nil) {
        guard initializedModule == nil else {
            return
        }
        let config = HowmuchModuleConfiguration(apiKey: apiKey)
        let dependencyManager = TypedDependencyManager()
        let mainContainer = MainContainerFactory.create(dependencyManager: dependencyManager)
        dependencyManager.appendContainer(mainContainer)
        configure(dependencyManager: dependencyManager, moduleConfig: config)
    }

    internal static func configure(dependencyManager: TypedDependencyManager, moduleConfig: HowmuchModuleConfiguration) {
        self.dependencyManager = dependencyManager

        inAppQueue.async {
            guard initializedModule == nil else {
                return
            }

            guard let configurationManager = dependencyManager.resolve(type: ConfigurationManagerType.self),
                  let currencyExchangeRepository = dependencyManager.resolve(type: CurrencyExchangeRepositoryType.self),
                  let currencyExchangeService = dependencyManager.resolve(type: CurrencyExchangeServiceType.self) else {
                assertionFailure("Howmuch Messaging SDK module initialization failure: Dependencies could not be resolved")
                return
            }
            configurationManager.save(moduleConfig)

            initializedModule = HowmuchModule(
                configurationManager: configurationManager,
                currencyExchangeRepository: currencyExchangeRepository,
                currencyExchangeService: currencyExchangeService)
        }
    }
    
    /// Convert any amount from one currency to another.
    /// - Parameters:
    ///   - from: The currency code of the currency you would like to convert from.
    ///   - to: The currency code of the currency you would like to convert to.
    ///   - amount: The amount to be converted.
    /// - Returns: Returning the conversion result, will be returning nil if the process failed
    public static func convertCurrency(from: CurrencyCode, to: CurrencyCode, amount: Int, completion: @escaping (Double?) -> (Void)) {
        inAppQueue.async {
            initializedModule?.convertCurrency(from: from, to: to, amount: amount) { result in
                switch result {
                case .success(let convertedCurrency):
                    completion(convertedCurrency)
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }

}
