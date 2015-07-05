//:### 18-Error Handling 错误处理
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:错误处理是在程序错误的情况下去响应、恢复的处理过程。Swift提供了在运行时错误的抛出、捕获、传递、错误恢复的能力。

//:**Representing Errors 错误表示**       
//:在Swift中，error被实现了ErrorType协议的值类型表示。Swift的枚举比较合适表示error。
enum VendingMachineError: ErrorType {
    case InvalidSelection
    case InsufficientFunds(required: Double) // 错误关联值
    case OutOfStock
}

//:**Throwing Errors 抛出错误**     
//:可以使用throws关键字表明函数和方法能够抛出错误
func canThrowErrors() throws -> String {
    return "x"
}
struct Item {
    var price: Double
    var count: Int
}

var inventory = [
    "Candy Bar": Item(price: 1.25, count: 7),
    "Chips": Item(price: 1.00, count: 4),
    "Pretzels": Item(price: 0.75, count: 11)
]
var amountDeposited = 1.00

// guard
func vend(itemNamed name: String) throws {
    guard var item = inventory[name] else {
        throw VendingMachineError.InvalidSelection
    }
    
    guard item.count > 0 else {
        throw VendingMachineError.OutOfStock
    }
    
    if amountDeposited >= item.price {
        // Dispense the snack
        amountDeposited -= item.price
        --item.count
        inventory[name] = item
    } else {
        let amountRequired = item.price - amountDeposited
        throw VendingMachineError.InsufficientFunds(required: amountRequired)
    }
}
// 调用throws的方法，必须使用try在方法之前。
let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]
func buyFavoriteSnack(person: String) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vend(itemNamed: snackName)
}

//:**Catching and Handling Errors 捕获、处理错误**      
//:如果error被抛出来，error将会被向上传递，直到它被catch捕获。
//do {
//    try function that throws
//    statements
//} catch pattern {
//    statements
//}

//catch 必须匹配所有得错误（与switch类似），如果没有必要去匹配所有的错误，可以使用catch捕获所有的错误
do {
    try vend(itemNamed: "Candy Bar")  // 如果这个方法抛出异常 将会在下面catch
    // Enjoy delicious snack
} catch VendingMachineError.InvalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.OutOfStock {
    print("Out of Stock.")
} catch VendingMachineError.InsufficientFunds(let amountRequired) {
    print("Insufficient funds. Please insert an additional $\(amountRequired).")
}

//:**Disabling Error Propagation 忽略Error传递**     
//:如果明确知道一个方法不会抛出异常，可以使用forced-try try!,使用try!将会忽略Error的传递，可以不用使用catch捕获，但是如果在运行时抛出异常，将会产生运行时错误
enum SomeError: ErrorType {
    case errorA
}
func willOnlyThrowIfTrue(value: Bool) throws {
    if value { throw SomeError.errorA }
}

do {
    try willOnlyThrowIfTrue(false)
} catch {
    // Handle Error
}

try! willOnlyThrowIfTrue(false)

//:**Specifying Clean-Up Actions 指定清理任务**       
//:使用defer关键字能够在一个代码块执行完毕之前执行一系列的语句。这个能让我们执行一些必要的清理工作，不管是否发生了错误。defer的执行顺序与定义的顺序相反。
//func processFile(filename: String) throws {
//    if exists(filename) {
//        let file = open(filename)
//        defer {
//            close(file)
//        }
//        while let line = try file.readline() {
//            /* Work with the file. */
//        }
//        // close(file) is called here, at the end of the scope.
//    }
//}





