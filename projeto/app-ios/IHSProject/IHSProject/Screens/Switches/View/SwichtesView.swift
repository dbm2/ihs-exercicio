//
//  SwichesView.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class SwitchesView: UITableViewController {
    
    var viewModel: SwitchesViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false

        self.viewModel = SwitchesViewModel()
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.shouldGetStatusUpdates(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.shouldGetStatusUpdates(false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 18
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchesTVCell", for: indexPath) as! SwitchesTVCell
        
        switchCell.indentifier = indexPath.row
        switchCell.enable = self.viewModel.getSwitch(forIndexPath: indexPath)

        return switchCell
    }
}

extension SwitchesView: SwitchesViewModelDelegate {
    
    func didUpdateSwitchStatus() {
        self.tableView.reloadData()
    }
}
