//
//  FrameHandler.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 20/09/23.
//

import AVFoundation
import CoreImage

class FrameHandler: NSObject,ObservableObject {
    
    @Published var frame: CGImage?
    private var permisionGranted = false
    private let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "sessionQueue") // This allow you run "captureSession" in the background thread
    private let context = CIContext()
    @Published var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(
      label: "sessionQueue",
      qos: .userInitiated,
      attributes: [],
      autoreleaseFrequency: .workItem)
    
    
   override init() {
       super.init()
       
        checkPermission() // called it so we get the authorize permission
        
        sessionQueue.async {
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
       set(self, queue: videoOutputQueue)
    }
    
    func checkPermission() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("get authorized")
            permisionGranted = true
           
        case .notDetermined:
            requestPermission()
         
        case .denied:
            print("get denied")
            permisionGranted = false
          
        case .restricted:
            print("get restricted")
            permisionGranted = false
            
        @unknown default:
            permisionGranted = false
           
            
        }
    }
    
    
    func requestPermission(){
        
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permisionGranted = granted
            
        }
    }
    
    func setupCaptureSession() {
        
       
        
        guard permisionGranted else {return}
        
        captureSession.beginConfiguration()
        defer {
            captureSession.commitConfiguration()
        }
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
        
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        
        guard captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        
        
        if captureSession.canAddOutput(videoOutput){
            captureSession.addOutput(videoOutput)
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            print("cannot add output")
            return
        }
        
//        videoOutput.connection(with: .video)?.videoOrientation = .portrait
 
    }
    func set(
      _ delegate: AVCaptureVideoDataOutputSampleBufferDelegate,
      queue: DispatchQueue
    ) {
      sessionQueue.async {
        self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
      }
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {


    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let cgimage = imageFromsampleBuffer(sampleBuffer: sampleBuffer) else { return }

//        DispatchQueue.main.async { [unowned self] in
//            self.frame = cgimage
//
//        }
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }

//    private func imageFromsampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
//        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return nil}
//        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
//        guard let cgimage = context.createCGImage(ciImage, from: ciImage.extent) else {return nil}
//
//        return cgimage
//    }
}
