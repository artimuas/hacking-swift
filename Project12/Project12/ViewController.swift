//
//  ViewController.swift
//  Project10
//
//  Created by Saumitra Vaidya on 2/21/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewController.addNewPerson))
		
		if let savedPeople = NSUserDefaults.standardUserDefaults().objectForKey("people") as? NSData {
			people = NSKeyedUnarchiver.unarchiveObjectWithData(savedPeople) as! [Person]
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	//MARK:- Collection View Data Source
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return people.count
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("personCell", forIndexPath: indexPath) as! PersonCell
		
		let person = people[indexPath.item]
		
		cell.name.text = person.name
		
		let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(person.image)
		cell.imageView.image = UIImage(contentsOfFile: imagePath)
		
		cell.imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
		cell.imageView.layer.borderWidth = 2
		cell.imageView.layer.cornerRadius = 3
		cell.layer.cornerRadius = 7
		
		return cell
	}
	
	//MARK:- Collection View Delegate
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let person = people[indexPath.item]
		
		let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .Alert)
		ac.addTextFieldWithConfigurationHandler(nil)
		
		ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
		
		ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [unowned self, ac] _ in
			person.name = ac.textFields![0].text!
			self.save()
			self.collectionView.reloadData()
		}))
		
		presentViewController(ac, animated: true, completion: nil)
	}
	
	//MARK:- Actions
	
	func addNewPerson() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		presentViewController(picker, animated: true, completion: nil)
	}
	
	//MARK:- Image Picker Controller Delegate
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		var newImage: UIImage
		
		if let possibleImage = editingInfo![UIImagePickerControllerEditedImage] as? UIImage {
			newImage = possibleImage
		} else if let possibleImage = editingInfo![UIImagePickerControllerOriginalImage] as? UIImage {
			newImage = possibleImage
		} else {
			return
		}
		
		let imageName = NSUUID().UUIDString
		let imagePath = getDocumentsDirectory().stringByAppendingPathComponent(imageName)
		
		if let jpegData = UIImageJPEGRepresentation(newImage, 80) {
			jpegData.writeToFile(imagePath, atomically: true)
		}
		
		let person = Person(name: "Unknown", image: imageName)
		people.append(person)
		save()
		collectionView.reloadData()
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: Helper
	
	func getDocumentsDirectory() -> NSString {
		let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
		return paths[0] as NSString
	}
	
	func save() {
		let savedData = NSKeyedArchiver.archivedDataWithRootObject(people)
		NSUserDefaults.standardUserDefaults().setObject(savedData, forKey: "people")
	}
	
}

