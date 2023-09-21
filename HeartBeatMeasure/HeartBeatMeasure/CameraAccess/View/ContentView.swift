//
//  ContentView.swift
//  HeartBeatMeasure
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
 
    @State private var remainingTime = 15
    @State private var timer: Timer? = nil
    
    @State private var okButtonAction = false
    
    
    
     var formattedTime: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init() {
            _showAlert = State(initialValue: true) // Set showAlert to true initially to show the alert in init()
        }
    
    var body: some View {
        VStack {
            
            Text(formattedTime)
                .font(.largeTitle)
                .frame(maxWidth: .infinity,alignment: .trailing)
                .padding(.all, 15)
//                .border(Color.blue)
                
            
            // Circular view to display camera feed
            if let previewLayer = viewModel.previewLayer {
                CameraPreviewView(previewLayer: previewLayer)
                    .frame(width: 300,height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.green,lineWidth: 3))
                    .padding(.top,75)
            }



        }
        .frame(maxWidth: .infinity,maxHeight:  .infinity,alignment: .top)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert!"),
                  message: Text("This is not a medical device and only indicative in nature"),
                  dismissButton: .default(Text("OK"), action: {
                okButtonAction = true
                startTimer()
                
            })
            )
        }
        
        
        
        
        }
    
    func startTimer() {
        
        if okButtonAction {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timer?.invalidate()
                }
            }
        }
        
         
     }
    
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
