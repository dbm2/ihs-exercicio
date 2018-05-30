//
//  ButtonsViewModelProtocol.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol ButtonsViewModelProtocol {
    
    func shouldGetStatusUpdates(_ value: Bool)

    func getValue(forButton button: Int) -> Bool
    
    func getTimeSinceLastPressed(forButton button: Int) -> Double
}
