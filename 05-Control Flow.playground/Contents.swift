//:### 05-Control Flow
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出

import UIKit

//:For Loops 循环

//:fro-in
for index in 1...5 { // index 作用范围只在{}内，并且是不可变的
    print("\(index) times 5 is \(index * 5)")
}

// 如果不需要使用循环中的值 可以使用_忽略
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")

// 循环数组
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}

// 循环Dictionary 这个循环获取的结果可能跟插入的顺序不一致，因为Dictionary是无序的
let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}

//:For for [initialization]; [condition]; [increment] {} 去掉了if后面的小括号，但是大括号是不能省略的
//执行顺序
//1 循环首次启动时，初始化表达式（initialization expression）被调用一次，用来初始化循环所需的所有常量和变量。
//2 条件表达式（condition expression）被调用，如果表达式调用结果为false，循环结束，继续执行for循环关闭大括号 （}）之后的代码。如果表达式调用结果为true，则会执行大括号内部的代码（statements）。
//3 执行所有语句（statements）之后，执行递增表达式（increment expression）。通常会增加或减少计数器的值，或者根据语句（statements）输出来修改某一个初始化的变量。当递增表达式运行完成后，重复执行第 2 步，条件表达式会再次执行。
for var index = 0; index < 3; ++index {
    print("index is \(index)")
}

// 上面的var index只能在{}中使用，如果想在循环结束后使用，需要提前声明
var index: Int
for index = 0; index < 3; ++index {
    print("index is \(index)")
}
print("The loop statements were executed \(index) times")

//:While Loops While循环，用于在循环次数不知道的情况下

//:While while [condition] { [statements] } [condition]为true会一直执行，直到[condition]为false结束循环
var image = UIImage(named: "snakesAndLadders")
//游戏盘面包括 25 个方格，游戏目标是达到或者超过第 25 个方格；
//每一轮，你通过掷一个 6 边的骰子来确定你移动方块的步数，移动的路线由上图中横向的虚线所示；
//如果在某轮结束，你移动到了梯子的底部，可以顺着梯子爬上去；
//如果在某轮结束，你移动到了蛇的头部，你会顺着蛇的身体滑下去。
let finalSquare = 25
var board = [Int](count: finalSquare + 1, repeatedValue: 0)
// 特殊位置 有梯子的位置 下面0*、+** 都是为了格式整齐，但不是必须
board[03] = +8; board[06] = +11; board[09] = +9; board[10] = +2
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08

var square = 0
var diceRoll = 0
while square < finalSquare {
    if ++diceRoll == 7 {
        diceRoll = 1
    }
    square += diceRoll
    if square < board.count {
        square += board[square]
    }
}
print("Game over!")

//:Repeat-While 等同于其他语言的do-while。 repeat { [statements] } while [condition]  首先执行statements，然后执行condition判断，condition==true继续执行，condition==false结束运行。statements最少会被执行一次。
square = 0
diceRoll = 0
repeat {
    square += board[square]
    if ++diceRoll == 7 {
        diceRoll = 1
    }
    square += diceRoll
} while square < finalSquare
print("Game over!")

//:Conditional Statements if:简单、少数的分支 switch:复杂、分支比较多

//:/ if-else
var temperatureInFahrenheit = 30
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
}
// else
temperatureInFahrenheit = 40
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else {
    print("It's not that cold. Wear a t-shirt")
}
// else if
temperatureInFahrenheit = 90
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen")
} else { // 最后一个else 可以省略
    print("It's not that cold. Wear a t-shirt")
}

//:Switch 与其他语言不同，不用在每个case中写break，swift只会执行一个case。switch语句必须是完备的。这就是说，每一个可能的值都必须至少有一个 case 分支与之对应。在某些不可能涵盖所有值的情况下，你可以使用默认（default）分支满足该要求，这个默认分支必须在switch语句的最后面。case中的条件可以是多个，并且可以是任意类型
image = UIImage(named: "switch.jpg")
let someCharacter: Character = "e"
switch someCharacter {
// 每一个case必须有执行语句，否则会报错,如果多个case执行相同的代码，可以如下将多个case逗号隔开放到一起
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "x", "z":
    print("\(someCharacter) is a consonant")
default: // default在switch中一般不能省略，只有完全确定了包含了所有的可能才能省略，比如下面的枚举
    print("\(someCharacter) is not a vowel or a consonant")
}

enum XX {
    case a
    case b
}

let tempA: XX = .a
switch tempA {
case .a:
    print("a")
case .b:
    print("b")
}

