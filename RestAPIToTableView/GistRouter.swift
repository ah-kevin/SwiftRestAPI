//
//  GistRouter.swift
//  RestAPIToTableView
//
//  Created by 柯秉钧 on 16/8/17.
//  Copyright © 2016年 柯秉钧. All rights reserved.
//

import Foundation
import Alamofire
enum GistRouter: URLRequestConvertible {
	static let baseURLString: String = "https://api.github.com/"
	case GetPublic() // GET https://api.github.com/gists/public
	var URLRequest: NSMutableURLRequest {
		var method: Alamofire.Method {
			switch self {
			case .GetPublic:
				return .GET
			}
		}
		let url: NSURL = {
			let relativePath: String?
			switch self {
			case .GetPublic():
				relativePath = "gists/public"
			}
			var URL = NSURL(string: GistRouter.baseURLString)!
			if let relativePath = relativePath {
				URL = URL.URLByAppendingPathComponent(relativePath)
			}
			return URL
		}()
		let params: ([String: AnyObject]?) = {
			switch self {
			case .GetPublic:
				return nil
				
			}
		}()
		// 请求设置
		let URLRequest = NSMutableURLRequest(URL: url)
		URLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
		let encoding = Alamofire.ParameterEncoding.JSON
		let (encodeRequest, _) = encoding.encode(URLRequest, parameters: params)
		encodeRequest.HTTPMethod = method.rawValue
		return encodeRequest
	}
}
