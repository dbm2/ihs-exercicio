//
//  ButtonsViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

class ButtonsViewModel: ButtonsViewModelProtocol, ButtonsDelegate {
    
    var buttons: [Double] = []
    
    init() {
        Networking.shared.buttons.delegate = self
        Networking.shared.buttons.receiveUpdates(true)
        
        var i = 0
        while i < 4 {
            buttons.append(0)
            i = i + 1
        }
    }
    
    func didReceive(buttonId: Int, value: Int) {
        self.buttons[buttonId] = Date.timeIntervalSinceReferenceDate
    }
}
