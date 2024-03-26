import Foundation
import SwiftUI
import VisionKit
import Vision

class Observation: Identifiable {
    var box: VNRectangleObservation
    var text: String

    init(box: VNRectangleObservation, text: String) {
        self.box = box
        self.text = text
    }
}

class ScannerViewModel: NSObject, ObservableObject {
    @Published var imageArray: [UIImage] = []
    @Published var errorMessage: String?
    @Published var image: UIImage?
    @Published var observations: [Observation] = []

    override init() { }

    func calculatePosition(for point: CGPoint, and reader: GeometryProxy) -> CGPoint {
        print(reader.size.width)
        print(reader.size.height)
        let x = (point.x * reader.size.width)
        let y = reader.size.height - (point.y * reader.size.height)
        return CGPoint(x: x, y: y)
    }
}

extension ScannerViewModel: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        errorMessage = error.localizedDescription
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        self.observations.removeAll()
        self.imageArray.removeAll()
        for i in 0..<scan.pageCount {
            self.imageArray.append(scan.imageOfPage(at:i))
        }

        let textRecognitionFunction = performTextRecognition { observations -> [String] in
            for observation in observations {
                print(observation)
                guard let text = observation.topCandidates(1).first else { return [] }
                if let box = try? text.boundingBox(for: text.string.range(of: text.string)!) {
                    self.observations.append(Observation(box: box, text: text.string))
                    //self.observations.append(box)
                }
            }
            return []
        }

        guard let image = imageArray.first else {
            return
        }
        let recognizedText = textRecognitionFunction(image)
        self.image = image

        controller.dismiss(animated: true, completion: nil)
    }
}
