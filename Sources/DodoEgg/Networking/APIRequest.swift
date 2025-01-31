// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public enum APIRequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

public protocol APIRequest: Hashable {
    associatedtype QueryStringParameters: Encodable
    associatedtype PostParameters: Encodable

    var identifier: String { get }
    var requestType: APIRequestType { get }
    var resourceName: String { get }
    var queryStringParameters: QueryStringParameters? { get }
    var postParameters: PostParameters? { get }
    var headers: [String: String] { get }
    var arePostParametersRedacted: Bool { get }
}

extension APIRequest {

    public var identifier: String {
        return UUID().uuidString
    }
    
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
    
    public var arePostParametersRedacted: Bool {
        return false
    }
}

open class APIRequestContainer<T: APIRequest> {
    public var values: [T] = []
}