//:No Implicit Fallthrough 不存在隐式的贯穿

//:Interval Matching
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")

//:Tuples 元组
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("(0, 0) is at the origin")
case (_, 0): // x任意 y==0
    print("(\(somePoint.0), 0) is on the x-axis")
case (0, _): // x==0 y任意
    print("(0, \(somePoint.1)) is on the y-axis")
case (-2...2, -2...2):
    print("(\(somePoint.0), \(somePoint.1)) is inside the box")
default:
    print("(\(somePoint.0), \(somePoint.1)) is outside the box")
}
image = UIImage(named: "coordinateGraphSimple")
// 虽然上面如果point为(0,0)的时候，会满足所有的case，但是swift只会选择第一个满足的执行

//:Value Bindings 值绑定 变量只能在case代码块中使用
let anotherPoint = (2, 0)
// 注意下面是没有default的
// 下面的let声明，可以改成var声明
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis whth a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
image = UIImage(named: "coordinateGraphMedium")

// Where
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
image = UIImage(named: "coordinateGraphComplex")

//:Control Transfer Stratements 控制转移语句 continue break fallthrough return

//:Continue continue语句告诉一个循环体立刻停止本次循环迭代，重新开始下次循环迭代。就好像在说“本次循环迭代我已经执行完了”，但是并不会离开整个循环体。

let puzzleInput = "great minds think alike"
var puzzleOutput = ""
for character in puzzleInput.characters {
    switch character {
    case "a", "e", "i", "o", "u", " ":
        continue
    default:
        puzzleOutput.append(character)
    }
}
print(puzzleOutput)

//:Break break语句会立刻结束整个控制流的执行。当你想要更早的结束一个switch/if代码块或者一个循环体时，你都可以使用break语句。
let numberSymbol: Character = "三"  // 简体中文里的数字 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
    possibleIntegerValue = 1
case "2", "٢", "二", "๒":
    possibleIntegerValue = 2
case "3", "٣", "三", "๓":
    possibleIntegerValue = 3
case "4", "٤", "四", "๔":
    possibleIntegerValue = 4
default:
    break // 不需要执行代码 可以使用break 但是不能为空
}
if let integerValue = possibleIntegerValue {
    print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
    print("An integer value could not be found for \(numberSymbol).")
}

//:Fallthrough Swift 中的switch不会从上一个 case 分支落入到下一个 case 分支中。相反，只要第一个匹配到的 case 分支完成了它需要执行的语句，整个switch代码块完成了它的执行。你确实需要 C 风格的贯穿（fallthrough）的特性，你可以在每个需要该特性的 case 分支中使用fallthrough关键字
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)

//:Labeled Statements 带标签的语句 在 Swift 中，你可以在循环体和switch代码块中嵌套循环体和switch代码块来创造复杂的控制流结构。然而，循环体和switch代码块两者都可以使用break语句来提前结束整个方法体。因此，显示地指明break语句想要终止的是哪个循环体或者switch代码块，会很有用。类似地，如果你有许多嵌套的循环体，显示指明continue语句想要影响哪一个循环体也会非常有用。
//:为了实现这个目的，你可以使用标签来标记一个循环体或者switch代码块，当使用break或者continue时，带上这个标签，可以控制该标签代表对象的中断或者执行。

// 例子：在前面的游戏上添加一条规则-->为了获胜，你必须刚好落在第 25 个方块中。
square = 0
diceRoll = 0
gameLoop: while square != finalSquare {
    if ++diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // 到达最后一个方块，游戏结束
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // 超出最后一个方块，再掷一次骰子
        continue gameLoop
    default:
        // 本次移动有效
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")

//:Early Exit guard语法，与if类似，都是更具一个布尔语句的结果执行。不同的是，为了能够保证guard后的代码能够执行，你必须保障guard中的条件是true。否则将会执行else的内容（else必须存在）
func greet(person: [String: String]){
    guard let name = person["name"] else  {
        return
    }
    print("Hello \(name)!")
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(["name":"John"])
greet(["name":"Jane", "location": "Cupertino"])

var temp: Int?
for index in 1...5 {
    guard let tt = temp else {
        break
    }
    print("xxxfff")
}

//:Checking API Availability 可使用值:iOS 8.3 OSX 10.10.3 watchOS
if #available(iOS 9, OSX 10.10, *) {
    // Use iOS9 APIs on iOS， and use OS X v10.10 APIs on OS X
} else {
    // Fall back to earlier iOS and OS X APIs
}




