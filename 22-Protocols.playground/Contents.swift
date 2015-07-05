//:### 22-Protocols 协议
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:协议(Protocol)用于定义完成某项任务或功能的方法、属性和其它要求的地方。协议能被类、结构体、枚举遵循，提供属于自己的实现。

//:**Protocol Syntax 协议语法**
// 协议定义
//protocol SomeProtocol {
//    // protocol definition goes here
//}

// 遵循协议
//struct SomeStructure: FirstProtocol, AnotherProtocol {
//    // structure definition goes here
//}

// 如果有父类 协议需要放在父类后面
//class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
//    // class definition goes here
//}

//:**Property Requirements 对属性的规定**      
//:协议能够要求遵循该协议的类，提供某些实例属性或者类型属性的名字和类型。不能要求该属性实现的时候是存储属性还是计算属性。同时也可以指定其是否提供getter、setter    
//:如果属性提供getter和setter，该属性不能是常量存储属性或者是read-only的计算属性。如果只是提供getter，那就随便了。   
//:协议中属性声明总是声明为变量。getter->get setter->set      
//:类型属性 总是使用static前缀声明，不管以后是由类、结构体、枚举遵循
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}

protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}

// Example
protocol FullyNamed {
    var fullName: String { get }
}
struct AnotherPerson: FullyNamed { // 遵守协议
    var fullName: String
}
let john = AnotherPerson(fullName: "John Appleseed")

// Complex Example
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String { // 计算只读属性
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")

//:**Method Requirements 对方法的规定**    
//:协议能够要求遵循该协议的类，提供某些实例方法和类方法。语法上与方法声明一致，只是没有大括号。变量参数是允许的，但是参数默认值是不允许的。类型方法始终使用static声明。
//protocol SomeProtocol {
//    static func someTypeMethod()
//}

// Example
protocol RandomNumberGenerator {
    func random() -> Double
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c) % m)
        return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("And another one: \(generator.random())")

//:**Mutating Method Requirements 对突变方法（改变self）的规定**    
//:使用mutating关键字
// Example
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case Off, On
    mutating func toggle() {
        switch self {
        case Off:
            self = On
        case On:
            self = Off
        }
    }
}
var lightSwitch = OnOffSwitch.Off
lightSwitch.toggle()

//:**Initializer Requirements 对构造器的要求**
//protocol SomeProtocol {
//    init(someParameter: Int)
//}

//:**Class Implementations of Protocol Initializer Requirements 协议规定构造器在类中的实现**      
//:在实现中必须使用required关键字声明。使用required修饰符可以保证：所有的遵循该协议的子类，同样能为构造器规定提供一个显式的实现或继承实现。
//class SomeClass: SomeProtocol {
//    required init(someParameter: Int) {
//        // initializer implementation goes here
//    }
//}

// 如果init既是协议中的，也是父类的重写需要同时使用required override声明
//protocol SomeProtocol {
//    init()
//}
//
//class SomeSuperClass {
//    init() {
//        // initializer implementation goes here
//    }
//}
//
//class SomeSubClass: SomeSuperClass, SomeProtocol {
//    // "required" from SomeProtocol conformance; "override" from SomeSuperClass
//    required override init() {
//        // initializer implementation goes here
//    }
//}

//:**Failable Initializer Requirements 对可失败构造器的要求**    
//:要求与普通构造器一样
//protocol SomeProtocol {
//    init?()
//}

//:**Protocols as Types 协议类型**      
//:协议本身并不实现任何功能，但是协议可以被当做类型来使用。     
//:使用场景      
//:* 协议类型作为函数、方法或构造器中的参数类型或返回值类型
//:* 协议类型作为常量、变量或属性的类型
//:* 协议类型作为数组、字典或其他容器中的元素类型
// Example 
class Dice {
    let sides: Int
    let generator: RandomNumberGenerator // 遵守该协议的实例
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}
var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
for _ in 1...5 {
    print("Random dice roll is \(d6.roll())")
}

