//
//  CameraAccessViewController.swift
//  HeartBeatMeasure
//
//  Created by Vivek Patel on 21/09/23.
//

import UIKit
import SwiftUI
import AVFoundation

class CameraAccessViewController: UIViewController {
    
    private var permisionGranted  = false // for permission
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    
    var screenRect: CGRect! = nil // for view dimension
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permisionGranted else {return}
            self.setupCaptureSession()
            self.captureSession.startRunning()
            
        }
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
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permisionGranted = granted
            self.sessionQueue.resume()
            
        }
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {return}
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        
        guard captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        // TODO: Add previewLayer
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        
        previewLayer.connection?.videoOrientation = .portrait
        
        // Update the UI must be on the main queue
        DispatchQueue.main.async { [weak self] in
            self?.view.layer.addSublayer(self!.previewLayer)
        }
        
        
    }
}

struct HostedViewController: UIViewControllerRepresentable {
   
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return CameraAccessViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
