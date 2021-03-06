//
//  ButtonsDelegate.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 23/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol ButtonsDelegate: class {
    
    func didReceive(buttonId: Int, value: Int)
}
