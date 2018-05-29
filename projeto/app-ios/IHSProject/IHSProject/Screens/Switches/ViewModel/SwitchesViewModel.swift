//
//  SwitchesViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import UIKit

class SwitchesViewModel: SwitchesViewModelProtocol, SwitchesDelegate {

    weak var delegate: SwitchesViewModelDelegate?
    private var switches: [Int] = []
    
    init() {
        
        var i = 0
        while i < 18 {
            self.switches.append(0)
            i = i + 1
        }
        
        Networking.shared.switches.delegate = self
        Networking.shared.switches.receiveUpdates(true)
    }
    
    func shouldGetStatusUpdates(_ value: Bool) {
        Networking.shared.switches.receiveUpdates(value)
    }
    
    func getSwitch(forIndexPath indexPath: IndexPath) -> Bool {
        return self.switches[indexPath.row] == 1
    }
    
    func didReceive(switchId: Int, value: Int) {
        self.switches[switchId] = value
        self.delegate?.didUpdateSwitchStatus()
    }
    
}
