//
//  SwitchesProtocol.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO

protocol SwitchesProtocol {
    
    var socket: SocketIOClient { get }
    var delegate: SwitchesDelegate! { get set }
    
    func receiveUpdates(_ value: Bool)
}
