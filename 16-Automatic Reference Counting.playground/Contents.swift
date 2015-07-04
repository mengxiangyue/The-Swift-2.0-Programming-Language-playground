//:### 16-Automatic Reference Counting 自动引用计数
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:Swift 使用自动引用计数（ARC）机制来跟踪和管理你的应用程序的内存。引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递

//:**How ARC Works 自动引用计数的工作机制**   
//:当你每次创建一个类的新的实例的时候，ARC 会分配一大块内存用来储存实例的信息。内存中会包含实例的类型信息，以及这个实例所有相关属性的值。
//:此外，当实例不再被使用时，ARC 释放实例所占用的内存，并让释放的内存能挪作他用。这确保了不再被使用的实例，不会一直占用内存空间。

//:**ARC in Action ARC实战**   
class AnotherPerson {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}
var reference1: AnotherPerson?
var reference2: AnotherPerson?
var reference3: AnotherPerson?
reference1 = AnotherPerson(name: "John Appleseed") // 强引用
reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil // 这时候并不会释放
reference3 = nil // 打印出释放信息

//:**Strong Reference Cycles Between Class Instances 类实例之间的循环强引用** 
//:如果两个类实例互相持有对方的强引用，因而每个实例都让对方一直存在，就是这种情况。这就是所谓的循环强引用。可以通过定义类之间的关系为弱引用或无主引用，以替代强引用，从而解决循环强引用的问题。   
// 产生的循环引用的例子
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let number: Int
    init(number: Int) { self.number = number }
    var tenant: Person?
    deinit { print("Apartment #\(number) is being deinitialized") }
}
var john: Person?
var number73: Apartment?
john = Person(name: "John Appleseed")
number73 = Apartment(number: 73)
var image = UIImage(named: "referenceCycle01_2x")

john!.apartment = number73
number73!.tenant = john
image = UIImage(named: "referenceCycle02_2x")

john = nil
number73 = nil
image = UIImage(named: "referenceCycle03_2x")

//**Resolving Strong Reference Cycles Between Class Instances 解决实例之间的循环强引用**    
//:Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）。
//:弱引用和无主引用允许循环引用中的一个实例引用另外一个实例而不保持强引用。这样实例能够互相引用而不产生循环强引用。     
//:对于生命周期中会变为 nil 的实例使用弱引用。相反地，对于初始化赋值后再也不会被赋值为 nil 的实例，使用无主引用。

//:**Weak References 弱引用**   
//:弱引用不会对其引用的实例保持强引用，因而不会阻止 ARC 销毁被引用的实例。因为弱引用可以没有值，你必须将每一个弱引用声明为可选类型。
// 由于在同一个Playground中 所以在Person前面加上了Second、Third等
class SecondPerson {
    let name: String
    init(name: String) { self.name = name }
    var apartment: SecondApartment?
    deinit { print("SecondPerson \(name) is being deinitialized") }
}

class SecondApartment {
    let number: Int
    init(number: Int) { self.number = number }
    weak var tenant: SecondPerson?
    deinit { print("SecondApartment Apartment #\(number) is being deinitialized") }
}

var secondJohn: SecondPerson?
var secondNumber73: SecondApartment?

secondJohn = SecondPerson(name: "John Appleseed")
secondNumber73 = SecondApartment(number: 73)

secondJohn!.apartment = secondNumber73
secondNumber73!.tenant = secondJohn
image = UIImage(named: "weakReference01_2x")

// 断开secondJoin实例的引用
secondJohn = nil
image = UIImage(named: "weakReference02_2x")

secondNumber73 = nil
image = UIImage(named: "weakReference03_2x")

//:**Unowned References 无主引用**
//:和弱引用类似，无主引用不会牢牢保持住引用的实例。和弱引用不同的是，无主引用是永远有值的。因此，无主引用总是被定义为非可选类型（non-optional type）。使用unowned关键字
// 例子：Customer 和 CreditCard ，模拟了银行客户和客户的信用卡。
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}
var customer: Customer?
customer = Customer(name: "John Appleseed")
customer!.card = CreditCard(number: 1234_5678_9012_3456, customer: customer!)
// 下图中join == 代码中的customer
image = UIImage(named: "unownedReference01_2x")

customer = nil
image = UIImage(named: "unownedReference02_2x")

//:**Unowned References and Implicitly Unwrapped Optional Properties 无主引用以及隐式解析可选属性**  
//Person 和 Apartment 的例子展示了两个属性的值都允许为 nil ，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。
//Customer 和 CreditCard 的例子展示了一个属性的值允许为 nil ，而另一个属性的值不允许为 nil ，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。
//然而，存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为 nil 。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析可选属性。
//这使两个属性在初始化完成后能被直接访问（不需要可选展开），同时避免了循环引用。
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")

//**Strong Reference Cycles for Closures 闭包引起的循环强引用**    
//:循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例。这个闭包体中可能访问了实例的某个属性，例如 self.someProperty ，或者闭包中调用了实例的某个方法，例如 self.someMethod 。这两种情况都导致了闭包 “捕获" self ，从而产生了循环强引用。  
//:Swift 提供了一种优雅的方法来解决这个问题，称之为闭包捕获列表（closuer capture list）。   
// 产生原因
class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

image = UIImage(named: "closureReferenceCycle01_2x")
// 由于asHTML捕获了self，即使设置为nil 也不会被释放
paragraph = nil

//:**Resolving Strong Reference Cycles for Closures 解决闭包引起的循环强引用**   
//:在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用。捕获列表定义了闭包体内捕获一个或者多个引用类型的规则。跟解决两个类实例间的循环强引用一样，声明每个捕获的引用为弱引用或无主引用，而不是强引用。应当根据代码关系来决定使用弱引用还是无主引用。
//定义捕获列表
// 有参数
//lazy var someClosure: (Int, String) -> String = {
//    [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
//    // closure body goes here
//}
// 无参数
//lazy var someClosure: Void -> String = {
//    [unowned self, weak delegate = self.delegate!] in
//    // closure body goes here
//}

//:**Weak and Unowned References 弱引用和无主引用**
class AnotherHTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

var anotherParagraph: AnotherHTMLElement? = AnotherHTMLElement(name: "p", text: "hello, world")
print(anotherParagraph!.asHTML())
anotherParagraph = nil
image = UIImage(named: "closureReferenceCycle02_2x")





