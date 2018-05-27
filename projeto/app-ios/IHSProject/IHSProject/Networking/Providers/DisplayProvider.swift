//
//  DisplayProvider.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 23/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO

class DislayProvider: DisplayProtocol {
    
    var socket: SocketIOClient
    weak var delegate: DisplayDelegate?
    
    init(withSocket socket: SocketIOClient) {
        self.socket = socket
    }
    
    func set(value: Int) {
        guard (self.socket.status == .connected) else {
            self.delegate?.didSet(withSuccess: false)
            return
        }
        
        self.socket.emit(Constants.Networking.Socket.DISPLAY_VALUE_EVENT, with: [value])
        self.delegate?.didSet(withSuccess: true)
    }
}
