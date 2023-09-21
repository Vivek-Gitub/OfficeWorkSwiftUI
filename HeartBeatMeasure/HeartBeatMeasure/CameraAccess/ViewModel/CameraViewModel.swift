//
//  CameraViewModel.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 20/09/23.
//

import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var isCameraAuthorized = false
    
    private var captureSession = AVCaptureSession()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    
    
    override init() {
        super.init()
        checkCameraAuthorization()

        DispatchQueue.global(qos: .background).async {
            self.setupCaptureSession()
        }
 
    }
    
    deinit {
        // Stop the capture session and perform cleanup when the view model is deallocated
        captureSession.stopRunning()
    }
    
     func setupCaptureSession() {
         
         let videoOutput = AVCaptureVideoDataOutput()
                 
         guard isCameraAuthorized else {
             // Handle the case where camera access is not granted
             return
             
         }
        
        do {
            // Add video input
            if let videoCaptureDevice = AVCaptureDevice.default(for: .video) {
                print("In camera")
                let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                print("Before adding video input")
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                    print("Video input added successfully")
                } else {
                    print("Could not add video input to capture session.")
                    return
                }
                
                videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
               
                if captureSession.canAddOutput(videoOutput) {
                    captureSession.addOutput(videoOutput)
                } else {
                    // Handle the case where video output cannot be added
                    return
                }
                
                
                // Create a video preview layer
                let preViewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                preViewLayer.videoGravity = .resizeAspectFill
                self.previewLayer =  preViewLayer
                print("Preview layer assigned")
                captureSession.startRunning()
                
            } else {
                print("No video capture device available.")
            }
            
        } catch {
            print("Error setting up capture session: \(error.localizedDescription)")

        }
    }
    
    
    
    
     func checkCameraAuthorization() {
         
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("get authorized")
            isCameraAuthorized = true
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                DispatchQueue.main.async {
                    self.isCameraAuthorized = granted
                }
                
                
            }
            
            break
        case .denied:
            print("get denied")
            isCameraAuthorized = false

            break
        case .restricted:
            print("get restricted")
            isCameraAuthorized = false

            break
            
        @unknown default:
            isCameraAuthorized = false
            break
        }
    }
}
