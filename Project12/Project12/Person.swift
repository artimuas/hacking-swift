//
//  Person.swift
//  Project10
//
//  Created by Saumitra Vaidya on 3/15/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
	var name: String
	var image: String
	
	required init?(coder aDecoder: NSCoder) {
		name = aDecoder.decodeObjectForKey("name") as! String
		image = aDecoder.decodeObjectForKey("image") as! String
	}
	
	func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(name, forKey: "name")
		aCoder.encodeObject(image, forKey: "image")
	}
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
