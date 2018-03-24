
//: Playground - noun: a place where people can play

import SceneKit

/*
let node1 = SCNNode()

node1.transform = SCNMatrix4Identity
node1.position = SCNVector3(x: 0, y: 4, z: 4)
node1.scale = SCNVector3(8, 8, 8)
node1.rotation = SCNVector4(10, 1, 2, 3)


// Equality
//node1.simdPosition == simd_float3(1, 0, 0) // true
//node1.simdPosition == simd_float3(1, 0, 1) // false
//node1.simdTransform == simd_float4x4(SCNMatrix4Identity) // true

// Equality in an easier way
SCNVector4EqualToVector4(SCNVector4(1, 0, 0, 0), SCNVector4(1, 0, 0, 0)) // true
SCNVector3EqualToVector3( SCNVector3(1, 0, 0),  SCNVector3(3, 3, 3)) // false
SCNMatrix4EqualToMatrix4(SCNMatrix4Identity, SCNMatrix4Identity) // true

// Make Matrix4
let rotation = SCNMatrix4MakeRotation(10, 1, 2, 3) // angle, x, y, z
let scale = SCNMatrix4MakeScale(8, 8, 8) // x, y, z
let translation = SCNMatrix4MakeTranslation(0, 4, 4) // x, y, z

let rotationScale = SCNMatrix4Mult(rotation, scale)
let rotationScaleTranslation = SCNMatrix4Mult(rotationScale, translation)

SCNMatrix4EqualToMatrix4(node1.transform, rotationScaleTranslation) // false!!!!! Why doesn't this equal????
SCNMatrix4EqualToMatrix4(node1.transform, SCNMatrix4Identity) // false!!!

//Addtive
print(node1.transform)
print(rotationScaleTranslation)
*/


let node2 = SCNNode()


// Set position A
let vector3_A = SCNVector3(x: 1, y: 2, z: 3)
let vector4_A = SCNMatrix4MakeTranslation(1, 2, 3)
SCNMatrix4EqualToMatrix4(node2.transform, SCNMatrix4Identity) // true
node2.position = vector3_A
SCNMatrix4EqualToMatrix4(node2.transform, SCNMatrix4Identity) // false, obvs
SCNMatrix4EqualToMatrix4(node2.transform, vector4_A) // true

// Set position B
let vector3_B = SCNVector3(x: 4, y: 5, z: 6)
let vector4_B = SCNMatrix4MakeTranslation(4, 5, 6)
node2.position = vector3_B
SCNMatrix4EqualToMatrix4(node2.transform, vector4_B) // true


// Add postion A + position B
node2.localTranslate(by: vector3_A)
let vector4_AMuliplyB = SCNMatrix4Mult(vector4_A, vector4_B)
SCNMatrix4EqualToMatrix4(node2.transform, vector4_AMuliplyB) // true
// ^ Note, multiplying two translation matricies is the same as adding two position vector3s
//print(vector4_A)
//print(vector4_B)
//print(vector4_AMuliplyB)



let M1 = SCNMatrix4MakeScale(1, 2, 3)
let M2 = SCNMatrix4MakeRotation(Float.pi, 1, 1, 1)
let M3 = SCNMatrix4Mult(M1, M2)
print(M3)

//print(SCNMatrix4MakeScale(1, 2, 3))
//print(SCNMatrix4MakeRotation(Float.pi, 1, 1, 1))
//print(SCNMatrix4MakeTranslation(1, 2, 3))



let node3 = SCNNode()
let rotationMaxtrixA = SCNMatrix4MakeRotation(2, 4, 6, 8)
let rotationMaxtrixB = SCNMatrix4MakeRotation(1, 2, 3, 4)
let mutiplyRotationsAByB = SCNMatrix4Mult(rotationMaxtrixA, rotationMaxtrixB)

let addRotationMaxtrixAAndB = SCNMatrix4MakeRotation(3, 6, 9, 12)
let addRotationMaxtrixAAndB2 = SCNMatrix4MakeRotation(2, 8, 18, 32)

SCNMatrix4EqualToMatrix4(mutiplyRotationsAByB, addRotationMaxtrixAAndB) // FALSE! LOL life is not that simple
SCNMatrix4EqualToMatrix4(mutiplyRotationsAByB, addRotationMaxtrixAAndB2) // LOL also false


let node4 = SCNNode()
let M4 = SCNMatrix4MakeScale(1, 2, 3)
let M5 = SCNMatrix4MakeScale(1, 3, 4)
let M6 = SCNMatrix4MakeRotation(6, 8, 7, 10)
print("M6 \(M6)")

let scaleRotate = SCNMatrix4Mult(M5, M6)


//print(node4.transform)
print(node4.scale)
//node4.transform = M4
//print(node4.transform)
//print(node4.scale)
//node4.transform = M5
//print(node4.scale)
//print(node4.transform)

