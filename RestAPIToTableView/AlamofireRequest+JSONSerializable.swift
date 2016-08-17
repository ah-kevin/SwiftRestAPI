//
//  File.swift
//  RestAPIToTableView
//
//  Created by 柯秉钧 on 16/8/17.
//  Copyright © 2016年 柯秉钧. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
public protocol ResponseJSONObjectSerializable {
	init?(json: SwiftyJSON.JSON)
}

extension Alamofire.Request {
	// 返回对象
	public func responseObject<T: ResponseJSONObjectSerializable>(completionHandler:
			Response<T, NSError> -> Void) -> Self {
				let serializer = ResponseSerializer<T, NSError> { request, response, data, error in
					guard error == nil else {
						return .Failure(error!)
					}
					guard let responseData = data else {
						let failureReason = "Object could not be serialized because input data was nil."
						let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
						let error = NSError(domain: "返回数据错误", code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
						return .Failure(error)
					}
					let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
					let result = JSONResponseSerializer.serializeResponse(request, response,
						responseData, error)
					switch result {
					case .Failure(let error):
						return .Failure(error)
					case .Success(let value):
						let json = SwiftyJSON.JSON(value)
						if let errorMessage = json["message"].string {
							let userInfo = [NSLocalizedFailureReasonErrorKey: errorMessage]
							let error = NSError(domain: "出错", code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
							return .Failure(error)
						}
						guard let object = T(json: json) else {
							let failureReason = "Object could not be created from JSON."
							let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
							let error = NSError(domain: "无法创建json", code: Error.Code.JSONSerializationFailed.rawValue, userInfo: userInfo)
							return .Failure(error)
						}
						return .Success(object)
				} }
				return response(responseSerializer: serializer, completionHandler: completionHandler)
	}
	// 返回[T]对象数组
	public func responseArray<T: ResponseJSONObjectSerializable>(completionHandler:
			Response<[T], NSError> -> Void) -> Self {
				let serializer = ResponseSerializer<[T], NSError> { request, response, data, error in
					guard error == nil else {
						return .Failure(error!)
					}
					guard let responseData = data else {
						let failureReason = "无法解析为数组，因为输入的数据为空。"
						let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
						let error = NSError(domain: "无法解析为数组，因为输入的数据为空。", code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
						return .Failure(error)
					}
					let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
					let result = JSONResponseSerializer.serializeResponse(request, response, responseData, error)
					switch result {
					case .Failure(let error):
						return .Failure(error)
					case .Success(let value):
						let json = SwiftyJSON.JSON(value)
						if let errormessage = json["message"].string {
							let userInfo = [NSLocalizedFailureReasonErrorKey: errormessage]
							let error = NSError(domain: "出错", code: Error.Code.DataSerializationFailed.rawValue, userInfo: userInfo)
							return .Failure(error)
						}
						var objects: [T] = []
						for (_, item) in json {
							if let object = T(json: item) {
								objects.append(object)
							}
						}
						return .Success(objects)
					}
					
				}
				return response(responseSerializer: serializer, completionHandler: completionHandler)
	}
}

