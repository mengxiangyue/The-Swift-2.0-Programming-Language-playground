//:### 02-Basic Operators
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出

import UIKit

//:运算符分为一元、二元、三元。一元 + - ++ --  二元 + - % 三元 ?:。受运算符影响的值叫操作数

// 赋值运算符= 没有返回值
let b = 10
let (x, y) = (1, 2)
//if x = y {} // 错误

//:算术运算符 + - * / 操作符不能溢出 Int.max + 1 错误  溢出运算符 &+ &- &*
1 + 2
5 - 3
2 * 3
10.0 / 2.5

"hello" + " world"

//:取余运算符 % 求余运算（a % b）是计算b的多少倍刚刚好可以容入a，返回多出来的那部分（余数）。在对负数b求余时，b的符号会被忽略。这意味着 a % b 和 a % -b的结果是相同的。
let a1 = 9, b1 = 4
let c1 = a1 % b1
// a1 = (b1 * 倍数:Int) + c1

9 % 4
9 % -4
-9 % 4

8 % 2.5

//:自增++ 自减-- 一元负号运算符- 一元正号运算符+
var a = 0
++a
a++
a
a = -99
a = +99

//:复合赋值运算符 += -= /= *= %=等 x += b ---> x = x + b
a += 1
a = 9
a %= 4

//:比较运算符 == != > < >= <=, == 字符串比较
1 == 1
1 < 2
1 <= 3

let name = "world"
if name == "world" {
    print("hello world")
}

//:三目运算符 question ? answer1 : answer2 --> if question { answer1 } else { answer2 } 过渡使用可能造成代码难以阅读
let hasHeader = true
let frameY = hasHeader ? 50 : 10

var tmpFrameY = 0
if hasHeader {
    tmpFrameY = 50
} else {
    tmpFrameY = 10
}
//let frameY = tmpFrameY

//:空合运算符(Nil Coalescing Operator) a ?? b ---> a != nil ? a! : b   a必须是optional的
let defaultColorName = "red"
var userDefinedColorName: String?
var colorNameToUse = userDefinedColorName ?? defaultColorName

userDefinedColorName = "gree"
colorNameToUse = userDefinedColorName ?? defaultColorName

//:区间运算符 ... ..<
for index in 1...5 {
    print(index)
}

//:逻辑运算符 ! && ||
let allowedEntry = false
if !allowedEntry {
    print("ACCESS DENIED")
}

// 可以组合 使用括号明确优先级
if (a > 2 && a < 6) || (a > 10 && a<30) {}
