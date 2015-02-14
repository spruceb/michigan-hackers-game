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
    
    convenience init(cgx: CGFloat, cgy: CGFloat) {
        self.init(Double(cgx), Double(cgy))
    }
    
    convenience init(_ point: CGPoint) {
        self.init(cgx: point.x, cgy: point.y)
    }
    
    convenience init(point: CGPoint) {
        self.init(point)
    }
    
    convenience init(vector: CGVector) {
        self.init(cgx: vector.dx, cgy: vector.dy)
    }
    
    convenience init(size: CGSize) {
        self.init(cgx: size.width, cgy: size.height)
    }
    
    var point: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    var vec: CGVector {
        return CGVector(dx: x, dy: y)
    }
    
    var x_vec: Vector {
        return Vector(x, 0)
    }
    
    var y_vec: Vector {
        return Vector(0, y)
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

// Utility functions involving vectors:

func center_vector(rect: CGRect) -> Vector {
    return Vector(cgx: rect.width/2, cgy: rect.height/2)
}

func center_rect_at(rect: CGRect, vec: Vector) -> CGRect {
    let new_origin = vec - (Vector(size: rect.size)/2)
    return CGRect(origin: new_origin.point, size: rect.size)
}
