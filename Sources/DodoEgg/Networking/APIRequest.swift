// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public enum APIRequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public protocol APIRequest {
    associatedtype QueryStringParameters: Encodable
    associatedtype PostParameters: Encodable
    
    var requestType: APIRequestType { get }
    var resourceName: String { get }
    var queryStringParameters: QueryStringParameters? { get }
    var postParameters: PostParameters? { get }
    var headers: [String: String] { get }
}

extension APIRequest {
    
    public var requestType: APIRequestType {
        return .get
    }
    
    public var queryStringParameters: [String]? {
        return nil
    }
    
    public var postParameters: [String]? {
        return nil
    }
    
    public var headers: [String: String] {
        return [:]
    }
}

open class APIRequestContainer<T: APIRequest> {
    public var values: [T] = []
}
