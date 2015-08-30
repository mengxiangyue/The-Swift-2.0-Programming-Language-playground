//:### 01-The Basic
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出

import UIKit

//:Swift提供了基本的C、Objective-C的类型，并且还提供了更加强大的Array、Set、Dictionary。另外还有Objective-C中没有的类型，例如Tuple。Optionals

//:常量和变量（Constants and Variables）
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0
// 同时声明多个变量
var x = 0.0, y = 2, z = 1.0

// 类型声明 :空格
var welcomeMessage: String
welcomeMessage = "Hello"
var red, green, blue: Double

// 变量名可以是任意字符 包括Unicode字符，不能包括空格、数学符号、箭头、保留的（或者非法的）Unicode 码位，连线与制表符。也不能以数字开头，但是可以在常量与变量名的其他地方包含数字。
let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"
// 保留字
let `if` = "如果"

// 打印 print
print(welcomeMessage)
print(welcomeMessage, terminator: "\n")

print("this is a test")
// 字符串插值
print("\(welcomeMessage) xiaoming")

//:注释
// this is a comment
/* this is a comment
but written over multiple lines */
// 多行注释嵌套
/* aaa
/* bbb  */
----aaa */

//: 分号 与其他大部分编程语言不同，Swift 并不强制要求你在每条语句的结尾处使用分号（;），当然，你也可以按照你自己的习惯添加分号。有一种情况下必须要用分号，即你打算在同一行内写多条独立的语句
let cat = "🐱"; print(cat)

//: 整数 提供了8，16，32和64位的有符号和无符号整数类型 Int8 UInt8，另外提供了一Int类型，32位平台=Int32，64位平台=Int64
let minValue = UInt8.min  // minValue 为 0，是 UInt8 类型的最小值
let maxValue = UInt8.max  // maxValue 为 255，是 UInt8 类型的最大值

// 浮点数 Double表示64位浮点数，Float表示32位浮点数 自动推断为Double
let float = 222.3
float is Double
float is Float

//: 类型安全和类型推断 编译阶段发现类型错误
let anotherPi = 3 + 0.14159

//: 数值型字面量
let decimalInteger = 17
let binaryInteger = 0b10001       // 二进制的17
let octalInteger = 0o21           // 八进制的17
let hexadecimalInteger = 0x11     // 十六进制的17

// 1.25e2 表示 1.25 × 10^2，等于 125.0
1.25e2
// 1.25e-2 表示 1.25 × 10^-2，等于 0.0125
1.25e-2

// 可读性增强  只能是下划线
let paddedDouble = 000123.456
let oneMillion = 1_000_000
let justOverOneMillion = 1_000_000.000_000_1

//:数值型类型转换 超出范围编译阶段就能检测到
//let cannotBeNegative: UInt8 = -1
// UInt8 类型不能存储负数，所以会报错
//let tooBig: Int8 = Int8.max + 1
// Int8 类型不能存储超过最大值的数，所以会报错

// 不同类型得数值，不能直接相加，必须使用构造方法转换
let twoThousand: UInt16 = 2_000
let one: UInt8 = 1
let twoThousandAndOne = twoThousand + UInt16(one)

let integerPi = Int(anotherPi)

//:类型别名
typealias AudioSample = UInt16
var maxAmplitudeFound = AudioSample.min

//:布尔值 Bool true false not YES NO
//if 1 {} // error

//:Tuples 元组 把多个值组合成一个复合值。元组内的值可以是任意类型，并不要求是相同类型。
let http404Error = (404, "Not Found")
// http404Error 的类型是 (Int, String)，值是 (404, "Not Found")
// 获取元组的值
let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// 输出 "The status code is 404"
print("The status message is \(statusMessage)")
// 输出 "The status message is Not Found"

let (justTheStatusCode, _) = http404Error
print("The status code is \(justTheStatusCode)")

// 使用索引
print("The status code is \(http404Error.0)")
// 输出 "The status code is 404"
print("The status message is \(http404Error.1)")
// 输出 "The status message is Not Found"

// 在定义元组的时候给单个元素命名
let http200Status = (statusCode: 200, description: "OK")
print("The status code is \(http200Status.statusCode)")
// 输出 "The status code is 200"
print("The status message is \(http200Status.description)")
// 输出 "The status message is OK"

// 作为一个多参数的返回值 元组十分合适

//:可选类型
let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
// convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int"

// 通过赋值nil，设置一个变量为没值的状态
var serverResponseCode: Int? = 404
serverResponseCode = nil

var surveyAnswer: String?
// 没有提供初始值的optional variable，默认设置为nil
// nil 在swift、Objective-C不同。在Objective-C中，nil是一个指向不存在的对象的指针，在Swift中，nil指向一个缺失的值

//:if 语句以及强制解析
if convertedNumber != nil {
    print("convertedNumber contains some integer value")
    // 确定有值 使用! 强制解析使用
    print("\(possibleNumber) has an integer value of \(convertedNumber!)")
}
// 输出 "123 has an integer value of 123"

//:可选绑定（optional binding）
// let var
if let actualNumber = Int(possibleNumber) {
    print("\'\(possibleNumber)' has an integer value \(actualNumber)")
}

var a1:Int?, b1:Int?
if let a = a1, b = b1 {} // if中可以写入多个可选绑定

//:隐式解析可选类型
let possibleString: String? = "An optional string."
print(possibleString!) // 需要惊叹号来获取值
// 输出 "An optional string."
let assumedString: String! = "An implicitly unwrapped optional string."
print(assumedString)  // 不需要感叹号
// 输出 "An implicitly unwrapped optional string."

//:错误处理
func canThrowanError() throws {
}


enum MyError: ErrorType {
    case error1
    case error2(description: String)
}
do {
    try canThrowanError()
} catch MyError.error1 {
    // an error was thrown
} catch MyError.error2(let description) {

}

//: 断言
let age = -3
assert(age >= 0, "A person's age cannot be less than zero")
