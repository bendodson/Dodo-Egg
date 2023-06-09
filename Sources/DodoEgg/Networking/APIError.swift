// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public enum APIError: Error {
    case decoding(reason: String, data: Data? = nil)
    case unexpectedStatusCode
    case server
    case request(data: Data?, httpStatusCode: Int)
    case invalidURL
    case noData
    case network
    case cancelled
    case unknown
}
