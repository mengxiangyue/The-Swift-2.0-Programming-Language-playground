//:### 21-Extensions 扩展
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:展就是向一个已有的类、结构体或枚举类型添加新功能（functionality）。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即逆向建模）。扩展和 Objective-C 中的分类（categories）类似。Swift中协议也支持扩展
//:在Swift中扩展能够：    
//:* 添加计算型属性和计算静态属性
//:* 定义实例方法和类型方法
//:* 提供新的构造器
//:* 定义下标
//:* 定义和使用新的嵌套类型
//:* 使一个已有类型符合某个协议

//:**Extension Syntax 扩展语法**
//extension SomeType {
//    // new functionality to add to SomeType goes here
//}
// 扩展能够使现有的类符合一个或者多个协议
//extension SomeType {
//    // new functionality to add to SomeType goes here
//}

//:**Computed Properties 计算属性**     
//:扩展可以向已有类型添加计算型实例属性和计算型类型属性。
//扩展Double类型
extension Double { // 都是只读属性
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
// prints "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")

let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")

//:**Initializers 构造器**    
//:扩展可以向已有类型添加新的构造器。扩展能向类中添加新的便利构造器，但是它们不能向类中添加新的指定构造器或析构函数。
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}
let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
    size: Size(width: 5.0, height: 5.0))

// 扩展Rect
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
    size: Size(width: 3.0, height: 3.0))

//:**Methods 方法**     
//扩展可以向已有类型添加新的实例方法和类型方法。
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions({
    print("Hello!")
})
// 尾随闭包写法
3.repetitions {
    print("Goodbye!")
}

//:**Mutating Instance Methods 修改(突变)实例方法**     
//:通过扩展添加的实例方法也可以修改该实例本身。结构体和枚举类型中修改self或其属性的方法必须将该实例方法标注为mutating，正如来自原始实现的修改方法一样。
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()

//:**Subscripts 下标脚本**
// 扩展Int 返回下标脚本位置（从右到左）的数字
extension Int {
    subscript(var digitIndex: Int) -> Int {
        var decimalBase = 1
        while digitIndex > 0 {
            decimalBase *= 10
            --digitIndex
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
746381295[1]
746381295[2]
746381295[8]

//:**Nested Types 嵌套类型**
extension Int {
    enum Kind { // 正数、零、负数
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}

func printIntegerKinds(numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("- ", appendNewline: false)
        case .Zero:
            print("0 ", appendNewline: false)
        case .Positive:
            print("+ ", appendNewline: false)
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])



