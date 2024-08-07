//
//  Roll.swift
//  RollDice
//
//  Created by Nicholas Johnson on 8/6/24.
//

import Foundation
import SwiftData

@Model
class Roll {
    var id: UUID
    var result: Int
    
    init(id: UUID = UUID(), result: Int) {
        self.id = id
        self.result = result
    }
}