node4.transform = scaleRotate
print("TRANSFORM 1 \(node4.transform)")
print(node4.scale)
print(node4.rotation)

node4.rotation = SCNVector4(9, 0.1, 0.2, 0.3)
print("TRANSFORM 2 \(node4.transform)")
print(node4.scale)
print(node4.rotation)


//
let initialP = node4.position
let initialS = node4.scale
let initialR = node4.rotation

node4.transform

node4.transform = SCNMatrix4Rotate(node4.transform, 1, 1, 1, 1)

SCNVector3EqualToVector3(initialP, node4.position)
print(initialS)
print(node4.scale)
SCNVector3EqualToVector3(initialS, node4.scale)


//  T1, T2, T3
// T1 X T2 != T2 X T1
//  s1, p1 != p1, s1


var node5 = SCNNode()
let MTranslation = SCNMatrix4MakeTranslation(1, 2, 6)
let MScale = SCNMatrix4MakeScale(2, 2, 2)
let MRotation = SCNMatrix4MakeRotation(6, 8, 7, 10)
let MTranslation2 = SCNMatrix4MakeTranslation(2, 4, 12)


let r0 = SCNMatrix4Mult(MTranslation, MScale)
let r1 = SCNMatrix4Mult(r0, MRotation)
let r2 = SCNMatrix4Mult(r1, MTranslation2)

//let r0 = SCNMatrix4Mult(MScale, MRotation)
//let r1 = SCNMatrix4Mult(r0, MTranslation)
//let r2 = SCNMatrix4Mult(r1, MTranslation2)

node5.transform = r2

// Compare with the Matrix4 we set previously
print("\nTRANSFORM NODE 5 ***** ")
print("OLD postion 2 \(node5.position)") // NOT THE SAME
print("OLD scale 2 \(node5.scale)") // SAME
print("OLD rotation 2 \(node5.rotation)") // NOT THE SAME
print(node5.transform)
// Conclusions:
// The order of matrix multiplication matters

let node7 = SCNNode()
node7.position = node5.position
node7.scale = node5.scale
node7.rotation = node5.rotation

print("\nTRANSFORM NODE 7 ***** ")
print(node7.transform)
print("NEW postion 2 \(node7.position)") // NOT THE SAME
print("NEW scale 2 \(node7.scale)") // SAME
print("NEW rotation 2 \(node7.rotation)") // NOT THE SAME

// Looks like you can get back position/scale/rotation BACK from a SCNNode
// No matter which order you apply them to the node
extension SCNVector3: Equatable {
    static public func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension SCNVector4: Equatable {
    static public func == (lhs: SCNVector4, rhs: SCNVector4) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z && lhs.w == rhs.w
    }
}

print("\nIs node7's position equal to node5's: \(node5.position == node7.position)")
print("Is node7's rotation equal to node5's: \(node5.rotation == node7.rotation)")
print("Is node7's scale equal to node5's: \(node5.scale == node7.scale)")


// WEIRD EDGE CASE:
// HOWEVER, looks like the transform is calculated from the position/scale/rotation
// SO two nodes with the same position/scale/rotation have different matricies!!!!
// (but maybe they have the roughly the same location and it's just an rounding error, dunno yet)
// - you CANNOT get back the original rotation/position/scale from the matrix alone.
//          (You CAN get back the original rotation/position/scale from an SCNNode)
extension SCNMatrix4: Equatable {
    static public func == (lhs: SCNMatrix4, rhs: SCNMatrix4) -> Bool {
        let left = SCNNode()
        left.transform = lhs
        
        let right = SCNNode()
        right.transform = rhs
        
        print("\nposition \(left.position) \(right.position)")
        print("rotation \(left.rotation) \(right.rotation)")
        print("scale \(left.scale) \(right.scale)")
        return left.position == right.position &&
            left.rotation == right.rotation &&
            left.scale == right.scale
    }
}
print("\nIs node7's transform equal to node5's: \(SCNMatrix4EqualToMatrix4(node5.transform, node7.transform))") // FALSE

print("Is node7's transform equal to node5's: \(node5.transform == node7.transform)") // FALSE

node5.rotation = SCNVector4(0, 0, 0, 0)
print("new position \(node5.position)")
print("new scale \(node5.scale)")




var node6 = SCNNode()
node5.transform = SCNMatrix4MakeRotation(2, 3, 4, 5)
print(node5.rotation)


// TO TEST:
// Multiplying matricies by an rotation vector -- does scale change?






/**
 * Adds two SCNVector3 vectors and returns the result as a new SCNVector3.
 */
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

/**
 * Increments a SCNVector3 with the value of another.
 */
func += (left: inout SCNVector3, right: SCNVector3) {
    left = left + right
}



