//
//  FilterDelegate.swift
//  Rentflix
//
//  Created by Guo Tian on 2/20/21.
//

import Foundation
import UIKit

protocol FilterDelegate: class {
    
    func applyNew(newRate: String, newPrice: String) -> Void
    
//    func applyRating(condition: String) -> Void
    
}
