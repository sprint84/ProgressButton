//
//  ViewController.swift
//  Example
//
//  Created by Guilherme Moura on 11/24/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit
import RFProgressButton

class ViewController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    var progress = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = RFProgressButton()
        addButton.setAction { [unowned self] in
            self.progress += 0.1
            addButton.setProgress(self.progress, animated: true)
        }
        addButton.warningProgressColor = UIColor.redColor()
        addButton.warningProgressThreshold = 0.9
        addButton.addInView(toolbar)
    }

}

