//
//  UIApplication.swift
//  Crypto
//
//  Created by Lokesh on 06/02/22.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
