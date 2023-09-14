//
//  ViewController.swift
//  DigiIDSwiftPackage
//
//  Created by D, Bishwajit (Consumer Servicing & Engagement) on 14/09/23.
//

import UIKit

class LandingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let testView = TestView(frame: .zero)
        self.view.addSubview(testView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[lv]-0-|", metrics: nil, views: ["lv" : testView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[lv]-0-|", metrics: nil, views: ["lv" : testView]))
    }
}

