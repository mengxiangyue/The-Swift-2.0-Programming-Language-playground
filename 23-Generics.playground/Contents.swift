//:### 23-Generics 泛型
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:泛型代码可以让你写出根据自我需求定义、适用于任何类型的，灵活且可重用的函数和类型。避免重复的代码.泛型是 Swift 强大特征中的其中一个，许多 Swift 标准库是通过泛型代码构建出来的。

//:**The Problem That Generics Solve 泛型解决的问题**    
// 下面是一个普通的交换函数
func swapTwoInts(inout a: Int, inout _ b: Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")

// 上面的函数只能交换Int类型的，如果希望交换String、Double类型的，还得定义：
func swapTwoStrings(inout a: String, inout _ b: String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

func swapTwoDoubles(inout a: Double, inout _ b: Double) {
    let temporaryA = a
    a = b
    b = temporaryA
}

// 如果能够写一个通用的交换两个变量的方法就好了

//:**Generic Functions 泛型函数**    
//:泛型函数能够用于任何类型
func swapTwoValues<T>(inout a: T, inout _ b: T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
// 下面两个函数的主体是一样的，只是声明不同
//func swapTwoInts(inout a: Int, inout _ b: Int)
//func swapTwoValues<T>(inout a: T, inout _ b: T)
// 泛型函数使用了占位类型名字来代替实际类型名。上面的T不是确定的类型，只是当调用的时候传入的是什么类型，T当时就是什么类型。

someInt = 3
anotherInt = 107
swapTwoValues(&someInt, &anotherInt)


var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)

//:**Type Parameters 类型参数**     
//:在上面的swapTwoValues例子中，占位类型T是一种类型参数的示例。类型参数指定并命名为一个占位类型，并且紧随在函数名后面，使用一对尖括号括起来（如<T>）。这里的T可以使用其他的字符。同时也可以提供多个命名参数
func test<A, B>(a: A, b: B) -> String {
    return "\(a) \(b)"
}
test(1, b: 2.5)

//:**Generic Types 泛型类型**     
//:Swift 允许你定义你自己的泛型类型。这些自定义类、结构体和枚举作用于任何类型，如同Array和Dictionary的用法。
// Example Stack 
var image = UIImage(named: "stackPushPop_2x")
// push pop
struct IntStack {
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

// 上面的只能存储Int类型，下面一个泛型版本的
struct Stack<T> {
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
image = UIImage(named: "stackPushedFourStrings_2x")

let fromTheTop = stackOfStrings.pop()
image = UIImage(named: "stackPoppedOneString_2x")

//:**Extending a Generic Type 扩展一个泛型类型**    
//:当你扩展一个泛型类型的时候，你并不需要在扩展的定义中提供类型参数列表。更加方便的是，原始类型定义中声明的类型参数列表在扩展里是可以使用的，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用。
extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}
if let topItem = stackOfStrings.topItem {
    print("The top item on the stack is \(topItem).")
}

//:**Type Constraints 类型约束**    
//:类型约束指定了一个必须继承自指定类的类型参数，或者遵循一个特定的协议或协议构成。

//:**Type Constraint Syntax 类型约束语法**  
//T 为SomeClass的子类 U遵守SomeProtocol协议
//func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
//    // function body goes here
//}

//:**Type Constraints in Action 类型约束实战**    
// 非泛型函数 在数组中查找字符串
func findStringIndex(array: [String], _ valueToFind: String) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findStringIndex(strings, "llama") {
    print("The index of llama is \(foundIndex)")
}
// 泛型版本 但是下面的会有编译错误
//func findIndex<T>(array: [T], _ valueToFind: T) -> Int? {
//    for (index, value) in array.enumerate() {
//        // 并不是所有的类型都支持 == 比较，只有实现Equatable协议的才可以。 所以编译错误
//        if value == valueToFind {
//            return index
//        }
//    }
//    return nil
//}

func findIndex<T: Equatable>(array: [T], _ valueToFind: T) -> Int? {
    for (index, value) in array.enumerate() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}
let doubleIndex = findIndex([3.14159, 0.1, 0.25], 9.3)
let stringIndex = findIndex(["Mike", "Malcolm", "Andrea"], "Andrea")

//:**Associated Types 关联类型**    
//:当定义一个协议时，有的时候声明一个或多个关联类型作为协议定义的一部分是非常有用的。一个关联类型作为协议的一部分，给定了类型的一个占位名（或别名）。作用于关联类型上实际类型在协议被实现前是不需要指定的。关联类型被指定为typealias关键字。

//:**Associated Types in Action 关联类型实战**
protocol Container {
    typealias ItemType
    mutating func append(item: ItemType)
    var count: Int { get }
    subscript(i: Int) -> ItemType { get }
}
//任何遵循Container协议的类型必须指定存储在其里面的值类型，必须保证只有正确类型的元素可以加进容器里，必须明确可以通过其下标返回元素类型。
// 遵守协议的时候，Swift编译器能够推断出来关联类型的实际类型，比如在下面AnotherIntStack 关联类型ItemType=Int
struct AnotherIntStack: Container {
    // IntStack的原始实现
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
    // 遵循Container协议的实现
    typealias ItemType = Int
    mutating func append(item: Int) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> Int {
        return items[i]
    }
}

// 遵循Container协议的Stack
struct AnotherStack<T>: Container {
    // original Stack<T> implementation
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        return items.removeLast()
    }
    // conformance to the Container protocol
    mutating func append(item: T) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> T {
        return items[i]
    }
}

//:**Extending an Existing Type to Specify an Associated Type 扩展一个存在的类型为一指定关联类型**
// Array已经实现了Container协议的方法
extension Array: Container {}

//:**Where Clauses Where语句**     
//:对关联类型定义约束是非常有用的。你可以在参数列表中通过where语句定义参数的约束。一个where语句能够使一个关联类型遵循一个特定的协议，以及（或）那个特定的类型参数和关联类型可以是相同的。
func allItemsMatch<
    C1: Container, C2: Container
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable>
    (someContainer: C1, _ anotherContainer: C2) -> Bool {
        
        // 检查两个Container的元素个数是否相同
        if someContainer.count != anotherContainer.count {
            return false
        }
        
        // 检查两个Container相应位置的元素彼此是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        
        // 如果所有元素检查都相同则返回true
        return true
        
}

var anoterStackOfStrings = AnotherStack<String>()
anoterStackOfStrings.push("uno")
anoterStackOfStrings.push("dos")
anoterStackOfStrings.push("tres")

var arrayOfStrings = ["uno", "dos", "tres"]

if allItemsMatch(anoterStackOfStrings, arrayOfStrings) {
    print("All items match.")
} else {
    print("Not all items match.")
}


