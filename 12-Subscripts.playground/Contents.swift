//:### 12-Subscripts 下标脚本
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:类、结构体、枚举能够定义下标脚本，下标脚本是一种快捷访问、设置集合、列表、队列的元素的方式。使用下标脚本的索引设置和获取值，不需要再调用实例的特定的赋值和访问方法。对于同一个目标可以定义多个下标脚本，通过索引值类型的不同来进行重载，下标脚本可以定义多个入参的下标脚本满足自定义类型的需求。
//这个建议看一下Alamofire源代码，里面使用了下标脚本存储每次请求的delegate

//:**Subscript Syntax 语法** 下标角标能够让你在实例后面使用[]访问一个类型的实例。 类似计算属性，但是不同需要在前面添加subscript关键字。 可以设置为read-write or read-only
// 伪代码例子
//subscript(index: Int) -> Int {
//    get {
//        return an appropriate subscript value here
//    }
//    set(newValue) { // 可以省略newValue 因为这个是默认的名字 可以直接使用
//        perform a suitable setting action here
//    }
//}

// 如果是 read-only的 可以省略set
//subscript(index: Int) -> Int {
//    return an appropriate subscript value here
//}

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")

//:**Subscript Usage 下标脚本用法** 下标脚本比较典型的一个用法是：访问集合（collection），列表（list）或序列（sequence）中元素的快捷方式
var numberofLegs = ["spider": 8, "ant": 6, "cat": 4]
numberofLegs["bird"] = 2

//:**Subscript Options 下标脚本选项** 下标脚本可以使用任意多个的输入参数，并且这个输入参数可以是任意类型，同时也可以返回任意类型。可以使用变量参数和可变参数，但是不能使用in-out参数和提供参数默认值。一个类或结构体可以根据自身需要提供多个下标脚本实现，在定义下标脚本时通过入参个类型进行区分，使用下标脚本时会自动匹配合适的下标脚本实现运行，这就是下标脚本的重载。

// 使用一维数组表示矩阵
struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValidForRow(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

var matrix = Matrix(rows: 2, columns: 2)
var image = UIImage(named: "subscriptMatrix01")
matrix[0, 1] = 1.5
matrix[1, 0] = 3.2
image = UIImage(named: "subscriptMatrix02")

// 在下标脚本中使用了assert去校验索引是否合法 下面会报错
//let someValue = matrix[2, 2]
