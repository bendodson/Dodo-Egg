// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public enum APIError: Error {
    case encoding
    case decoding(reason: String, data: Data? = nil)
    case unexpectedStatusCode
    case server
    case request(response: Data?)
    case invalidURL
    case noData
    case network
    case cancelled
    case unknown
}
