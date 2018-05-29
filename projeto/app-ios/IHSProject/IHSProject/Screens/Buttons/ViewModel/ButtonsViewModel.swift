//
//  ButtonsViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

class ButtonsViewModel: ButtonsViewModelProtocol {
    
    var buttons: [Double] = Array(repeating: 0.0, count: 4)
    
    func shouldGetStatusUpdates(_ value: Bool) {
        if value {
            Networking.shared.buttons.delegate = self
        } else {
            Networking.shared.buttons.delegate = nil
        }
        Networking.shared.buttons.receiveUpdates(value)
    }
}

extension ButtonsViewModel: ButtonsDelegate {
    
    func didReceive(buttonId: Int, value: Int) {
        self.buttons[buttonId] = Date.timeIntervalSinceReferenceDate
    }
}
