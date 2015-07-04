//:### 14-Initialization 构造过程
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:构造过程是为了使用某个类、结构体或枚举类型的实例而进行的准备过程。在这个过程中设置每一个存储属性的初始值、执行其他的要求在实例使用之前的，设置或者初始化的任务。   
//:使用构造器实现初始化方法。与Objective-C不同得，Swift的构造方法，没有返回值。它的主要的角色是保证实例在第一次使用之前，能够被正确得初始化。   
//:类实例也可以通过定义析构器（deinitializer）在类实例释放之前执行特定的清除工作。

//:**Setting initial Values for Stroed Propoerties 设置存储属性的初始值**    
//:类和结构体在实例创建时，必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态。    
//:存储属性可以在构造方法中设置初始值，或者在定义的时候设置。-->这两种方式都不会调用属性观察器

//:**Initializers 构造器** 构造器在创建某个类的实例的时候调用，最简单的构造方法是init()
// 无参构造器
struct Fahrenheit {
    var temperature: Double
    init() {
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)")

//**Default Property Value 默认属性值**   
struct AnotherFahrenheit {
    var temperature = 32.0
}

//:**Customizing Initialization 自定义构造器**  

//:**Initialization Parameters 构造参数**   
//:你能提供构造参数作为构造器定义的一部分，为自定义的构造器的参数提供名字和类型。构造器参数和函数、方法的参数有着相同的能力和语法。
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)

//:**Local and External Parameter Names 本地和外部参数名**  
//:和函数、方法参数一样，构造函数也有本地和外部参数。  
//:然而，构造器并不像函数和方法那样在括号前有一个可辨别的名字。所以在调用构造器时，主要通过构造器中的参数名和类型来确定需要调用的构造器。正因为参数如此重要，如果你在定义构造器时没有提供参数的外部名字，Swift 会为每个构造器的参数自动生成一个跟内部名字相同的外部名，就相当于在每个构造参数之前加了一个哈希符号。
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}
let magenta = Color(red: 1.0, green: 0.0, blue: 0.0)
let halfGray = Color(white: 0.5)
//let veryGreen = Color(0.0, 1.0, 0.0) // 如果不使用外部参数 将会编译错误

