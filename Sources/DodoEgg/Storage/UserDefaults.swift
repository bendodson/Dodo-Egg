// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

extension UserDefaults {
    
    public struct Key: RawRepresentable {
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        public var rawValue: String
    }
    
    public func encodeAndSet<T:Codable>(_ value: T, forKey key: Key) throws {
        do {
            let data = try JSONEncoder().encode(value)
            set(data, forKey: key)
        } catch {
            throw error
        }
    }
    
    public func set(_ value: Any?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    public func removeObject(forKey key: Key) {
        removeObject(forKey: key.rawValue)
    }
    
    public func decodedObject<T:Codable>(forKey key: Key) throws -> T? {
        guard let data = data(forKey: key) else { return nil }
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            return data
        } catch {
            throw error
        }
    }
    
    public func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    public func array(forKey key: Key) -> [Any]? {
        return array(forKey: key.rawValue)
    }

    public func dictionary(forKey key: Key) -> [String : Any]? {
        return dictionary(forKey: key.rawValue)
    }
    
    public func data(forKey key: Key) -> Data? {
        return data(forKey: key.rawValue)
    }

    public func stringArray(forKey key: Key) -> [String]? {
        return stringArray(forKey: key.rawValue)
    }

    public func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }

    public func float(forKey key: Key) -> Float {
        return float(forKey: key.rawValue)
    }

    public func double(forKey key: Key) -> Double {
        return double(forKey: key.rawValue)
    }

    public func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
}
