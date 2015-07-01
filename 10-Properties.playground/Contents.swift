//:### 10-Properties 属性
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:属性将值与特定的类、结构体、枚举关联起来。存储属性能够存储常量和变量作为实例的一部分，而计算属性计算（而不存储）一个值。计算属性能存在于类、结构体、枚举中。而存储属性只能存储在类和结构体中。

//:**Stored Properties 存储属性**
struct FixedLengthRange {
    var firstValue: Int
    let length: Int // 创建后就不能修改
}

var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6
//rangeOfThreeItems.length = 22 //常量

//:**Stored Properties of Constant Structure Instances 常量结构体实例的存储属性** 如果生命一个结构体实例为常量，即使结构体的属性是变量，也不能修改。这个源于结构体是值类型，实例被声明为常量后，所有的属性也是常量了。这个不适用类，类是引用类型
let rangeOfFourItmes = FixedLengthRange(firstValue: 0, length: 4)
//rangeOfFourItmes.firstValue = 6 // error

//:**Lazy Store Properties 延迟存储属性** 延迟存储属性知道它第一次使用的时候才会被计算。
class DataImporter {
    /*
    DataImporter is a class to import data from an exteranl file.
    The class is assumed to take a non-trivial amount of time to initialize.
    */
    var fileName = "data.txt"
    // the DataImporter class would provide data
}

class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
    // the DataManager class would provide data management functionality here
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")

//:**Stroed Properties and Instance Variables 存储属性和实例变量** 下面的一段文字 还是有点不理解 所以直接贴出来
// 下面文字个人理解是Objective-C提供了 存储和引用作为类实例一部分 对应的可能就是assign strong声明的属性。Swift统一成立一种声明 如果错了还请指出
//If you have experience with Objective-C, you may know that it provides two ways to store values and references as part of a class instance. In addition to properties, you can use instance variables as a backing store for the values stored in a property.
//Swift unifies these concepts into a single property declaration. A Swift property does not have a corresponding instance variable, and the backing store for a property is not accessed directly. This approach avoids confusion about how the value is accessed in different contexts and simplifies the property’s declaration into a single, definitive statement. All information about the property—including its name, type, and memory management characteristics—is defined in a single location as part of the type’s definition.

//:**Computed Properties 计算属性** 不存储值 返回、设置一个处理的值
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at(\(square.origin.x), \(square.origin.y))")
var image = UIImage(named: "computedProperties")

//:**Shorthand Setter Declaration 简洁setter声明** 如果计算属性的set没有定义一个名字，将会有一个默认的newValue名字
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

//:**Read-Only Computed Properties 只读计算属性** 只有get，没有set的计算属性是只读的 当然也可以省略get关键字
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
    
    var anotherVolume: Double {
        get {
            return width * height * depth
        }
    }
}

//:**Property Observers 属性观察器** 属性观察器观察和响应值的变化。属性观察器将会在属性每次被设置的时候调用，即使新值和原来的值相等也会调用。能在所有的存储属性除了延迟加载的属性上添加属性观察器。 属性观察器是不会在初始化方法中调用
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) { // 可以使用默认的名字 newValue
            print("About to set totalSteps to \(newTotalSteps)")
        }
        
        didSet { // 可以自己定义一个原先值的名字 也可以使用默认的 oldValue
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
stepCounter.totalSteps = 360
stepCounter.totalSteps = 896

//:**Global and Local Variables 全局变量和本地变量** 计算属性和属性观察器所描述的模式也可以用于全局变量和局部变量，全局变量是在函数、方法、闭包或任何类型之外定义的变量，局部变量是在函数、方法或闭包内部定义的变量。

//:**Type Properties 类型属性** 实例的属性属于一个特定类型实例，每次类型实例化后都拥有自己的一套属性值，实例之间的属性相互独立。也可以为类型本身定义属性，不管类型有多少个实例，这些属性都只有唯一一份。这种属性就是类型属性。对于值类型（指结构体和枚举）可以定义存储型和计算型类型属性，对于类（class）则只能定义计算型类型属性。值类型的存储型类型属性可以是变量或常量，计算型类型属性跟实例的计算属性一样定义成变量属性。

// 语法
struct SomeStructure {
    static var storedTypeProperty = "Some value"
    static var computedTypeProperty: Int {
        return 1
    }
}

enum SommeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}

class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

//:**Querying and Setting Type Properties 获取和设置类型属性的值** 使用点语法，要求在类型上使用点语法 而不是实例上
print(SomeStructure.storedTypeProperty)
SomeStructure.storedTypeProperty = "Another value"
print(SomeStructure.storedTypeProperty)
print(SommeEnumeration.computedTypeProperty)
print(SomeClass.computedTypeProperty)

//例子
image = UIImage(named: "staticPropertiesVUMeter")
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // cap the new audio level th the threshold level 
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // store this as the new overall maximum input value
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

leftChannel.currentLevel = 7
print(leftChannel.currentLevel)
print(AudioChannel.maxInputLevelForAllChannels)

rightChannel.currentLevel = 11
print(rightChannel.currentLevel)
print(AudioChannel.maxInputLevelForAllChannels)
