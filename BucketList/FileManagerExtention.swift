//
//  FileManagerExtention.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-08.
//

import Foundation

extension FileManager {
    func decode<T: Codable>(_ file: String) -> T {
        let path = NSHomeDirectory().appending(file)
        guard let url = URL(string: path) else {
            fatalError("Failed to locate \(path)")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(path) from Home Directory")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle")
        }
        
        return decoded
    }
}
