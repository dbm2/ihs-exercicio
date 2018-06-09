//
//  GameViewModelDelegate.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 09/06/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol GameViewModelDelegate: class {
    
    func didPressLeftButton()
    
    func didPressRightButton()
    
    func didPressFireButton()
}
