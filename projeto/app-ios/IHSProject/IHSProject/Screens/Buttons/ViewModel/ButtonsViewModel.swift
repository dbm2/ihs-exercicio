//
//  ButtonsViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

class ButtonsViewModel: ButtonsViewModelProtocol {
    
    var buttons: [Int] = Array(repeating: 0, count: 4)
    var lastPressed: [Double] = Array(repeating: Date.timeIntervalSinceReferenceDate, count: 4)
    
    func shouldGetStatusUpdates(_ value: Bool) {
        if value {
            Networking.shared.buttons.delegate = self
        } else {
            Networking.shared.buttons.delegate = nil
        }
        Networking.shared.buttons.receiveUpdates(value)
    }
    
    func getValue(forButton button: Int) -> Bool {
        return self.buttons[button] == 1
    }
    
    func getTimeSinceLastPressed(forButton button: Int) -> Double {
        return self.lastPressed[button]
    }
}

extension ButtonsViewModel: ButtonsDelegate {
    
    func didReceive(buttonId: Int, value: Int) {
        
        self.buttons[buttonId] = value
        self.lastPressed[buttonId] = Date.timeIntervalSinceReferenceDate
    }
}
