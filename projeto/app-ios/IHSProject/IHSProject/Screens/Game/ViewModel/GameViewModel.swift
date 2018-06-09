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
    
    func shouldGetUpdates(_ value: Bool) {
        if value {
            Networking.shared.switches.delegate = self
            Networking.shared.buttons.delegate = self
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
        
        if value > 0 {
            if buttonId == 0 {
                self.delegate?.didPressLeftButton()
            } else if buttonId == 1 {
                self.delegate?.didPressRightButton()
            }
        }
    }
}
