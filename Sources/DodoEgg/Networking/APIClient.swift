// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

public protocol APIClient: AnyObject {
    var activeTasks: Set<URLSessionDataTask> { get set }
    static var endpoint: String { get }
    var defaultQueryStringParameters: [URLQueryItem] { get }
    var defaultHeaders: [String: String] { get }
}

public typealias APIResponse = Result<Data?, APIError>
public typealias APIHandler = (APIResponse) -> Void
public typealias DecodeResponse<T: Decodable> = Result<T, APIError>
public typealias DecodeHandler<T: Decodable> = (DecodeResponse<T>) -> Void

extension APIClient {
    
    public var defaultHeaders: [String: String] {
        return [:]
    }
    
    public var baseEndpoint: URL {
        guard let url = URL(string: Self.self.endpoint) else {
            fatalError("Invalid URL for configuration: \(Self.self.endpoint)")
        }
        return url
    }
    
    public func send<T: APIRequest, D:Decodable>(_ request: T, andDecodeTo decodeType: D.Type, onCompletion completionHandler: @escaping DecodeHandler<D>) {
        send(request) { (response) in
            completionHandler(self.decode(decodeType, from: response))
        }
    }

    public func send<T: APIRequest>(_ request: T, onCompletion completionHandler: @escaping APIHandler) {
        let url = endpoint(for: request)
        
        #warning("NEED SOME SORT OF LOGGING SYSTEM")
        //writeLog("Network request: \(url)")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.requestType.rawValue
        for (field, value) in defaultHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        for (field, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
               
        if request.requestType != .get, let parameters = request.postParameters {
            do {
                if urlRequest.allHTTPHeaderFields?["Content-Type"] == "application/json" {
                    do {
                        urlRequest.httpBody = try JSONEncoder().encode(parameters)
                    } catch {
                        fatalError("Can't encode HTTP body")
                    }
                } else {
                    let postParameters = try URLQueryItemEncoder.encode(parameters)
                    let components = postParameters.map({String(format: "%@=%@", $0.name, $0.value ?? "")})
                    urlRequest.httpBody = components.joined(separator: "&").data(using: .utf8)
                }
                if let data = urlRequest.httpBody, let string = String(data: data, encoding: .utf8) {
                    #warning("Logging required")
                    //writeLog("\(request.requestType.rawValue): \(string)")
                }
            } catch {
                fatalError("Error on encoding passedQueryStringParameters: \(error)")
            }
        }
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let error = error {
                    let networkFailures: [Int] = [NSURLErrorTimedOut, NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost, NSURLErrorNetworkConnectionLost, NSURLErrorDNSLookupFailed, NSURLErrorHTTPTooManyRedirects, NSURLErrorResourceUnavailable, NSURLErrorNotConnectedToInternet, NSURLErrorRedirectToNonExistentLocation]
                    
                    if networkFailures.contains((error as NSError).code) {
                        completionHandler(.failure(.network))
                    } else {
                        completionHandler(.failure(.unknown))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionHandler(.failure(.unknown))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    completionHandler(.success(data))
                case 201, 204:
                    completionHandler(.success(nil))
                case 400...499:
                    completionHandler(.failure(.request(response: data)))
                case 500...599:
                    completionHandler(.failure(.server))
                default:
                    completionHandler(.failure(.unexpectedStatusCode))
                }
            })
        })
        activeTasks.insert(task)
        task.resume()
    }
    
    public func endpoint<T: APIRequest>(for request: T) -> URL {
        guard let baseUrl = URL(string: baseEndpoint.absoluteString + request.resourceName + "/") else {
            fatalError("Unable to create baseUrl: \(request.resourceName)")
        }
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true) ?? URLComponents()
        var passedQueryStringParameters = [URLQueryItem]()
        if let parameters = request.queryStringParameters {
            do {
                passedQueryStringParameters = try URLQueryItemEncoder.encode(parameters)
            } catch {
                fatalError("Error on encoding passedQueryStringParameters: \(error)")
            }
        }
        
        let queryItems = defaultQueryStringParameters + passedQueryStringParameters
        components.queryItems = queryItems.count > 0 ? queryItems : nil
        guard let url = components.url else {
            fatalError("Unable to create url from components: \(components)")
        }
        return url
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from response: APIResponse) -> DecodeResponse<T> {
        switch response {
        case .success(let data):
            guard let data = data else {
                return .failure(.noData)
            }
            do {
                let object = try decode(T.self, from: data)
                return .success(object)
            } catch let error as APIError {
                return .failure(error)
            } catch {
                fatalError("Unexpected error received")
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw APIError.decoding(reason: (error as NSError).debugDescription, data: data)
        }
    }
    
}
