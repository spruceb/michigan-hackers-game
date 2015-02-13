//
//  Vectors.swift
//  MichiganHackersOneTap
//
//  Created by Spruce Bondera on 2/11/15.
//  Copyright (c) 2015 Spruce Bondera. All rights reserved.
//

import SpriteKit

class Vector: Printable {
    let x: Double
    let y: Double
    init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    convenience init(_ point: CGPoint) {
        self.init(Double(point.x), Double(point.y))
    }
    convenience init(point: CGPoint) {
        self.init(point)
    }
    convenience init(vector: CGVector) {
        self.init(Double(vector.dx), Double(vector.dy))
    }
    
    var point: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
    }
    
    var vec: CGVector {
        get {
            return CGVector(dx: x, dy: y)
        }
    }
    
    var description: String {
        get {
            return "(\(x), \(y))"
        }
    }
    class var zero: Vector {
        return Vector(0,0)
    }
}

func +(left: Vector, right: Vector) -> Vector {
    return Vector(left.x + right.x, left.y + right.y)
}

func +=(inout left: Vector, right: Vector) {
    left = left + right
}

prefix func -(vec: Vector) -> Vector {
    return Vector(-vec.x, -vec.y)
}

func -(left: Vector, right: Vector) -> Vector {
    return left + (-right)
}

func -=(inout left: Vector, right: Vector) {
    left = left - right
}

func *(left: Vector, right: Double) -> Vector {
    return Vector(left.x * right, left.y * right)
}

func *(left: Double, right: Vector) -> Vector {
    return right * left
}

func *=(inout left: Vector, right: Double) {
    left = left * right
}

func /(left: Vector, right: Double) -> Vector {
    return left * (1/right)
}

func /(left: Double, right: Vector) -> Vector {
    return right / left
}

func /=(inout left: Vector, right: Double) {
    left = left / right
}

func ==(left: Vector, right: Vector) -> Bool {
    return (left.x == right.x) && (left.y == right.y)
}

func abs(vec: Vector) -> Double {
    return sqrt(pow(vec.x, 2) + pow(vec.y, 2))
}

func norm(vec: Vector) -> Vector {
    return vec / abs(vec)
}

func dot(first: Vector, second: Vector) -> Double {
    return first.x * second.x + first.y * second.y
}
