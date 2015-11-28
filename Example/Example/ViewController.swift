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
        addButton.addInView(toolbar)
        addButton.setAction { [unowned self] in
            self.progress += 0.4
            addButton.setProgress(self.progress, animated: true)
        }
    }

}

