//
//  GameSceneProtocol.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 09/06/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

protocol GameSceneProtocol {
    
    var gameDelegate: GameSceneDelegate? { get set }
    
    func fireTorpedo()
    
    func movePlayerLeft()
    
    func movePlayerRight()
}
