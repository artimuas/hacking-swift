//
//  ViewController.swift
//  SimpleBrowser
//
//  Created by Saumitra Vaidya on 9/20/15.
//  Copyright © 2015 agratas. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!

    private enum ActionKeys: Selector {
        case Open = "open"
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .Plain, target: self, action: ActionKeys.Open.rawValue)

        let url = NSURL(string: "https://hackingwithswift.com")!
        webView.loadRequest(NSURLRequest(URL: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func open() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "google.com", style: .Default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func openPage(action: UIAlertAction!) {
        let url = NSURL(string: "https://" + action.title!)!
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    //MARK: Webkit Navigation Delegate
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        title = webView.title
    }
}

