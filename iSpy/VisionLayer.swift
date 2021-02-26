//
//  VisionLayer.swift
//  iSpy
//
//  Created by Cyril Garcia on 2/26/21.
//

import UIKit
import Vision

protocol VisionLayerDelegate: AnyObject {
    func visionLayerOutuput(_ output: String,_ confidenceLevel: Double)
}

final class VisionLayer {
    weak var delegate: VisionLayerDelegate?
    
    private var model: VNCoreMLModel
    
    init() {
        let modelConfig = MLModelConfiguration()
        modelConfig.allowLowPrecisionAccumulationOnGPU = true
        model = try! VNCoreMLModel(for: iSpyModel(configuration: modelConfig).model)
    }
    
    func predict(from sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let imageRequesthandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        let coreMLRequest = VNCoreMLRequest(model: model) { (finishRequest, error) in
            guard let result = (finishRequest.results as? [VNClassificationObservation])?.first else { return }

            let confidenceLevel = Double(result.confidence)
            let identifier = result.identifier.capitalized
            
            DispatchQueue.main.async { [weak self] in
                if confidenceLevel >= 0.6 {
                    self?.delegate?.visionLayerOutuput(identifier, confidenceLevel)
                } else {
                    self?.delegate?.visionLayerOutuput("NA", 0.0)
                }
            }
        }
        
        try? imageRequesthandler.perform([coreMLRequest])
    }
    
}
