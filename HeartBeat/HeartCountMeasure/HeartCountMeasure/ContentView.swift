//
//  ContentView.swift
//  HeartCountMeasure
//
//  Created by Vivek Patel on 20/09/23.
//

import SwiftUI


import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func makeUIView(context: Context) -> UIView {
            let previewView = UIView()
            if let previewLayer = previewLayer {
                previewLayer.frame = previewView.bounds
                previewView.layer.addSublayer(previewLayer)
            }
            return previewView
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            // Update the view if needed
        }
}


struct ContentView: View {
    
    @ObservedObject var viewModel = CameraViewModel()
    @State private var showAlert = false
    
    init() {
            _showAlert = State(initialValue: true) // Set showAlert to true initially to show the alert in init()
        }
    
    var body: some View {
        VStack {
                    if let previewLayer = viewModel.previewLayer {
                        // Show camera preview if available
                        CameraPreviewView(previewLayer: previewLayer)
                            .frame(width: 300, height: 300) // Adjust size as needed
                    } else {
                        // Show a message or button to request camera permission
                        Text("Camera access not granted. Please allow camera access in settings.")
                    }
                }
                .onAppear {
                    // Check camera authorization when the view appears
                    viewModel.checkCameraAuthorization()
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
