//
//  DetailViewController.swift
//  ActivityViewController
//
//  Created by Saumitra Vaidya on 9/9/15.
//  Copyright (c) 2015 agratas. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    private enum ActionKeys: Selector {
        case Share = "share"
    }
    
    var detailItem: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    //MARK:- Configuring view
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: String = detailItem {
            if let imageView = detailImageView {
                imageView.image = UIImage(named: detail)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: ActionKeys.Share.rawValue)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func share() {
        let activityVC = UIActivityViewController(activityItems: [detailImageView.image!], applicationActivities: [])
        presentViewController(activityVC, animated: true, completion: nil)
        
//        let fbVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        fbVC.setInitialText("This lovely picture")
//        fbVC.addImage(detailImageView.image!)
//        fbVC.addURL(NSURL(string: "http://www.photolib.noaa.gov/nssl"))
//        presentViewController(fbVC, animated: true, completion: nil)
    }

}

