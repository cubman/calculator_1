//
//  exceptions.swift
//  calculator
//
//  Created by student on 02.03.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation

enum MyErrors : Error {
    case divideByZero(String)
    case tooLongNumb(String)
}
