//
//  ContentView.swift
//  visionSDK
//
//  Created by Fernando Salom Carratala on 24/3/24.
//

import SwiftUI
import VisionKit

struct PreviewerView: View {
    @ObservedObject var viewModel = PreviewerViewModel()
    @State var showingSheet = false
    @State var selectedText = "elige un label"

    var body: some View {
        VStack {
            if viewModel.image != nil {
                Text(selectedText)
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .scaledToFit()
                    .overlay(
                        GeometryReader { reader in
                            ForEach(viewModel.observations) { observation in
                                Path { path in
                                    path.move(to: viewModel.calculatePosition(
                                        for: observation.box.topLeft,
                                        and: reader))
                                    path.addLine(to: viewModel.calculatePosition(
                                        for: observation.box.topRight,
                                        and: reader))
                                    path.addLine(to: viewModel.calculatePosition(
                                        for: observation.box.bottomRight,
                                        and: reader))
                                    path.addLine(to: viewModel.calculatePosition(
                                        for: observation.box.bottomLeft,
                                        and: reader))
                                }
                                .fill(.blue)
                                .opacity(0.3)
                                .onTapGesture {
                                    selectedText = observation.text
                                }
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
    ScannerView(viewModel: PreviewerViewModel())
}
