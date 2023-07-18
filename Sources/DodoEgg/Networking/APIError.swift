// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public enum APIError: Error {
    case decoding(reason: String, data: Data? = nil)
    case unexpectedStatusCode(httpStatusCode: Int)
    case server(data: Data?, httpStatusCode: Int)
    case request(data: Data?, httpStatusCode: Int)
    case noData
    case network(errorCode: Int)
    case cancelled
    case unknown
}
