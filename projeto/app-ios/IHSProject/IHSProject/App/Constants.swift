//
//  Constants.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation

class Constants {
    
    class Networking {
        
        static let URL = "http://192.168.0.12:3000"
        
        static let URL_DISPLAY = URL + "/display"
        static let URL_DISPLAY_VALUE = URL_DISPLAY + "/value"
        
        
        class Socket {
            
            static let SWITCHES_VALUE_EVENT = "SwitchesValueChanged"
            static let BUTTONS_VALUE_EVENT = "ButtonsValueChanged"
        }
    }
}
