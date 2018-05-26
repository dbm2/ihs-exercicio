//
//  DisplayProtocol.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 23/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO

protocol DisplayProtocol {
    
    var socket: SocketIOClient { get }
    var delegate: DisplayDelegate? { get set }
    
    func set(value: Int)
}
