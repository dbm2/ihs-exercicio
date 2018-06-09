//
//  GameView.swift
//  IHSProject
//
//  Created by Daniel Barbosa Maranhão on 08/06/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameView: UIViewController {
    
    var viewModel: GameViewModelProtocol!
    
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = GameViewModel()
        self.viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.shouldGetUpdates(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.viewModel.shouldGetUpdates(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    
        let skView: SKView = self.view as! SKView
        skView.showsFPS = false
        
        self.scene = GameScene(size: skView.bounds.size)
        self.scene.scaleMode = .aspectFill
        self.scene.gameDelegate = self
        skView.presentScene(self.scene)
    }
}

extension GameView: GameViewModelDelegate {
    
    func didPressLeftButton() {
        self.scene.movePlayerLeft()
    }
    
    func didPressRightButton() {
        self.scene.movePlayerRight()
    }
    
    func didPressFireButton() {
        self.scene.fireTorpedo()
    }
}

extension GameView: GameSceneDelegate {
    
    func didChange(score: Int) {
        self.viewModel.set(score: score)
    }
}
