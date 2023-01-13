import Foundation
import RSDKUtilsMain

internal enum MainContainerFactory {
    
    private typealias ContainerElement = TypedDependencyManager.ContainerElement

    static func create(dependencyManager manager: TypedDependencyManager) -> TypedDependencyManager.Container {
        let elements = [
            ContainerElement(type: CurrencyExchangeRepositoryType.self, factory: {
                CurrencyExchangeRepository()
            }),
            ContainerElement(type: CurrencyExchangeServiceType.self, factory: {
                CurrencyExchangeService(currencyExchangeRepository: manager.resolve(type: CurrencyExchangeRepositoryType.self)!)
            }),
            ContainerElement(type: ConfigurationManagerType.self, factory: {
                ConfigurationManager(currencyExchangeService: manager.resolve(type: CurrencyExchangeServiceType.self)!,
                                     currencyExchangeRepository: manager.resolve(type: CurrencyExchangeRepositoryType.self)!)
            })
        ]
        return TypedDependencyManager.Container(elements)
    }

}
