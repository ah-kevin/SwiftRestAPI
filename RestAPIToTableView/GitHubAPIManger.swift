
//
//  GitHubAPIManger.swift
//  RestAPIToTableView
//
//  Created by 柯秉钧 on 16/8/17.
//  Copyright © 2016年 柯秉钧. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
class GitHubAPIManager {
	static let sharedInstance = GitHubAPIManager()
	var alamofireManger: Alamofire.Manager
	init() {
		let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
		alamofireManger = Alamofire.Manager(configuration: configuration)
	}
	// MARK: -获取公共的gists
	func printPublicGist() {
		Alamofire.request(GistRouter.GetPublic())
			.responseString { (response) in
				if let receivedSting = response.result.value {
					print(receivedSting)
				}
		}
	}
	func fetchPublicGist(completionHandeler: (Result<[Gist], NSError>) -> Void) {
		Alamofire.request(GistRouter.GetPublic())
			.responseArray { (response: Response<[Gist], NSError>) in
				completionHandeler(response.result)
		}
	}
}