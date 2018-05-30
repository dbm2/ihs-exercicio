//
//  ButtonsView.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class ButtonsView: UIViewController {

    @IBOutlet var circleColection: [Circle]!
    @IBOutlet var labelCollection: [UILabel]!
    
    var viewModel: ButtonsViewModelProtocol!
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = ButtonsViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.shouldGetStatusUpdates(true)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateUI), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.shouldGetStatusUpdates(false)
        
        self.timer.invalidate()
    }
    
    @objc func updateUI() {
        var index = 0
        var color = UIColor.red
        
        while index < 4 {
            if self.viewModel.getValue(forButton: index) {
                color = UIColor.green
            }
            let time = Int(Date.timeIntervalSinceReferenceDate - self.viewModel.getTimeSinceLastPressed(forButton: index))
            
            self.circleColection[index].setColor(color)
            self.labelCollection[index].text = "\(time)s"
            index = index + 1
        }
    }
}
