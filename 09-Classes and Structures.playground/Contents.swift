//:### 09-Classes and Structures 类和结构体
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:类和结构体是人们构建代码所用的一种通用且灵活的代码块你可以使用和定义常量、变量和函数一样的语法，去给你的类定义属性和方法、增加类的功能。与Objective-C不同，声明和实现都在同一个文件中（也可以理解成没有声明文件），那些属性和方法能够被外部所见，也是在该文件内控制

//:**Comparing Classes and Structures 类和结构体比较**
// 相同点
// * 定义属性去存储值
// * 定义方法，提供功能
// * 定义角标，提供使用角标访问值
// * 定义初始化方法，初始化状态
// * 通过扩展以增加默认实现外的功能
// * 实现协议，提供标准的功能

// 类有而结构体没有的功能:
// * 继承允许一个类继承另一个类的特征
// * 类型转换允许在运行时检查和转换一个类实例的类型
// * 解构器允许一个类实例释放任何其所被分配的资源
// * 引用计数允许对一个类的多次引用

//:**Definition Syntax**
// 类名 结构体 名字 单词首字母大写 属性、方法 第一个单词的首字母小写，其余单词首字母大写
class SomeClass {
    // class definition goes here
}
struct SomeStructure {
    // structure definition goes here
}
// Example
struct Resolution { // 分辨率
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String? // 可选值 默认是nil
}

//:**Class and Structure Instances 类和结构体实例**
let someResolution = Resolution()
let someVideoMode = VideoMode()

//:**Accessing Properties 访问属性** 点语法
print("The width of someResolution is \(someResolution.width)")
//访问子属性 继续使用点语法
print("The width of someVideoMode is \(someVideoMode.resolution.width)")
// 使用点语法赋值
someVideoMode.resolution.width = 1280
print("The width of someVideoMode is \(someVideoMode.resolution.width)")

//:**Memberwise Initializers for Structure Types 结构体类型的成员逐一构造器** 所有结构体都有一个自动生成的成员逐一构造器，用于初始化新结构体实例中成员的属性。
let vga = Resolution(width: 6400, height: 480)

//**Structures and Enumerations Are Value Types 结构体和枚举是值类型** 值类型是一种在被赋值给变量或常量的时候或者做为参数传递给函数的时候，是值拷贝的一种类型。在 Swift 中，所有的基本类型：整数（Integer）、浮点数（floating-point）、布尔值（Booleans）、字符串（string)、数组（array）和字典（dictionaries），都是值类型，并且都是以结构体的形式在后台所实现。
// Example 值拷贝
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048
// hd cinema 是两个实例
print("cinema is no \(cinema.width) pixels wide")
print("hd is no \(hd.width) pixels wide")

enum CompassPoint {
    case North, South, East, West
}
var currentDirection = CompassPoint.West
let rememberedDirection = currentDirection
currentDirection = .East
if rememberedDirection == .West {
    print("The remembered direction is still .West")
}

//:**Class Are Reference Types 类是引用类型** 应用类型在赋值和做为参数传递的时候，是使用当前实例的一个引用。
// Example
// 下面用let声明的常量tenEighty，还是能够修改它的属性。因为这个常量不存储VideoMode的实例，只是引用其实例，只要指向该实例引用的存储不会改变（Swift中不提指针，但是这里类似指针的作用），这个常量的值就不算是改变。
let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0
// 两个变量引用了同一个实例
print("The frameRate property of tenEighty is now \(tenEighty.frameRate)")

//:**Identity Operators 恒等运算符** 判断两个变量或者常量是否引用的是同一个实例 === 恒等 !== 不恒等
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same VideoMode instance.")
}

// === 表示引用同一个实例 == 表示在值上相等

//:**Pointers 指针** 如果你有 C，C++ 或者 Objective-C 语言的经验，那么你也许会知道这些语言使用指针来引用内存中的地址。一个 Swift 常量或者变量引用一个引用类型的实例与 C 语言中的指针类似，不同的是并不直接指向内存中的某个地址，而且也不要求你使用星号（*）来表明你在创建一个引用。Swift 中这些引用与其它的常量或变量的定义方式相同。

//:**Choosing Between Classes and Structures 类和结构体的选择**
//按照通用的准则，当符合一条或多条以下条件时，请考虑构建结构体：
//
// * 结构体的主要目的是用来封装少量相关简单数据值。
// * 有理由预计一个结构体实例在赋值或传递时，封装的数据将会被拷贝而不是被引用。
// * 任何在结构体中储存的值类型属性，也将会被拷贝，而不是被引用。
// * 结构体不需要去继承另一个已存在类型的属性或者行为。
//
//合适的结构体例子包括：
//
//* 几何形状的大小，封装一个width属性和height属性，两者均为Double类型。
//* 一定范围内的路径，封装一个start属性和length属性，两者均为Int类型。
//* 三维坐标系内一点，封装x，y和z属性，三者均为Double类型。
//
//在所有其它案例中，定义一个类，生成一个它的实例，并通过引用来管理和传递。实际中，这意味着绝大部分的自定义数据构造都应该是类，而非结构体。

//:**Assignment and Copy Behavior for Strings, Arrays, and Dictionaries | String、Array、Dictionary的赋值和拷贝行为**
//Swift 中字符串（String）,数组（Array）和字典（Dictionary）类型均以结构体的形式实现。这意味着String，Array，Dictionary类型数据被赋值给新的常量(或变量），或者被传入函数（或方法）中时，它们的值会发生拷贝行为（值传递方式）。
//
//Objective-C中字符串（NSString）,数组（NSArray）和字典（NSDictionary）类型均以类的形式实现，这与Swfit中以值传递方式是不同的。NSString，NSArray，NSDictionary在发生赋值或者传入函数（或方法）时，不会发生值拷贝，而是传递已存在实例的引用。
//
//注意： 以上是对于数组，字典，字符串和其它值的拷贝的描述。 在你的代码中，拷贝好像是确实是在有拷贝行为的地方产生过。然而，在 Swift 的后台中，只有确有必要，实际（actual）拷贝才会被执行。Swift 管理所有的值拷贝以确保性能最优化的性能，所以你也没有必要去避免赋值以保证最优性能。（实际赋值由系统管理优化）



