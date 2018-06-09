//
//  GameViewModel.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 09/06/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

class GameViewModel: GameViewModelProtocol {
    
    weak var delegate: GameViewModelDelegate?
    
    fileprivate var isSendingUpdates: Bool = false
    fileprivate var isPressingLeft: Bool = false
    fileprivate var isPressingRight: Bool = false
    
    func shouldGetUpdates(_ value: Bool) {
        self.isSendingUpdates = value
        if value {
            Networking.shared.switches.delegate = self
            Networking.shared.buttons.delegate = self
            self.sendMovementUpdates()
        } else {
            Networking.shared.switches.delegate = nil
            Networking.shared.buttons.delegate = nil
        }
        Networking.shared.switches.receiveUpdates(value)
        Networking.shared.buttons.receiveUpdates(value)
        
        Networking.shared.display.set(value: 0)
    }
    
    func set(score: Int) {
        Networking.shared.display.set(value: score)
    }
    
    @objc func sendMovementUpdates() {
        guard self.isSendingUpdates else {
            self.isPressingLeft = false
            self.isPressingRight = false
            return
        }
        
        if self.isPressingLeft {
            self.delegate?.didPressLeftButton()
        }
        
        if self.isPressingRight {
            self.delegate?.didPressRightButton()
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.sendMovementUpdates()
        }
    }
}

extension GameViewModel: SwitchesDelegate {
    
    func didReceive(switchId: Int, value: Int) {
        
        if value > 0 {
            if switchId == 0 {
                self.delegate?.didPressFireButton()
            }
        }
    }
}

extension GameViewModel: ButtonsDelegate {
    
    func didReceive(buttonId: Int, value: Int) {
        
        if buttonId == 0 {
            self.isPressingLeft = (value == 0)
        } else if buttonId == 1 {
            self.isPressingRight = (value == 0)
        }
    }
}