//:**Initializer Parameters Without External Names 没有外部参数名的构造参数**   
//:使用下划线(_)取消外部参数名
extension Celsius {
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius(37.0)

//:**Optional Property Types 可选属性类型**   
//:如果自定义类型的存储属性在逻辑上可能没有值，这时候声明这个属性为可选类型。可选类型得属性默认初始化为nil
class SurveyQuestion {
    var text: String
    var response: String? // 答案只有在问题确定后才知道，所以是optional
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."

//:**Assigning Constant Properties During Initialization 在初始化中设置常量的值**     
//:常量属性 只能是在声明的时候设置默认值或者在构造器中设置其值，构造器结束后就不能修改。并且也不能在子类的构造器中修改
// 修改上面的类 问题改为不会变得
class AnotherSurveyQuestion {
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = AnotherSurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beets. (But not with cheese.)"

//:**Default Initializers 默认构造器**     
//:Swift 将为所有属性已提供默认值的且自身没有定义任何构造器的结构体或基类，提供一个默认的构造器。这个默认构造器将简单的创建一个所有属性值都设置为默认值的实例。
class AShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = AShoppingListItem()

//:**Memberwise Initializers for Structure Types 结构体类型逐一参数构造器**   
//:结构体如果没有自定义构造器，Swift将自动为Swift提供一个逐一参数构造器。
struct Size {
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)

//:**Initializer Delegation for Value Types 值类型的构造器代理**     
//:构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理，它能减少多个构造器间的代码重复。  
//:构造器代理的实现规则和形式在值类型和类类型中有所不同。值类型不支持继承，所以它只能代理它自己提供得构造器。类则不同，它可以继承自其它类，这意味着类有责任保证其所有继承的存储型属性在构造时也能正确的初始化。     
//:对于值类型，你可以使用self.init在自定义的构造器中引用其它的属于相同值类型的构造器。并且你只能在构造器内部调用self.init。    
//:对于值类型，如果自定义了构造器，将无法获得默认构造器。

// 上面有定义过
//struct Size {
//    var width = 0.0, height = 0.0
//}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    // 使用扩展可以只写这一个构造方法
    init(center: Point, size: Size) { // 调用了其他的构造方法 构造器代理
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
//三种初始化方法调用
let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))

//:**Class Inhreitance and Initialization 类的继承和构造过程**   
//:所有得存储属性包括从父类继承的，都必须在构造过程中初始化。Swift 提供了两种类型的类构造器来确保所有类实例中存储型属性都能获得初始值，它们分别是指定构造器和便利构造器。

//:**Designated Initializers and Convenience Intializers 指定构造器和便利构造器** 参考<http://swifter.tips/init-keywords/>     
//:指定构造器对于一个类来说是主要的构造器。指定构造器将会初始化类的所有的属性，并且一直会沿着集成关系链，初始化父类的属性。     
//:每个类必须至少有一个指定构造器。在某些情况下，许多类通过继承了父类中的指定构造器而满足了这个条件。    
//:便利构造器是类初始化方法中的二等公民。 便利构造器需要调用指定构造器初始化。如果没有必要可以没有便利构造器。

//:**Syntax for Designated and Convenience Initializers 指定构造器和便利构造器语法**   
//:指定构造器
//:init([parameters]) {
//:    [statements]
//:}
//:    
//:便利构造器     
//:convenience init([parameters]) {
//:    [statements]
//:}

//:**Initializer Delegation for Class Types 类得构造器代理**   
//:构造器规则    
//: 1 指定构造器必须调用直接父类的指定构造器    
//: 2 便利构造器必须调用同一类中定义的其它构造器。    
//: 3 便利构造器必须最终以调用一个指定构造器结束。   
//: 简便记忆
//: * 指定构造器必须总是向上代理
//: * 便利构造器必须总是横向代理  
//:Example 如下图所示
var image = UIImage(named: "initializerDelegation01")
image = UIImage(named: "initializerDelegation02")

//:**Two-Phase Initialization 两段式构造**
//: 1 初始化所有的存储属性
//: 2 在实例被准备好使用之前，再有一次机会去修改存储属性
//:Swift通过四种安全检查保证两段式构造的完成：
//:check 1: 指定构造器必须保证它所在类引入的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器。    
//:check 2: 指定构造器必须先向上代理调用父类构造器，然后再为继承的属性设置新值。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖。     
//:check 3: 便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖。    
//:check 4: 构造器在第一阶段构造完成之前，不能调用任何实例方法、不能读取任何实例属性的值，self的值不能被引用。    
//:     
//:类实例在第一阶段结束以前并不是完全有效。   
//:以下是两段式构造过程中基于上述安全检查的构造流程展示：
//:阶段 1
//: * 某个指定构造器或便利构造器被调用；
//: * 完成新实例内存的分配，但此时内存还没有被初始化；
//: * 指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化；
//: * 指定构造器将调用父类的构造器，完成父类属性的初始化；
//: * 这个调用父类构造器的过程沿着构造器链一直往上执行，直到到达构造器链的最顶部；
//: * 当到达了构造器链最顶部，且已确保所有实例包含的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段1完成。
//:     
//:阶段 2
//: * 从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。
//: * 最终，任意构造器链中的便利构造器可以有机会定制实例和使用self。
//: 例子：阶段1
image = UIImage(named: "twoPhaseInitialization01")

//:阶段2
image = UIImage(named: "twoPhaseInitialization02")

//:**Initializer Inheritance and Overriding 构造方法的继承与重写**
//:Swift默认是不会继承父类的构造方法。如果子类想实现与父类一样得构造方法，可以自己去定义实现。  
//:但是如果定义了一个和父类指定构造器一样的构造器，必须使用override关键字标注。
class Vehicle { // 将会自动提供一个默认的构造器
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")

class Bicycle: Vehicle {
    override init() { // override 关键字
        super.init() // 只能在调用了父类的init后 才能修改父类的属性
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")

//:**Automatic Initializer Inheritance 构造器的自动继承**   
//:规则 1 如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。
//:规则 2 如果子类提供了所有父类指定构造器的实现--不管是通过规则1继承过来的，还是通过自定义实现的--它将自动继承所有父类的便利构造器

//:**Designated and Convenience Initializers in Action 指定构造器和便利构造器实战**
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
image = UIImage(named: "initializersExample01")
let namedMeat = Food(name: "Bacon")
let mysteryMeat = Food()

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    convenience override init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
image = UIImage(named: "initializersExample02")
let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)

class ShoppingListItem: RecipeIngredient { // 将继承父类的构造器
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}
image = UIImage(named: "initializersExample03")
var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]
breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}

//:**Failable Initializers 可失败构造器** init? 返回一个optional的实例
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty {
            return nil // 默认构造方法中是不需要使用return的 只有返回nil的时候使用
        }
        self.species = species
    }
}
let someCreature = Animal(species: "Giraffe")
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}

