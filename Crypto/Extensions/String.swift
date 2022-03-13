//
//  String.swift
//  Crypto
//
//  Created by Lokesh on 11/03/22.
//

import Foundation
extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
