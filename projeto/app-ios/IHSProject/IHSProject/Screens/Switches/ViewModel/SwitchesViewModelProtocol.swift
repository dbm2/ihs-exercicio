//
//  SwitchesViewModelProtocol.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol SwitchesViewModelProtocol {
    
    var delegate: SwitchesViewModelDelegate? { get set }
    
    func shouldGetStatusUpdates(_ value: Bool)
    
    func getSwitch(forIndexPath: IndexPath) -> Bool
}