//:**Failable Initializers for Enumerations 枚举的可失败构造器**
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}

let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

//:**Failable Initializers for Enumerations with Raw Values 带原始值的枚举类型的可失败构造器**
enum AnotherTemperatureUnit: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

let anotherFahrenheitUnit = AnotherTemperatureUnit(rawValue: "F")
if anotherFahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}
// prints "This is a defined temperature unit, so initialization succeeded."

let anoterUnknownUnit = AnotherTemperatureUnit(rawValue: "X")
if anoterUnknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

//:**Failable Initializers for Classes 类的可失败构造器**
//:类的可失败构造器只能在所有的类属性被初始化后和所有类之间的构造器之间的代理调用发生完后触发失败行为。
class Product {
    let name: String!
    init?(name: String) {
        self.name = name
        // 失败 不能写在self.name = name之前
        if name.isEmpty { return nil }
    }
}
if let bowTie = Product(name: "bow tie") {
    print("The product's name is \(bowTie.name)") // name属性用！标注 所以可以直接使用
}

//:**Propagation of Initialization Failure 构造失败的传递**     
//:无论是向上代理还是横向代理，如果你代理的可失败构造器，在构造过程中触发了构造失败的行为，整个构造过程都将被立即终止，接下来任何的构造代码都将不会被执行。
class CartItem: Product {
    let quantity: Int!
    init?(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
        if quantity < 1 { return nil }
    }
}
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}
// 失败
if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}
if let oneUnnamed = CartItem(name: "", quantity: 1) {
    print("Item: \(oneUnnamed.name), quantity: \(oneUnnamed.quantity)")
} else {
    print("Unable to initialize one unnamed product")
}

//:**Overriding a Failable Initializer 重写可失败构造器**    
//:能够像其他的构造方法一样重写可失败的构造方。并且能够使用一个不会失败的构造方法重写父类可失败的构造方法，去阻止可失败的构造。
//:当你用一个子类的非可失败构造器覆盖了一个父类的可失败构造器时，子类的构造器将不再能向上代理父类的可失败构造器.
class Document {
    var name: String?
    // this initializer creates a document with a nil name value
    init() {}
    // this initializer creates a document with a non-empty name value
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

//:**The init! Failable Initializer**
//:init!失败构造器将会构建一个特定类型的隐式解析可选类型的对象。

//:**Required Initializers 必要构造器**    
//:在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器
class SomeClass {
    required init() {
        // initializer implementation goes here
    }
}
class SomeSubclass: SomeClass {
    required init() { // 在子类中使用required表明子类必须包含该构造器
        // subclass implementation of the required initializer goes here
    }
}

//:**Setting a Default Property Value with a Closure or Function 通过闭包和函数来设置属性的默认值**
//class SomeClass {
//    let someProperty: SomeType = {
//        // create a default value for someProperty inside this closure
//        // someValue must be of the same type as SomeType
//        return someValue
//        }()
//}

//例子
image = UIImage(named: "checkersBoard")
// 数组中的某元素布尔值为true表示对应的是一个黑格，布尔值为false表示对应的是一个白格
struct Checkerboard {
    let boardColors: [Bool] = {
        var temporaryBoard = [Bool]()
        var isBlack = false
        for i in 1...10 {
            for j in 1...10 {
                temporaryBoard.append(isBlack)
                isBlack = !isBlack
            }
            isBlack = !isBlack
        }
        return temporaryBoard
        }()
    func squareIsBlackAtRow(row: Int, column: Int) -> Bool {
        return boardColors[(row * 10) + column]
    }
}
let board = Checkerboard()
print(board.squareIsBlackAtRow(0, column: 1))
print(board.squareIsBlackAtRow(9, column: 9))