//:**Delegation 委托(代理)模式**    
//:委托是一种设计模式,它允许类或结构体将一些需要它们负责的功能交由(委托)给其他的类型的实例。代理模式可以通过定义协议声明，需要交给其遵循该协议类型实例负责的任务。
// 骰子游戏
protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll:Int)
    func gameDidEnd(game: DiceGame)
}

// 蛇与梯子游戏 控制流中的 另一个版本
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](count: finalSquare + 1, repeatedValue: 0)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        ++numberOfTurns
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()

//:**Adding Protocol Conformance with an Extension 使用扩展添加遵循协议**    
//:在不能获取源代码的情况下，可以使用扩展使已存在的类型遵循一个新的协议。
protocol TextRepresentable {
    func asText() -> String
}
extension Dice: TextRepresentable {
    func asText() -> String {
        return "A \(sides)-sided dice"
    }
}
let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.asText())

// Another Example
extension SnakesAndLadders: TextRepresentable {
    func asText() -> String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
print(game.asText())

//:**Declaring Protocol Adoption with an Extension 使用扩展声明遵循协议**   
//:如果一个类型已经遵循了某个协议的所有要求，却没有声明时，可以通过空扩展来补充协议声明
struct Hamster {
    var name: String
    func asText() -> String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.asText())

//:**Collections of Protocol Types 协议类型的集合**    
//:协议能够作为集合存储的一种类型。
let things: [TextRepresentable] = [game, d12, simonTheHamster]
for thing in things {
    print(thing.asText())
}

//:**Protocol Inheritance 协议继承**      
//:协议能够继承一到多个其他协议。语法与类的继承相似，多个协议间用逗号分隔
//protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
//    // protocol definition goes here
//}
protocol PrettyTextRepresentable: TextRepresentable {
    func asPrettyText() -> String
}

// Example
extension SnakesAndLadders: PrettyTextRepresentable {
    func asPrettyText() -> String {
        var output = asText() + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}
print(game.asPrettyText())

//:**Class-Only Protocols 类专属协议**   
//:可以限制一个协议只能被类遵守，在协议的继承列表中添加class关键字
//protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
//    // class-only protocol definition goes here
//}

//:**Protocol Composition 协议合成**   
//:协议合成可以要求一个类型一次实现多个协议。语法protocol<SomeProtocol, AnotherProtocol,.....>
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(celebrator: protocol<Named, Aged>) {
    print("Happy birthday \(celebrator.name) - you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(birthdayPerson)

//:**Checking for Protocol Conformance 检验是否遵守协议**     
//:使用is和as操作符来检查协议的一致性或转化协议类型。     
//:* is操作符用来检查实例是否遵循了某个协议。
//:* as?返回一个可选值，当实例遵循协议时，返回该协议类型;否则返回nil
//:* as用以强制向下转型。    
protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}

class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}

let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}

//:**Optional Protocol Requirements 对可选协议的规定**    
//:可选协议中，使用optional声明的，在遵守的该协议的类型中可以选择是否遵守     
//:选协议在调用时使用可选链     
//:像someOptionalMethod?(someArgument)这样，你可以在可选方法名称后加上?来检查该方法是否被实现。可选方法和可选属性都会返回一个可选值(optional value)，当其不可访问时，?之后语句不会执行，并整体返回nil
@objc protocol CounterDataSource {
    optional func incrementForCount(count: Int) -> Int
    optional var fixedIncrement: Int { get }
}
@objc class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.incrementForCount?(count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}

@objc class ThreeSource: CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

@objc class TowardsZeroSource: CounterDataSource {
    func incrementForCount(count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}

//:**Protocol Extensions 协议扩展**    
//:协议扩展可以为遵守该协议的类型提供方法和属性的实现。
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

let anotherGenerator = LinearCongruentialGenerator()
print("Here's a random number: \(anotherGenerator.random())")
print("And here's a random Boolean: \(anotherGenerator.randomBool())")

//:**Adding Constraints to Protocol Extensions 为协议扩展添加约束**    
extension CollectionType where Generator.Element : TextRepresentable {
    func asList() -> String {
        return "(" + ", ".join(map({$0.asText()})) + ")"
    }
}

let murrayTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster] // Array遵守CollectionType协议
print(hamsters.asList())
