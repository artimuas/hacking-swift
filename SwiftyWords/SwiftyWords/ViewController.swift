//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Saumitra Vaidya on 1/21/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentAnswerField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func submitTapped(sender: AnyObject) {
    }
    
    
    @IBAction func clearTapped(sender: AnyObject) {
    }
    
}

