//
//  ButtonsProvider.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 23/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

class ButtonsProvider: ButtonsProtocol {
    
    var socket: SocketIOClient
    weak var delegate: ButtonsDelegate?
    
    init(withSocket socket: SocketIOClient) {
        self.socket = socket
    }
    
    func receiveUpdates(_ value: Bool) {
        
        if value {
            
            self.socket.on(Constants.Networking.Socket.BUTTONS_VALUE_EVENT) { (data, ack) in
                let jsonData: JSON = JSON(data)
                
                let buttonId: Int = jsonData[0]["button"].intValue
                let buttonValue: Int = jsonData[0]["value"].intValue
                
                self.delegate?.didReceive(buttonId: buttonId, value: buttonValue)
            }
        } else {
            
            self.socket.off(Constants.Networking.Socket.BUTTONS_VALUE_EVENT)
        }
    }
}
