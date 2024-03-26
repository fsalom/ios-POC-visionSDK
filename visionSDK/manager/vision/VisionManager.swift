import Foundation
import UIKit
import Vision

public func performTextRecognition<ResultType>(_ completion: @escaping ([VNRecognizedTextObservation]) -> [ResultType]) -> (UIImage) -> [ResultType] {
    // The closure that will be returned and used to process the image and perform text recognition.
    return { image in
        // Ensure that the image can be converted to a CGImage.
        guard let cgImage = image.cgImage else { return [] }

        // An array to store the results of text recognition.
        var scannedTextInfos: [ResultType] = []

        // Create a Vision request handler with the CGImage.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        // Create a text recognition request.
        let request = VNRecognizeTextRequest { request, error in
            // Handle the result or error from text recognition.
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                print("Error: Text recognition failed.")
                return
            }
            // Call the completion closure with the recognized text observations and store the result in scannedTextInfos.
            scannedTextInfos = completion(observations)
        }

        // Set some properties of the text recognition request.
        request.recognitionLanguages = ["en"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        // Perform the text recognition using the request handler.
        try? requestHandler.perform([request])

        // Return the scannedTextInfos containing the results of text recognition.
        return scannedTextInfos
    }
}
