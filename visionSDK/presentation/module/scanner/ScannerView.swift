//
//  ContentView.swift
//  visionSDK
//
//  Created by Fernando Salom Carratala on 24/3/24.
//

import SwiftUI
import VisionKit

struct ScannerView: View {
    @ObservedObject var viewModel: ScannerViewModel = ScannerViewModel()
    @State var showingSheet = false

    var body: some View {
        VStack {
            if viewModel.image != nil {
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GeometryReader { geometry in
                            ForEach(viewModel.observations, id: \.self) { observation in
                                //if let observation {
                                Path { path in
                                    path.move(to: observation.boundingBox * geometry.size.width)
                                    path.addLine(to: CGPoint(x: 100, y: 300))
                                    path.addLine(to: CGPoint(x: 300, y: 300))
                                    path.addLine(to: CGPoint(x: 200, y: 100))
                                }
                                .fill(.blue)
                                    Rectangle()
                                        .path(in: CGRect(
                                            x: observation.boundingBox.minX * geometry.size.width,
                                            y: observation.boundingBox.minY * geometry.size.height,
                                            width: observation.boundingBox.width * geometry.size.width,
                                            height: observation.boundingBox.height * geometry.size.height))
                                        .stroke(Color.red, lineWidth: 2.0)
                                //}
                            }
                        }
                    )

            }
            Button("Escanear") {
                showingSheet = true
            }.sheet(isPresented: $showingSheet) {
                DocumentCamera(delegate: viewModel) {

                } resultAction: { result in

                }
            }
        }
        .padding()
    }
}

#Preview {
    ScannerView(viewModel: ScannerViewModel())
}
