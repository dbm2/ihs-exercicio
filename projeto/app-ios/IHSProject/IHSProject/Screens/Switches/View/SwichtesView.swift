//
//  SwichesView.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 28/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class SwitchesView: UITableViewController, SwitchesViewModelDelegate {
    
    var viewModel: SwitchesViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelection = false

        self.viewModel = SwitchesViewModel()
        self.viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.shouldGetStatusUpdates(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.shouldGetStatusUpdates(false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 18
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "switchesTVCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "Switch \(indexPath.row)"
        
        let x = self.view.frame.size.width - 70
        let switchRect = CGRect(x: x, y: 10, width: 60, height: 30)
        let uiSwitch = UISwitch(frame: switchRect)
        
        uiSwitch.center.y = cell.center.y
        uiSwitch.isEnabled = false
        uiSwitch.isOn = self.viewModel.getSwitch(forIndexPath: indexPath)
        
        cell.addSubview(uiSwitch)

        return cell
    }
    
    func didUpdateSwitchStatus() {
        self.tableView.reloadData()
    }
}
