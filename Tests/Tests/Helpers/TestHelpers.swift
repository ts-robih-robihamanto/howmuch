import Foundation

struct TestHelpers {

    static func getJSONData(fileName: String) -> Data! {
        guard let jsonURL =  Bundle.module.url(forResource: fileName, withExtension: "json") else {

            assertionFailure()
            return nil
        }

        do {
            return try Data(contentsOf: jsonURL)
        } catch {
            assertionFailure()
            return nil
        }
    }

}
