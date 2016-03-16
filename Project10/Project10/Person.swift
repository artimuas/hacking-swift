//
//  Person.swift
//  Project10
//
//  Created by Saumitra Vaidya on 3/15/16.
//  Copyright © 2016 agratas. All rights reserved.
//

import UIKit

class Person: NSObject {
	var name: String
	var image: String
	
	init(name: String, image: String) {
		self.name = name
		self.image = image
	}
}
