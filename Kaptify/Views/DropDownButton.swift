//
//  DropDownButton.swift
//  Kaptify
//
//  Created by Sahil Kapal on 2018-07-19.
//  Copyright © 2018 Sahil Kapal. All rights reserved.
//

import UIKit


class DropDownButton: UIButton {
    
    var height = NSLayoutConstraint()
    var isOpen: Bool = false
    
    var dropView = DropDownView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        dropView = DropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.translatesAutoresizingMaskIntoConstraints = false
        
        //add shadow
        
        
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubview(toFront: dropView)
        
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.rightAnchor.constraint(equalTo: (superview?.rightAnchor)!).isActive = true
        dropView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(isOpen)
        if !isOpen {
            isOpen = true
            animateDropDown(toHeight: 86, with: 1)
        } else {
            isOpen = false
            animateDropDown(toHeight: 0, with: -1)
        }
    }
    
    func animateDropDown(toHeight height: CGFloat, with multiplier: CGFloat) {
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = height
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            if multiplier == 1 {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y = self.dropView.center.y  + multiplier * (self.dropView.frame.height/2)
            } else {
                self.dropView.center.y = self.dropView.center.y  + multiplier * (self.dropView.frame.height/2)
                self.dropView.layoutIfNeeded()
            }
            
        }, completion: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
