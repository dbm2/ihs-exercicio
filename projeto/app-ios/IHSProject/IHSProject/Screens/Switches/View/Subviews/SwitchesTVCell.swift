//
//  SwitchesTVCell.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class SwitchesTVCell: UITableViewCell {
    
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var uiSwitch: UISwitch!
    
    var indentifier: Int = 0 {
        didSet {
            self.switchLabel.text = "Switch \(self.indentifier)"
        }
    }
    
    var enable: Bool = false {
        didSet {
            self.uiSwitch.isOn = self.enable
        }
    }
}
