//
//  DisplayView.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class DisplayView: UIViewController {
    
    @IBOutlet weak var displayTxtField: UITextField!
    
    var viewModel: DisplayViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = DisplayViewModel()
        self.displayTxtField.clearsOnBeginEditing = true
    }
    
    @IBAction func sendDisplayValue(_ sender: Any) {
        guard let text = self.displayTxtField.text else {
            return
        }
        
        guard let value = Int(text) else {
            return
        }
        
        self.viewModel.setDisplay(value)
        self.displayTxtField.resignFirstResponder()
    }
}

extension DisplayView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = self.displayTxtField.text else {
            return true
        }
        
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
}
