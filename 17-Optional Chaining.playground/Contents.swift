//:### 17-Optional Chaining 可选链
//:
//:孟祥月　[http://blog.csdn.net/mengxiangyue](http://blog.csdn.net/mengxiangyue)
//:
//: ----
//:
//:本人菜鸟一个，如果哪里有错误，欢迎指出。这些Playground都放在了Github上，欢迎下载。如果你感觉还不错，star一下。地址：<https://github.com/mengxiangyue/The-Swift-2.0-Programming-Language-playground>

import UIKit

//:可选链（Optional Chaining）是一种可以请求和调用属性、方法及下标脚本的过程，它的可选性体现于请求或调用的目标当前可能为空（nil）。如果可选的目标有值，那么调用就会成功；相反，如果选择的目标为空（nil），则这种调用将返回空（nil）。多次请求或调用可以被链接在一起形成一个链，如果任何一个节点为空（nil）将导致整个链失效。

//:**Optional Chaining as an Alternative to Forced Unwrapping 可选链作为强制解析的一种选择**     
//:通过在想调用的属性、方法、或下标脚本的可选值（optional value）（非空）后面放一个问号，可以定义一个可选链。这一点很像在可选值后面放一个叹号来强制拆得其封包内的值。它们的主要的区别在于当可选值为空时可选链即刻失败，然而一般的强制解析将会引发运行时错误。     
//:可选链最后会返回一个optional值。如果在可选链的最后应该返回Int，那么整个可选链的返回类型是Int?
class AnotherPerson {
    var residence: AnotherResidence?
}

class AnotherResidence {
    var numberOfRooms = 1
}
var anotherJohn = AnotherPerson()
// 下面 residence如果强制解析 会引发错误
//let roomCount = john.residence!.numberOfRooms

// 使用可选链 虽然下面的numberOfRooms类型不是Int?，但是由于是在可选链返回的，最后会被Int?代替
if let roomCount = anotherJohn.residence?.numberOfRooms {
    print("anotherJohn residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

anotherJohn.residence = AnotherResidence()
if let roomCount = anotherJohn.residence?.numberOfRooms {
    print("anotherJohn residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

//:**Defining Model Classes for Optional Chaining 为可选链定义模型类**     
//:可以使用可选链来多层调用属性，方法，和下标脚本。这让你可以利用它们之间的复杂模型来获取更底层的属性，并检查是否可以成功获取此类底层属性。
// 例子 房子 房间 人
class Person { // 前面已经定义
    var residence: Residence?
}
class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
    var address: Address?
}
class Room {
    let name: String
    init(name: String) { self.name = name }
}
class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        } else if buildingNumber != nil {
            return buildingNumber
        } else {
            return nil
        }
    }
}

//:**Accessing Properties Through Optional Chaining 通过可选链访问属性**
let john = Person()
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}
let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
john.residence?.address = someAddress

//:**Calling Methods Through Optional Chaining 通过可选链调用方法**
//printNumberOfRooms() 本来返回值是Void 可选链后返回的是Void？同样对于赋值操作也会返回Void？
if john.residence?.printNumberOfRooms() != nil {
    print("It was possible to print the number of rooms.")
} else {
    print("It was not possible to print the number of rooms.")
}

if (john.residence?.address = someAddress) != nil {
    print("It was possible to set the address.")
} else {
    print("It was not possible to set the address.")
}

//:**Accessing Subscripts Through Optional Chaining 通过可选链访问下标脚本**
if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
john.residence?[0] = Room(name: "Bathroom") // 可能会赋值失败

// 可以通过可选链为Residence设置rooms
let johnsHouse = Residence()
johnsHouse.rooms.append(Room(name: "Living Room"))
johnsHouse.rooms.append(Room(name: "Kitchen"))
john.residence = johnsHouse

if let firstRoomName = john.residence?[0].name {
    print("The first room name is \(firstRoomName).")
} else {
    print("Unable to retrieve the first room name.")
}
// prints "The first room name is Living Room."

//:**Accessing Subscripts of Optional Type 访问可选类型的下表脚本**      
//:如果一个下标脚本的返回值是一个可选类型，可以使用如下方法访问：
var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0]++
testScores["Brian"]?[0] = 72

//:**Linking Multiple Levels of Chaining 连接多层链接**    
//:你可以将多层可选链连接在一起，可以获取模型内更下层的属性方法和下标脚本。但是返回的可选类型只会是一层。比如如果通过可选链想获得Int值，不论使用了多少层可选链，最后的返回类型还是Int?
if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}

// 多层可选链访问street属性
let johnsAddress = Address()
johnsAddress.buildingName = "The Larches"
johnsAddress.street = "Laurel Street"
john.residence!.address = johnsAddress

if let johnsStreet = john.residence?.address?.street {
    print("John's street name is \(johnsStreet).")
} else {
    print("Unable to retrieve the address.")
}

//:**Chaining on Methods with Optional Return Values 链接可选返回值的方法**
if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
    print("John's building identifier is \(buildingIdentifier).")
}

//在buildingIdentifier()使用可选链
if let beginsWithThe = john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
        if beginsWithThe {
            print("John's building identifier begins with \"The\".")
        } else {
            print("John's building identifier does not begin with \"The\".")
        }
}





