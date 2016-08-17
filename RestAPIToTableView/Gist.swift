//
//  Gist.swift
//  RestAPIToTableView
//
//  Created by 柯秉钧 on 16/8/17.
//  Copyright © 2016年 柯秉钧. All rights reserved.
//

import Foundation
import SwiftyJSON
class Gist: ResponseJSONObjectSerializable {
	var id: String?
	var description: String?
	var ownerLogin: String?
	var ownerAvatarURL: String?
	var url: String?
	
	required init(json: JSON) {
		self.id = json["id"].string
		self.description = json["description"].string
		self.ownerLogin = json["owner"]["login"].string
		self.ownerAvatarURL = json["owner"]["avatar_url"].string
		self.url = json["url"].string
	}
	required init() {
		
	}
	
}
