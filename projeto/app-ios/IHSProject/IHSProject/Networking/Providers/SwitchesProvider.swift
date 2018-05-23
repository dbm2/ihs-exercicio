//
//  SwitchesProvider.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO

class SwitchesProvider: SwitchesProtocol {
    
    var socket: SocketIOClient
    var delegate: SwitchesDelegate!
    
    init(withSocket socket: SocketIOClient) {
        self.socket = socket
    }
    
    func receiveUpdates(_ value: Bool) {
        
        if value { 
            
            self.socket.on(Constants.Networking.Socket.SWITCHES_VALUE_EVENT) { (data, ack) in
                print(data)
                
                let switchId: Int = 0 //decode data
                let switchValue: Int = 0 //decode data
                
                self.delegate.didReceive(switch: switchId, value: switchValue)
            }
        } else {
            
            self.socket.off(Constants.Networking.Socket.SWITCHES_VALUE_EVENT)
        }
    }
}
