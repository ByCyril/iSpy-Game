//
//  GameLayer.swift
//  iSpy
//
//  Created by Cyril Garcia on 2/26/21.
//

import Foundation

enum Item: String {
    case phone
    case pen
    case keyboard
    case glass
    case screen
    case mouse
    case rubix_cube = "Rubix Cube"
    case bottle
    case wallet
    case airpods
    case homepod
    case mug
}

protocol GameLayerDelegate: AnyObject {
    func gameLayer(countdown: String)
    func gameLayer(itemToFind: String)
}

final class GameLayer {
    
    weak var delegate: GameLayerDelegate?
    
    var items: Set<Item> = [.airpods, .bottle, .glass, .homepod, .keyboard, .mouse, .mug, .pen, .phone, .rubix_cube]
    
    var score = 0
    var searching = false
    var itemToSearchFor: String?
    var timer: Timer?
    var timeLeft = 10
    
    @objc
    func startSearching() {
        fetchItem()
        timeLeft = 10
        searching = true
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    
    func fetchItem() {
        if let item = items.randomElement() {
            items.remove(item)
            itemToSearchFor = item.rawValue.capitalized
            delegate?.gameLayer(itemToFind: item.rawValue.capitalized)
            return
        }
        itemToSearchFor = nil
        delegate?.gameLayer(itemToFind: "")
    }
    
    func checkItem(_ item: String) {
        if item == itemToSearchFor {
            score += 1
            searching = false
            timer?.invalidate()
            delegate?.gameLayer(countdown: "Nice 👍🏼")
        }
    }
    
    @objc
    func countdown() {
        
        delegate?.gameLayer(countdown: "\(timeLeft)")
        timeLeft -= 1
        
        if timeLeft <= 0 {
            timer?.invalidate()
            searching = false
        }
        
    }
    
}
