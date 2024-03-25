import VisionKit
import SwiftUI

@available(iOS 13, *)
public struct DocumentCamera: UIViewControllerRepresentable {
    var delegate: VNDocumentCameraViewControllerDelegate

    public init(
        delegate: VNDocumentCameraViewControllerDelegate,
        cancelAction: @escaping CancelAction = {},
        resultAction: @escaping ResultAction) {
            self.cancelAction = cancelAction
            self.resultAction = resultAction
            self.delegate = delegate
        }

    public typealias CameraResult = Result<VNDocumentCameraScan, Error>
    public typealias CancelAction = () -> Void
    public typealias ResultAction = (CameraResult) -> Void

    private let cancelAction: CancelAction
    private let resultAction: ResultAction

    public func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let controller = VNDocumentCameraViewController()
        controller.delegate = delegate
        return controller
    }

    public func updateUIViewController(
        _ uiViewController: VNDocumentCameraViewController,
        context: Context) {}
}
