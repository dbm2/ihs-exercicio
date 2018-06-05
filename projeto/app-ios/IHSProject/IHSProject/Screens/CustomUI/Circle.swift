//
//  Circle.swift
//  IHSProject
//
//  Created by Matheus Coelho Berger on 30/05/18.
//  Copyright © 2018 Daniel Barbosa Maranhão. All rights reserved.
//

import UIKit

class Circle: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setCorners()
        self.setColor(UIColor.red)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCorners()
        self.setColor(UIColor.red)
    }
    
    init(center: CGPoint, radius: CGFloat) {
        let size = CGSize(width: radius, height: radius)
        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let frame = CGRect(origin: origin, size: size)
        super.init(frame: frame)
        
        self.setCorners()
        self.setColor(UIColor.red)
    }
    
    fileprivate func setCorners() {
        let radius = self.frame.size.width/2
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func setColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}
