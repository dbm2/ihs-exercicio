//
//  GameViewModelProtocol.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 09/06/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol GameViewModelProtocol {
    
    var delegate: GameViewModelDelegate? { get set }
    
    func shouldGetUpdates(_ value: Bool)
    
    func set(score: Int)
}
