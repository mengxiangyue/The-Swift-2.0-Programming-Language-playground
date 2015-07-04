//:### 13-Inheritance 继承
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:一个类可以继承（inherit）另一个类的方法（methods），属性（properties）和其它特性。继承的类可以叫做子类，被继承的类可以叫做父类。    
//:在 Swift 中，类可以调用和访问超类的方法，属性和下标脚本（subscripts），并且可以重写（override）这些方法，属性和下标脚本来优化或修改它们的行为。Swift 会检查你的重写定义在超类中是否有匹配的定义，以此确保你的重写行为是正确的。     
//:可以为类中继承来的属性添加属性观察器（property observers），这样一来，当属性值改变时，类就会被通知到。可以为任何属性添加属性观察器，无论它原本被定义为存储型属性（stored property）还是计算型属性（computed property）。

//:**Defining a Base Class 定义一个基类** 一个没有继承自其他类得类叫做基类。Swift 中的类并不是从一个通用的基类继承而来。如果你不为你定义的类指定一个超类的话，这个类就自动成为基类。
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // do noting - an arbitrary vehicle doesn't necessarily make noise
    }
}
let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")

//:**Subclassing 子类** 子类可以继承父类的特性并且可以重新定义它，而且你还能给子类添加一些新特性。
class SomeSuperClass {}
class SomeSubclass: SomeSuperClass {
    // subclass definition goes here
}
// Example
class Bicycle: Vehicle {
    var hasBasket = false
}
let bicycle = Bicycle()
bicycle.hasBasket = true
// 访问父类的特性
bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")

// 子类能够被再继承
class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")

//:**Overriding 重写** 子类可以为继承来的实例方法（instance method），类方法（class method），实例属性（instance property），或下标脚本（subscript）提供自己定制的实现（implementation）,我们把这种行为叫重写（overriding）。     
//:重写需要使用override关键字，否则会编译错误。编译器会根据这个关键字检查父类是否有被重写的方法，保证正确。

//:**Accessing Superclass Method, Properties, and Subscripts 访问父类的方法，属性及下标脚本** 在子类重写父类的特性的时候，可能希望父类的实现作为子类实现的一部分，这时候可以使用super关键字访问父类的实现
// method super.someMethdod()
// property super.someProperty
// subscript super[someIndex]

//:**Overriding Methods 重写方法** 
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
let train = Train()
train.makeNoise()

//:**Overriding Properties 重写属性** 你可以重写继承来的实例属性或类属性，提供自己定制的getter和setter，或添加属性观察器使重写的属性可以观察属性值什么时候发生改变。

//:**Overriding Property Getters and Setters 重写属性的getter、setter**
class Car: Vehicle {
    var gear = 1
    override var description: String {
//        set { // 如果提供了set方法 必须提供get方法 在get中使用super.someProperty可以直接返回父类的实现
//        }
        get {
            return super.description + " in gear \(gear)"
        }
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")

//:**Overriding Property Observers 重写属性观察器** 不能重写继承来的常量、只读计算属性的观察器
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")

//:**Preventing Overrides 防止重写** 你可以通过把方法，属性或下标脚本标记为final来防止它们被重写，只需要在声明关键字前加上final特性即可。（例如：final var, final func, final class func, 以及 final subscript）  
//:如果你重写了final方法，属性或下标脚本，在编译时会报错。在类扩展中的方法，属性或下标脚本也可以在扩展的定义里标记为 final。   
//:你可以通过在关键字class前添加final特性（final class）来将整个类标记为 final 的，这样的类是不可被继承的，任何子类试图继承此类时，在编译时会报错






