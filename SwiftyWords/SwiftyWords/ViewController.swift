//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Saumitra Vaidya on 1/21/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var currentAnswerField: UITextField!
    @IBOutlet var letterOutletCollection: [UIButton]!
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func submitTapped(sender: AnyObject) {
        if let solutionPosition = solutions.indexOf(currentAnswerField.text!) {
            activatedButtons.removeAll()
            
            var splitClues = answersLabel.text!.componentsSeparatedByString("\n")
            splitClues[solutionPosition] = currentAnswerField.text!
            answersLabel.text = splitClues.joinWithSeparator("\n")
            
            currentAnswerField.text = ""
            ++score
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
                presentViewController(ac, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func clearTapped(sender: AnyObject) {
        currentAnswerField.text = ""
        
        for btn in activatedButtons {
            btn.enabled = true
        }
        
        activatedButtons.removeAll()
    }
    
    @IBAction func letterTapped(sender: UIButton) {
        currentAnswerField.text = currentAnswerField.text! + sender.titleLabel!.text!
        activatedButtons.append(sender)
        sender.enabled = !sender.enabled
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil) {
                var lines = levelContents.componentsSeparatedByString("\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String]
                
                for (index, line) in lines.enumerate() {
                    var parts = line.componentsSeparatedByString(": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString = "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "")
                    solutionsString += "\(solutionWord.characters.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.componentsSeparatedByString("|")
                    letterBits += bits
                    
                    // Configure UI
                    
                    cluesLabel.text = clueString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
                    answersLabel.text = solutionsString.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
                    
                    letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
                    letterOutletCollection = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterOutletCollection) as! [UIButton]
                    
                    if letterBits.count == letterOutletCollection.count {
                        for i in 0 ..< letterBits.count {
                            letterOutletCollection[i].setTitle(letterBits[i], forState: .Normal)
                        }
                    }
                    
                }
            }
        }
    }
    
    func levelUp(action: UIAlertAction!) {
        ++level
        solutions.removeAll(keepCapacity: true)
        
        loadLevel()
        
        for btn in letterOutletCollection {
            btn.hidden = false
        }
    }
    
}

