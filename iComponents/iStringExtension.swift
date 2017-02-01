//
//  iStringExtension.swift
//  iComponents
//
//  Created by Rahul Panchal on 31/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation

protocol OptionalString {}
extension String: OptionalString {}

extension Optional where Wrapped: OptionalString {
    var isNilOrEmpty: Bool {
        return ((self as? String) ?? "").isEmpty
    }
}

extension String {
    /**
     * get number of characters in a string.
     */
    var length : Int {
        return self.characters.count
    }
    
    /**
     * reverse the string letters.
     */
    var reverse: String {
        return String(self.characters.reversed())
    }
    
    /** Returns a new string in which all occurrences of a target
     *  string in a specified range of the `String` are replaced by
     *  another given string.
     */
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    // This method localize the string and returns the translated string
    func localized(bundle: Bundle?) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: bundle != nil ? bundle! : Bundle.main, value: "", comment: "")
    }
    
    /**
     The html replacement regular expression
     */
    /**
     Takes the current NSString object and strips out HTML using regular expression. All tags get stripped out.
     
     :returns: NSString html text as plain text
     */
    func stripHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

