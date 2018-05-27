//
//  ViewController.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 22/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.shared.switches.delegate = self
        Networking.shared.buttons.delegate = self
        Networking.shared.display.delegate = self
    }
    
    @IBAction func send(_ sender: Any) {
        var value: Int = 0
        
        if let textString = self.text.text {
            value = Int(textString)!
        }
        
        Networking.shared.display.set(value: value)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Networking.shared.switches.receiveUpdates(true)
        Networking.shared.buttons.receiveUpdates(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Networking.shared.switches.receiveUpdates(false)
        Networking.shared.buttons.receiveUpdates(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: SwitchesDelegate {
    
    func didReceive(switchId: Int, value: Int) {
        print("recebeu switch \(switchId): \(value)")
    }
}

extension ViewController: ButtonsDelegate {
    
    func didReceive(buttonId: Int, value: Int) {
        print("recebeu button \(buttonId): \(value)")
    }

}

extension ViewController: DisplayDelegate {
    
    func didSet(withSuccess success: Bool) {
        print("setou display")
    }
}
