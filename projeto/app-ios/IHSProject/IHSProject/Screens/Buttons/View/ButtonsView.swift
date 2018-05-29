//
//  ButtonsView.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class ButtonsView: UIViewController {

    var viewModel: ButtonsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = ButtonsViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.shouldGetStatusUpdates(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.shouldGetStatusUpdates(false)
    }
}
