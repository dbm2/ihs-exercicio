//
//  SwitchesDelegate.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol SwitchesDelegate: class {
    
    func didReceive(switch: Int, value: Int)
}
