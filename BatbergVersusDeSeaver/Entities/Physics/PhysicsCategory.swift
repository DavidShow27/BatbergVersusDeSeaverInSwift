//
//  PhysicsCategory.swift
//  BatbergVersusDeSeaver
//
//  Created by JACKSON GERAMBIA on 4/29/26.
//


struct PhysicsCategory {
    static let none:    UInt32 = 0
    static let player:  UInt32 = 0b001  // 1
    static let enemy:   UInt32 = 0b010  // 2
    static let floor:   UInt32 = 0b100  // 4
}