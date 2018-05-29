//
//  DisplayViewModelProtocol.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol DisplayViewModelProtocol {
 
    var delegate: DisplayViewModelDelegate? { get set }
    
    func setDisplay(_ value: Int)
}
