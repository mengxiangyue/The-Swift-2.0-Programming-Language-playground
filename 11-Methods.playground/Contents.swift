//:### 11-Methods 方法
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:方法是与某些特定类型相关联的函数。类、结构体、枚举都可以定义实例方法、类型方法。类型方法类似Objective-C中的类方法。不同的是Swift中结构体和枚举也能定义方法。

//:**Instance Methods 实例方法** 实例方法是属于特定类、结构体、枚举的实例的函数。实例方法的语法与函数相同。实例方法只能通过实例调用，不能通过类调用（后面会介绍类方法能够通过类调用）
class Counter {
    var count = 0
    func increment() {
        ++count
    }
    
    func incrementBy(amount: Int) {
        count += amount
    }
    
    func reset() {
        count = 0
    }
}

let counter = Counter()
counter.increment()
counter.incrementBy(5)
counter.reset()

//:**Local and External Parameter Names for Methods 方法的局部参数名称和外部参数名称** 这个与函数相同（方法只是关联到某种类型上的函数）
// 更具复杂的incrementBy方法 方法重载 扩展以后会介绍 （这里与书中不一致，只关注方法就好）
extension Counter {
    func incrementBy(amount: Int, numberOfTimes: Int) {
        count += amount * numberOfTimes
    }
}

counter.incrementBy(5, numberOfTimes: 3) // 默认第一个没有外部参数名称 第二个有外部参数名称 主要为了保持与Objective-C语法的一致

//:**Modifying External Parameter Name Behavior for Methods 修改方法的外部参数名称** 第一个参数前加入外部参数名 #在XCode7A1211中被移除了 可以添加第一个参数 除第一个参数 使用下划线 可以取消外部参数名称
extension Counter {
    func test1(param1 param1: Int, _ param2: Int) {}
}
counter.test1(param1: 1, 3)

//:**The self Property self属性** 类型的每一个实例都有一个隐含属性叫做self，self完全等同于该实例本身。你可以在一个实例的实例方法中使用这个隐含的self属性来引用当前实例。
// 在上面方法
//func increment() {
//    ++count
//}
// 其实等同于++self.count, 我们没有明确的使用self，Swift就认为我们引用的是self的属性。一般不需要使用self属性，但是在实例变量名和方法参数名相同的时候需要使用self区分。
struct Point {
    var x = 0.0, y = 0.0
    func isToTheRightOfX(x: Double) -> Bool {
        return self.x > x
    }
}

let somePoint = Point(x: 4.0, y: 5.0)
if somePoint.isToTheRightOfX(1.0) {
    print("This point is to the right of the line where x == 1.0")
}

//:**Modifying Value Types from Within Instance 在实例方法中修改值类型** 结构体和枚举是值类型，值类型默认在实例方法中是不能修改属性的。但是可以使用mutate，修改值类型的属性，在mutate方法中也可以使用一个新的实例替换现在的实例
struct AnotherPoint {
    var x = 0.0, y = 0.0
//    func change() { x += 10} // error
    // mutating 只有该关键字修饰的方法 才能修改属性值
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

var anotherPoint = AnotherPoint(x: 1.0, y: 1.0)
anotherPoint.moveByX(2.0, y: 3.0)
print("The point now at (\(anotherPoint.x), \(anotherPoint.y))")
// 但是常量 不能调用mutate方法修改属性
let fixedPoint = AnotherPoint(x: 3.0, y: 3.0)
//fixedPoint.moveByX(2.0, y: 3.0) // error

//:**Assigning to self Within a Mutating Method 在变异方法中给self赋值** 在mutate方法中也可以使用一个新的实例替换现在的实例
struct ThirdPoint {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        self = ThirdPoint(x: x + deltaX, y: y + deltaY)
    }
}
// 同样也可以使用在枚举上
enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = Low
        case .Low:
            self = High
        case .High:
            self = Off
        }
    }
}

var ovenLight = TriStateSwitch.Low
ovenLight.next()
ovenLight.next()

//:**Type Methods 类型方法** 使用类型调用的方法 使用static（类也可以使用class）关键字定义 在Swifit中可以在类枚举结构体中定义类型方法 可以使用点语法访问 在类型方法中self表示该类型，不是该类型得实例。在类型方法中能够调用其他的类型方法，但是不能调用实例方法
class SomeClass {
    class func someTypeMethod() {
        // type method implementation goes here
    }
    static func anotherTypeMethod() {
        // type method implementation goes here
    }
}

// Example
struct LevelTracker {
    static var highestUnlockedLevel = 1
    static func unlockLevel(level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    
    static func levelIsUnlocked(level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    var currentLevel = 1
    mutating func advanceToLevel(level: Int) -> Bool {
        if LevelTracker.levelIsUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func completedLevel(level: Int) {
        LevelTracker.unlockLevel(level + 1)
        tracker.advanceToLevel(level + 1)
    }
    init(name: String) {
        playerName = name
    }
}

var player = Player(name: "Argyrios")
player.completedLevel(1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")

player = Player(name: "Beto")
if player.tracker.advanceToLevel(6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}


