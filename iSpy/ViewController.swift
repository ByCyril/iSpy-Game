//
//  ViewController.swift
//  iSpy
//
//  Created by Cyril Garcia on 2/26/21.
//

import UIKit
import AVKit

class ViewController: UIViewController, CameraLayerDelegate, VisionLayerDelegate, GameLayerDelegate {
    
    var countdownLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var resultsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var iSpyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var visionLayer = VisionLayer()
    var gameLayer = GameLayer()
    var cameraLayer: CameraLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visionLayer.delegate = self
        gameLayer.delegate = self
        
        cameraLayer = CameraLayer(frame: view.bounds)
        cameraLayer?.delegate = self
        view.addSubview(cameraLayer!)
        
        initUI()
    }
    
    func initUI() {
        
        let doubleTapGesture = UITapGestureRecognizer(target: gameLayer, action: #selector(gameLayer.startSearching))
        doubleTapGesture.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(doubleTapGesture)
        
        view.addSubview(countdownLabel)
        view.addSubview(resultsLabel)
        view.addSubview(iSpyLabel)
        
        NSLayoutConstraint.activate([
            countdownLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            resultsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            resultsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            resultsLabel.bottomAnchor.constraint(equalTo: iSpyLabel.topAnchor, constant: -15),
            
            iSpyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            iSpyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            iSpyLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            
        ])
        
        view.layoutIfNeeded()
    }

    func cameraLayerOutput(_ output: CMSampleBuffer) {
        if gameLayer.searching {
            visionLayer.predict(from: output)
        }
    }
    
    func visionLayerOutuput(_ output: String, _ confidenceLevel: Double) {
        gameLayer.checkItem(output)
        resultsLabel.text = "\(output)\n\(confidenceLevel)"
    }
    
    func gameLayer(itemToFind: String) {
        iSpyLabel.text = "Find a " + itemToFind
    }
    
    func gameLayer(countdown: String) {
        countdownLabel.text = countdown
    }
}
