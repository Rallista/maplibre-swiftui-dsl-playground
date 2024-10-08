import SnapshotTesting
import XCTest
@testable import MapLibreSwiftUI

final class CameraPreviewTests: XCTestCase {
    func testCameraPreview() {
        assertView {
            CameraDirectManipulationPreview(
                styleURL: URL(string: "https://demotiles.maplibre.org/style.json")!
            )
        }
    }
}
