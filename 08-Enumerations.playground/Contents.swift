//:### 08-Enumerations 枚举
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:枚举定义了一个通用类型的一组相关的值，使你可以在你的代码中以一个安全的方式来使用这些值。在 Swift 中，枚举类型是一等（first-class）类型。枚举中有许多原来只有类才有的特性，例如计算属性、实例方法、初始化方法、实现协议等

//:**Enumeration Syntax 枚举语法**
enum SomeEnumeration {
    // enumeration definition goes here
}

// Example 不像 C 和 Objective-C 一样，Swift 的枚举成员在被创建时不会被赋予一个默认的整数值。在下面的CompassPoints例子中，North，South，East和West不是隐式的等于0，1，2和3
// 定义的枚举就是一种新的类型 一般使用单数形式 便于使用
enum CompassPoint {
    case North
    case South
    case East
    case West
}

// 多个成员 可以写在一行 使用逗号分隔
enum Planet {
    case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

var directionToHead = CompassPoint.West // 能够根据值推断变量的类型 所以不用写枚举类型
// 枚举类型已经确定后，可以使用点语法去设置另一个值，省略枚举类型。不省略的话，代码更具可读性
directionToHead = .East

//:**Matching Enumeration Values with a Swith Statement 在Switch语句中匹配枚举值**
directionToHead = .South
switch directionToHead {
case .North:
    print("Lots of planets have a north")
case .South:
    print("Watch out for penguins")
case .East:
    print("Where the sun rises")
case .West:
    print("Where the skies are blue")
}
// switch要求case是完全的，对于上面如果删除掉任何一个case都会报错。如果我们只是关心某一个枚举值，可以使用default
let somePlanet = Planet.Earth
switch somePlanet {
case .Earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}

//:**Associated Values 相关值** 可以定义 Swift 的枚举存储任何类型的相关值，如果需要的话，每个成员的数据类型可以是各不相同的。
// 条码 和 二维码 下面定义了与其关联的值
enum Barcode {
    case UPCA(Int, Int, Int, Int)
    case QRCode(String)
}
var productBarcode = Barcode.UPCA(8, 85909, 52116, 3)
// 赋值为另一只条形码类型
productBarcode = .QRCode("ABCDEFGHIJKLMNOP")
//Switch语句 这里的相关值 能够被获得、使用
switch productBarcode {
case .UPCA(let numberSystem, let manufacturer, let product, let check):
    print("UPC-A \(numberSystem), \(manufacturer), \(product), \(check)")
case .QRCode(let productCode):
    print("QR code: \(productCode)")
}
// 如果关联值 都是 let或者var声明 可以放到外面统一声明
switch productBarcode {
case let .UPCA(numberSystem, manufacturer, product, check):
    print("UPC-A \(numberSystem), \(manufacturer), \(product), \(check)")
case var .QRCode(productCode):
    print("QR code: \(productCode)")
}

//:**Raw Values 原始值** 在Associated Values小节的条形码例子中演示了一个枚举的成员如何声明它们存储不同类型的相关值。作为相关值的替代，枚举成员可以被默认值（称为原始值）预先填充，其中这些原始值具有相同的类型。
// 原始值在枚举定义的时候就确定了。原始值可以使用String、character、任意整型、浮点型类型。每个原始值在它的枚举声明中必须是唯一的。当整型值被用于原始值，如果其他枚举成员没有值时，它们会自动递增。
enum ASCIIControlCharacter: Character {
    case Tab = "\t"
    case LineFeed = "\n"
    case CarriageReturn = "\r"
}

enum AnotherPlanet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
}

let earthsOrder = AnotherPlanet.Earth.rawValue

//:**Initializing from a Raw Value 从原始值初始化枚举成员** 如果定义了一个有原始值类型的枚举，可以使用原始值初始化一个枚举成员，结果可能返回对应的成员，可能是nil。
let possiblePlanet = AnotherPlanet(rawValue: 7) // 并不是所有的int类型数值都能返回一个对应的枚举成员，所以possiblePlant的类型是Planet?
let positionToFind = 9
if let somePlanet = AnotherPlanet(rawValue: positionToFind) {
    switch somePlanet {
    case .Earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}








