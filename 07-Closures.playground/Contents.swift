//:### 07-Closures 闭包
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出

import UIKit

//:闭包是自包含的函数代码块，可以在代码中被传递和使用。 Swift 中的闭包与 C 和 Objective-C 中的代码块（blocks）以及其他一些编程语言中的 lambdas 函数比较相似。
//:闭包可以捕获和存储其所在上下文中任意常量和变量的引用。 这就是所谓的闭合并包裹着这些常量和变量，俗称闭包。Swift 会为您管理在捕获过程中涉及到的所有内存操作。

// 全局和嵌套函数是一种特殊的闭包。闭包采取如下三种形式之一：
// * 全局函数是一个有名字但不会捕获任何值的闭包
// * 嵌套函数是一个有名字并可以捕获其封闭函数域内值的闭包
// * 闭包表达式是一个利用轻量级语法所写的可以捕获其上下文中变量或常量值的匿名闭包

//Swift 的闭包表达式拥有简洁的风格，并鼓励在常见场景中进行语法优化，主要优化如下：
// * 利用上下文推断参数和返回值类型
// * 隐式返回单表达式闭包，即单表达式闭包可以省略return关键字
// * 参数名称缩写
// * 尾随（Trailing）闭包语法

//:**Closure Expressions 闭包表达式**
// 嵌套函数 是一个在较复杂函数中方便进行命名和定义自包含代码模块的方式。当然，有时候撰写小巧的没有完整定义和命名的类函数结构也是很有用处的，尤其是在您处理一些函数并需要将另外一些函数作为该函数的参数时。

//:**The Sort Function** sort函数会返回一个已经排序好的数组，并且原数组保持不变 下面都是基于这个函数演示在SWift中闭包表达式是如何一步一步的被优化的
// sort(_:)方法要求两个参数，1 一个已知类型的数组 2 一个比较两个数组元素的闭包，并且返回类型是Bool
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
// 使用函数
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
var reversed = names.sort(backwards)

//:**Closure Expression Syntax 闭包表达式语法** 能够使用常量、变量、inout参数，但是不能参数不能提供默认值。在参数末尾也可以使用可变参数，元组也可以作为参数或者返回值
var image = UIImage(named: "ClosureExpressionSyntax")
reversed = names.sort({ (s1: String, s2: String) -> Bool in
    return s1 > s2
})

//:**Inferring Type From Context 根据上下文推断类型** 因为排序闭包函数是作为sorted函数的参数进行传入的，Swift可以推断其参数和返回值的类型。 sorted期望第二个参数是类型为(String, String) -> Bool的函数，因此实际上String,String和Bool类型并不需要作为闭包表达式定义中的一部分。 因为所有的类型都可以被正确推断，返回箭头 (->) 和围绕在参数周围的括号也可以被省略：
reversed = names.sort({ s1, s2 in return s1 > s2 })

//:**Implicit Returns from Single-Expression Closures 单表达式闭包隐式返回** 单行表达式闭包可以通过隐藏return关键字来隐式返回单行表达式的结果
reversed = names.sort({ s1, s2 in s1 > s2 })

//:**Shorthand Argument Names 参数名称缩写** Swift 自动为内联函数提供了参数名称缩写功能，您可以直接通过$0,$1,$2来顺序调用闭包的参数。
reversed = names.sort({ $0 > $1 })

//:**Operator Functions 运算符函数**  Swift 的String类型定义了关于大于号 (>) 的字符串实现，其作为一个函数接受两个String类型的参数并返回Bool类型的值。 而这正好与sorted函数的第二个参数需要的函数类型相符合。
reversed = names.sort(>)

//:**Trailing Closures 尾随闭包** 如果您需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性。 尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用。
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}
someFunctionThatTakesAClosure({
    // closure's body goes here
})

someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}
// 修改前面一个例子
reversed = names.sort() { $0 > $1 }

// map(_:) 对数组中每一个元素执行闭包，返回一个新的数组
let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]
// 参数类型 省略 使用var声明
let strings = numbers.map {
    (var number) -> String in
    var output = ""
    while number > 0 {
        output = digitNames[number % 10]! + output
        number /= 10
    }
    return output
}

//:**Capturing Values 值捕获** 闭包可以在其定义的上下文中捕获常量或变量。 即使定义这些常量和变量的原域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。Swift最简单的闭包形式是嵌套函数，也就是定义在其他函数的函数体内的函数。 嵌套函数可以捕获其外部函数所有的参数以及定义的常量和变量。
func makeIncrementor(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementor() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementor
}
let incrementByTen = makeIncrementor(forIncrement: 10)
incrementByTen()
incrementByTen()
incrementByTen()
// 如果你创建另一个incrementor，其会有一个属于自己的独立的runningTotal变量的引用。
let incrementBySeven = makeIncrementor(forIncrement: 7)
incrementBySeven() // 并不会影响incrementByTen()调用
incrementByTen()

//:**Closures Are Reference Types 闭包是引用类型** 上面的例子中，incrementBySeven和incrementByTen是常量，但是这些常量指向的闭包仍然可以增加其捕获的变量值。 这是因为函数和闭包都是引用类型。
//:无论您将函数/闭包赋值给一个常量还是变量，您实际上都是将常量/变量的值设置为对应函数/闭包的引用。 上面的例子中，incrementByTen指向闭包的引用是一个常量，而并非闭包内容本身。
//:这也意味着如果您将闭包赋值给了两个不同的常量/变量，两个值都会指向同一个闭包：
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()
