//
//  SwitchesProvider.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class SwitchesProvider: SwitchesProtocol {
    
    var socket: SocketIOClient
    weak var delegate: SwitchesDelegate?
    
    init(withSocket socket: SocketIOClient) {
        self.socket = socket
    }
    
    func receiveUpdates(_ value: Bool) {
        
        if value { 
            
            self.socket.on(Constants.Networking.Socket.SWITCHES_VALUE_EVENT) { (data, ack) in
                let jsonData: JSON = JSON(data)
                
                let switchId: Int = jsonData[0]["switch"].intValue
                let switchValue: Int = jsonData[0]["value"].intValue
                
                self.delegate?.didReceive(switchId: switchId, value: switchValue)
            }
        } else {
            
            self.socket.off(Constants.Networking.Socket.SWITCHES_VALUE_EVENT)
        }
    }
}
