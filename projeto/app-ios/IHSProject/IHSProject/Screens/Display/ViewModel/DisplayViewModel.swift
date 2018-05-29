//
//  DisplayViewModel.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import Foundation
import UIKit

class DisplayViewModel: DisplayViewModelProtocol, DisplayDelegate {
    
    weak var delegate: DisplayViewModelDelegate?
    
    init() {
        Networking.shared.display.delegate = self
    }
    
    func setDisplay(_ value: Int) {
        Networking.shared.display.set(value: value)
    }
    
    func didSet(withSuccess success: Bool) {
        self.delegate?.didUpdateDisplay()
    }
}
