//
//  DataInstance.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO

class Networking {
    
    static let shared: Networking = Networking()
    
    var switches: SwitchesProtocol
    
    private var socketManeger: SocketManager
    private var socket: SocketIOClient
    
    init() {

        let serverURL: URL = URL(string: Constants.Networking.URL)!
        
        self.socketManeger = SocketManager(socketURL: serverURL, config: [.log(true)]) //
        self.socket = self.socketManeger.defaultSocket
        
        self.socket.on(clientEvent: .connect) { (data, ack) in
            print("[Networking] Socket.io client connected with the server.")
        }
        
        self.socket.on(clientEvent: .disconnect) { (data, ack) in
            print("[Networking] Socket.io disconnected from the server.")
        }
        
        self.socket.connect()
        
        self.switches = SwitchesProvider(withSocket: self.socket)
    }
}
