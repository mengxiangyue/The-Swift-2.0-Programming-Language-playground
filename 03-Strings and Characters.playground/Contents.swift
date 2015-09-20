//:### 03-Strings and Characters
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出

import UIKit

//:字符串字面量 使用""包裹起来
let someString = "Some string literal value"

//:初始化一个空字符串
var emptyString = ""
var anotherEmptyString = String()
emptyString == anotherEmptyString

// 判断空字符串
if emptyString.isEmpty {
    print("Nothing to see here")
}

// 字符串的可变性 不同于Objective-C Swift使用var、let对应可变、不可变； Objective-C NSString/NSMutableString
var variableString = "Horse"
variableString += " and carriage"

let constantString = "Highlander"
//constantString += " and another Highlander"  // 常量不能改变 error

//:Swift 的String类型是值类型。 如果您创建了一个新的字符串，那么当其进行常量、变量赋值操作或在函数/方法中传递时，会进行值拷贝。 任何情况下，都会对已有字符串值创建新副本，并对该新副本进行传递或赋值操作。在实际编译时，Swift 编译器会优化字符串的使用，使实际的复制只发生在绝对必要的情况下，这意味着您将字符串作为值类型的同时可以获得极高的性能。

//:使用字符（Working with Characters）
for character in "Dog!🐶".characters {
    print(character)
}

// 使用Character类型声明一个字符
let exclamationMark: Character = "!"

// 通过字符构造字符串
let catCharacters: [Character] = ["C", "a", "t", "!","🐱"]
let catString = String(catCharacters)

// 连接字符串和字符
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2

var instruction = "look over"
instruction += string2
// 使用append方法添加字符
//welcome + exclamationMark
welcome.append(exclamationMark)

//:字符串插值 (String Interpolation)。插值字符串中写在括号中的表达式不能包含非转义双引号 (") 和反斜杠 (\)，并且不能包含回车或换行符。
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"

//:Unicode 标量 (Unicode Scalars) 介绍了一些Unicode编码的知识 自己百度吧
// String字面值中的一些特殊字符 \0 \\ \n \r \" \' 标量使用u{n}表示
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
let dollarSign = "\u{24}"
let blackHeart = "\u{2665}"
let sparklingHeart = "\u{1F496}"

// Extended Grapheme(字母) Clusters(群集) 将一个或者多个Unicode标量组合成一个易读的字符
let eAcute: Character = "\u{E9}"
let combinedEAcute: Character = "\u{65}\u{301}"
eAcute == combinedEAcute

// 韩语中一个音节 可以拆分
let precomposed: Character = "\u{D55C}"
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"

// 被标记包围
let enclosedEAcute: Character = "\u{E9}\u{20DD}"

let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"

//:计算字符数量（Counting Characters） 如果需要计算占用的内存 还需要迭代计算
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
unusualMenagerie.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
print("unusualMenagerie has \(unusualMenagerie.characters.count) characters")

var word = "cafe"
word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
print("the number of characters in \(word) is \(word.characters.count)")
word += "\u{301}"
word.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
print("the number of characters in \(word) is \(word.characters.count)")

//:访问、修改字符串
// String Indexes String.Index 字符串中对应位置的Character,由于不同字符占用的存储空间不同，所以为了获取每个字符正确的位置，必须从开始位置迭代Unicode标量获取位置
let greeting = "Guten Tag"
greeting.characters.count
greeting[greeting.startIndex]
greeting[greeting.endIndex.predecessor()]
greeting[greeting.startIndex.successor()]
let index = greeting.startIndex.advancedBy(7)
greeting.startIndex
greeting.endIndex // 字符数+1
//greeting[greeting.endIndex] // error

// Return the range of valid index values.
for index in greeting.characters.indices {
    print("\(greeting[index]) ", terminator: "")
}
print("", terminator: "\n")
// prints "G u t e n   T a g !"


// 插入、删除
welcome = "hello"
welcome.insert("!", atIndex: welcome.endIndex)

welcome.insertContentsOf(" there".characters, at: welcome.endIndex.predecessor())

welcome.removeAtIndex(welcome.endIndex.predecessor())
welcome

// range
let range = welcome.endIndex.advancedBy(-6)..<welcome.endIndex
welcome.removeRange(range)

//:字符串比较
// String and Character Equality == !=
let quotation = "We're a lot alike, you and I."
let sameQuotation = "We're a lot alike, you and I."
if quotation == sameQuotation {
    print("These two strings are considered equal")
}

let eAcuteQuestion = "Voulez-vous un caf\u{E9}?"
let combinedEAcuteQustion = "Voulez-vous un caf\u{65}\u{301}?"
if eAcuteQuestion == combinedEAcuteQustion {
    print("These two strings are considered equal")
}

let latinCapitalLetterA: Character = "\u{41}" // 英语
let cyrillicCapitalLetterA: Character = "\u{0410}" // 俄语
if latinCapitalLetterA != cyrillicCapitalLetterA {
    print("These two strings are not equal")
}

// 前缀/后缀相等 (Prefix and Suffix Equality)

quotation.hasPrefix("We")
quotation.hasSuffix(".")

//:Unicode Representations of Strings
let dogString = "Dog‼🐶"
var image = UIImage(named: "String.utf8")
for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
print("")

image = UIImage(named: "String.utf16")
for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}
print("")
// Unicode Scalar Representation
image = UIImage(named: "String.utf32")
for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}






