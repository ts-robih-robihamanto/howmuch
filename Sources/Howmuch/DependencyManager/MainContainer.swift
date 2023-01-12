import Foundation
import RSDKUtilsMain

internal enum MainContainerFactory {
    
    private typealias ContainerElement = TypedDependencyManager.ContainerElement

    static func create(dependencyManager manager: TypedDependencyManager) -> TypedDependencyManager.Container {
        let elements = [
            ContainerElement(type: CurrencyExchangeRepository.self, factory: {
                CurrencyExchangeRepository()
            })
        ]
        return TypedDependencyManager.Container(elements)
    }

}
