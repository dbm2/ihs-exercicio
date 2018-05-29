//
//  SwitchesViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import UIKit

class SwitchesViewModel: SwitchesViewModelProtocol {

    weak var delegate: SwitchesViewModelDelegate?
    
    private var switches: [Int] = Array(repeating: 0, count: 18)
    
    func shouldGetStatusUpdates(_ value: Bool) {
        if value {
            Networking.shared.switches.delegate = self
        } else {
            Networking.shared.switches.delegate = nil
        }
        Networking.shared.switches.receiveUpdates(value)
    }
    
    func getSwitch(forIndexPath indexPath: IndexPath) -> Bool {
        return self.switches[indexPath.row] == 1
    }
}

extension SwitchesViewModel: SwitchesDelegate {
    
    func didReceive(switchId: Int, value: Int) {
        self.switches[switchId] = value
        self.delegate?.didUpdateSwitchStatus()
    }
}
