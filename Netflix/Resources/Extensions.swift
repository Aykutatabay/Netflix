//
//  Extensions.swift
//  Netflix
//
//  Created by Aykut ATABAY on 31.01.2023.
//

import Foundation


extension String {
    func capitalizedFirstLatter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
