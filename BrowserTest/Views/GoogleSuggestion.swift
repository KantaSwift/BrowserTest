//
//  GoogleSuggestion.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/08/20.
//

import UIKit
import Kanna

class GoogleSuggestion {
    
    private let apiURL = "https://www.google.com/complete/search?hl=en&output=toolbar&q="
    
    //サジェストを表示することに時間がかかる場合があるため,非同期処理を使う(非同期関数)
    func getSuggestions(searchText: String) async throws -> [String] {
        guard let percentEncoding = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: apiURL + percentEncoding) else {
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async {
                do {
                    let doc = try XML(url: url, encoding: .utf8)
                    let suggestions = doc.xpath("//suggestion").compactMap { $0["data"] }
                    continuation.resume(returning: suggestions)
                }
                catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
