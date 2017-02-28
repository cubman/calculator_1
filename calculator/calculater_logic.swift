//
//  calculater_logic.swift
//  calculator
//
//  Created by student on 28.02.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation

class Calculator {
    private var d : Double = 0
    public var result : Double {get {return self.d} set {  self.d = newValue }}
    
    
    static func+(_ cal:Calculator, _ c: Double) -> Calculator {
        cal.result += c
        return cal
    }
    
    static func-(_ cal:Calculator, _ c: Double) -> Calculator {
        cal.result -= c
        return cal
    }
    
    static func*(_ cal:Calculator, _ c: Double) -> Calculator {
        cal.result *= c
        return cal
    }
    
    static func/(_ cal:Calculator, _ c: Double) -> Calculator {
        cal.result /= c
        return cal
    }
    
    static func/=( _ cal:inout Calculator, _ c: Double) {
        cal = cal / c
    }
    
    static func*=(_ cal:inout Calculator, _ c: Double) {
        cal = cal * c
    }
    
    static func-=(_ cal:inout Calculator, _ c: Double) {
        cal = cal - c
    }
    
    static func+=(_ cal:inout Calculator, _ c: Double) {
        cal = cal + c
    }
}
