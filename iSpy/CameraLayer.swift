//
//  CameraLayer.swift
//  iSpy
//
//  Created by Cyril Garcia on 2/26/21.
//

import UIKit
import AVKit

protocol CameraLayerDelegate: AnyObject {
    func cameraLayerOutput(_ output: CMSampleBuffer)
}

final class CameraLayer: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    weak var delegate: CameraLayerDelegate?
    
    private var captureSession = AVCaptureSession()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCaptureSession()
        setupPreviewLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCaptureSession() {
        captureSession.startRunning()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        guard let dataInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        
        captureSession.addInput(dataInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_queue"))
        
        captureSession.addOutput(dataOutput)
        
    }
    
    private func setupPreviewLayer() {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = frame
        
        layer.addSublayer(previewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.cameraLayerOutput(sampleBuffer)
    }
}

