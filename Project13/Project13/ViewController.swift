//
//  ViewController.swift
//  Project13
//
//  Created by Saumitra Vaidya on 4/16/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit

protocol FilterType {
	associatedtype Filter: RawRepresentable
}

extension FilterType where Self: UIAlertController, Filter.RawValue == String {
	func addAction(title: Filter, styel: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction? {
		return UIAlertAction(title: title.rawValue, style: styel, handler: handler)
	}
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	enum Filter: String {
		case CIBumpDistortion
		case CIGaussianBlur
		case CIPixellate
		case CISepiaTone
		case CITwirlDistortion
		case CIUnsharpMask
		case CIVignette
	}

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var intensitySlider: UISlider!
	
	var currentImage: UIImage!
	var context: CIContext!
	var currentFilter: CIFilter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "YACIF"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(importPicture))
		
		context = CIContext(options: nil)
		currentFilter = CIFilter(name: "CISepiaTone")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func changeFilter(sender: AnyObject) {
		let alertController = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .Alert)
		
		alertController.addAction(UIAlertAction(title: Filter.CIBumpDistortion.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CIGaussianBlur.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CIPixellate.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CISepiaTone.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CITwirlDistortion.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CIUnsharpMask.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: Filter.CIVignette.rawValue, style: .Default, handler: setFilter))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
//		alertController.addAction(UIAlertAction(title: .CIBumpDistortion, style: .Default, handler: setFilter))
		
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	@IBAction func save(sender: AnyObject) {
		
	}
	
	@IBAction func intensityChange(sender: AnyObject) {
		applyProcessing()
	}
	
	func importPicture() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		presentViewController(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		var newImage: UIImage
		
		if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			newImage = possibleImage
		} else {
			return
		}
		
		dismissViewControllerAnimated(true, completion: nil)
		
		currentImage = newImage
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func applyProcessing() {
		currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
		
		let cgiimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
		let processedImage = UIImage(CGImage: cgiimg)
		
		imageView.image = processedImage
	}
	
	func setFilter(action: UIAlertAction!) {
		currentFilter = CIFilter(name: action.title!)
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		applyProcessing()
	}
}

