//
//  Result.swift
//  BucketList
//
//  Created by ramsayleung on 2024-03-11.
//

import Foundation


struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
}

struct Query: Codable {
    // <pageId: WikiPage>
    let pages: [Int: Page]
}

struct Result: Codable {
    let query: Query
}
