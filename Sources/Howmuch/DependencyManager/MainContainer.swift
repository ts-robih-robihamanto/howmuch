import Foundation
import RSDKUtilsMain

internal enum MainContainerFactory {
    
    private typealias ContainerElement = TypedDependencyManager.ContainerElement

    static func create(dependencyManager manager: TypedDependencyManager) -> TypedDependencyManager.Container {
        let elements = [
            ContainerElement(type: ExchangeMoneyRepository.self, factory: {
                ExchangeMoneyRepository()
            })
        ]
        return TypedDependencyManager.Container(elements)
    }

}
