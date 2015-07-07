//:### 24-Access Control 访问控制
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:访问控制可以限定其他源文件或模块中代码对你代码的访问级别。这个特性可以让我们隐藏功能实现的一些细节，并且能够指定哪些代码能够被访问和使用。      
//:Swift代码如果不明确写出访问级别，默认是同一个模块内可访问。

//:**Modules and Source Files 模块和源文件**      
//:模块指的是以独立单元构建和发布的Framework或Application。在Swift 中的一个模块可以使用import关键字引入另外一个模块。     
//:Swift中每个Target被当做一个模块。   
//:源文件是模块内的代码文件。

//:**Access Levels 访问控制**     
//:Swift提供三种访问控制：    
//:* Public 所有的地方都能访问到     
//:* Internal 模块内能访问
//:* Private 只能在定义它的源文件中访问

//:**Guiding Principle of Access Levels 访问级别的使用原则**    
//:No entity can be defined in terms of another entity that has a lower (more restrictive) access level   
//: 这句话不太好翻译，我的理解是，一个实体定义的时候，不能依据一个比它访问级别低的实体去定义
//: Example
//:一个public访问级别的变量，不能将变量的类型定义为internal和private。
//:函数的访问级别不能高于它的参数、返回类型的访问级别。

//:**Default Access Levels 默认访问级别**     
//:在Swift中如果没有明确访问级别，将会被设置成默认的访问级别，internal

//:**Access Levels for Single-Target Apps 只有一个Target的App的访问几倍**    
//:由于单Target只会在App内部访问，只要internal级别就可以了，所以不需要声明访问级别，默认就好了，如果想要隐藏某些实现，可以使用private

//:**Access Levels for Frameworks Framework的访问级别**    
//:在Framework中，只有明确的标明public的接口，才能被其他模块访问

//:**Access Levels for Unit Test Targets -> Unit Test Target的访问级别**    
//:默认情况下，Test Target只能访问使用public标明的实体。但是如果我们可以在import的时候，添加@testable，使测试类能够访问到模块中internal声明的实体     
//@testable
//import 模块名

//:**Access Control Syntax 访问控制语法**     
//public class SomePublicClass {}
//internal class SomeInternalClass {}
//private class SomePrivateClass {}
//
//public var somePublicVariable = 0
//internal let someInternalConstant = 0
//private func somePrivateFunction() {}

//:**Custom Types 自定义类型**    
//:可以在定义类型的时候定义访问级别。自定义类型的访问级别，将会影响其成员（包括属性，方法、构造器、下表脚本）的访问级别。成员的访问级别不能高于类型。
public class SomePublicClass {          // explicitly public class
    public var somePublicProperty = 0    // explicitly public class member
    var someInternalProperty = 0         // implicitly internal class member
    private func somePrivateMethod() {}  // explicitly private class member
}

class SomeInternalClass {               // implicitly internal class
    var someInternalProperty = 0         // implicitly internal class member
    private func somePrivateMethod() {}  // explicitly private class member
}

private class SomePrivateClass {        // explicitly private class
    var somePrivateProperty = 0          // implicitly private class member
    func somePrivateMethod() {}          // implicitly private class member
}

//:**Tuple Types 元组类型**    
//:按照元组中元素的访问级别最低的当做自己的访问级别。

//:**Function Types 函数**    
//:受参数类型、返回类型访问级别的影响。选择函数声明访问级别、参数类型访问级别、返回类型访问级别最低的作为函数的访问级别。如果最后确定函数的访问级别是private，需要明确声明，不会自动计算出来，
class AB {
    private class B {}
    private func test(a:B) { // 必须明确声明为private
        print("x")
    }
}

//:**Enumeration Types 枚举类型**    
//:枚举类型的case的访问级别与枚举类型的访问级别相同。    
//:枚举的原始值和关联值的访问级别必须要高于枚举的访问级别。
public enum CompassPoint {
    case North
    case South
    case East
    case West
}
// CompassPoint->public So case->public

//:**Nested Types 嵌套类型**   
//:如果在private级别的类型中定义嵌套类型，那么该嵌套类型就自动拥有private访问级别。如果在public或者internal级别的类型中定义嵌套类型，那么该嵌套类型自动拥有internal访问级别。如果想让嵌套类型拥有public访问级别，那么需要明确地申明该嵌套类型的访问级别

//:**Subclassing 子类**    
//:子类的访问级别不能高于父类。子类能够重写父类能够被子类访问的方法。同时子类还能够通过重写父类private的方法。通过重写能够修改父类private方法在子类中的访问级别，如下
public class A {
    private func someMethod() {
        print("AAAAAA")
    }
}

internal class B: A {
    override internal func someMethod() {
        super.someMethod()
        print("BBBBBBB")
    }
}

let bbb = B()
bbb.someMethod()


//:**Constants, Variables, Properties, and Subscripts 常量、变量、属性、下标**   
//:声明的常量、变量、属性、下标的访问级别，不能高于其类型的访问级别。
private var privateInstance = SomePrivateClass()

//:**Getters and Setters Getter和Setter**  
//:常量、变量、属性、下标索引的Getters和Setters的访问级别继承自它们所属成员的访问级别。   
//:通过private(set)或internal(set)先为它们的写权限申明一个较低的访问级别。
struct TrackedString {
    private(set) var numberOfEdits = 0 // 只能在源文件中设置 在模块中只读
    var value: String = "" {
        didSet {
            numberOfEdits++
        }
    }
}

var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")

public struct AnotherTrackedString {
    public private(set) var numberOfEdits = 0 // getter public setter是private
    public var value: String = "" {
        didSet {
            numberOfEdits++
        }
    }
    public init() {}
}

//:**Initializers 构造器**    
//:自定义构造器可以指定一个比类型访问级别低的访问级别。但是指定构造器必须和类型的访问级别相同。构造器的参数类型的访问级别不能比构造器的低。

//:**Default Initializers 默认构造器**    
//:类型非public的时候，默认构造器与类型的访问级别一致。如果是类型是public，默认构造器是internal。如果想使其是public的可以提供一个无参的public的构造器。

//:**Default Memberwise Initializers for Structure Types 结构体的默认成员初始化方法**     
//:如果结构体中的任一存储属性的访问级别为private，那么它的默认成员初始化方法访问级别就是private。否则，结构体的初始化方法的访问级别依然是internal。
//:如果你想在其他模块中使用该结构体的默认成员初始化方法，那么你需要提供一个访问级别为public的默认成员初始化方法。

