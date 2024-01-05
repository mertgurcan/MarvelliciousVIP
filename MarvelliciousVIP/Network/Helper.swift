//
//  Helper.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 4.01.2024.
//

import Foundation

public enum URLNetworkResponse<Value> {
    case succes(Value)
    case failure(CustomError)
}

open class Resource<T: Codable> {
    public let url : String
    public var param : [String:Any]?

    public init(url: String, param: [String:Any]? = nil) {
        self.url = url
        self.param = param
    }
}
