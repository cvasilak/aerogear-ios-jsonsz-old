# aerogear-ios-jsonsz

Serialize 'Swift' objects back-forth from their JSON representation the 'easy way'.

Here is a typical example usage:

```swift
class Contact : JSONSerializable {
    var first: String?	
    var last: String?	
    var addr: Address?

    required init() {}

    class func map(source: JsonSZ, object: Contact) {
        object.first <= source["first"]
        object.last <= source["last"]
        object.addr <= source["addr"]
    }
}

class Address: JSONSerializable {

    var street: String?
    var poBox: Int?
    var city: String?
    var country: String?

    var arr:[String]
    
    required init() {}
    
    class func map(source: JsonSZ, object: Address) {
        object.street <= source["street"]
        object.poBox <= source["poBox"]
        object.city <= source["city"]
        object.country <= source["country"]
    }
}

// construct object
let address =  Address()
address.street = "Street"
address.poBox = 100
address.city="New York"
address.country = "US"

let user = User()
user.first = "John"
user.last = "Doe"
// assign Address to User
user.addr = address

// initialize serializer
let serializer = JsonSZ()

// serialize ToJSON
let JSON = serializer.toJSON(user)
// ..send json to server

// serialize fromJSON
let user = serializer.fromJSON(JSON, to:User.self)

// user now should be initialized
println(user.first!)
...
```

As long as your model object implements the ```JSONSerializable``` protocol and it's required methods of ```init``` and ```map```, the ```JsonSZ``` class should be able to serialize and deserialize your objects to JSON. The library supports all the primitive types including arrays and dictionaries plus relationship between the objects (as shown by the User, Address example above). Head over to our [unit tests](https://github.com/aerogear/aerogear-ios-jsonsz/blob/master/AeroGearJsonSZTests/AeroGearJsonSZTests.swift) for more examples usage.

Give it a go and let us know if it does help you on your projects!

Last, we would like to give appreciation and credit to the existing serialization libraries of [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) and [SwiftMapper](https://github.com/kam800/SwiftMapper) for giving us an initial bootstrap and ideas to base our development of this library. Thank you guys!


## Build, test and play with aerogear-ios-jsonsz

1. Clone this project

3. open AeroGearJsonSZ.xcodeproj

## Adding the library to your project 

Follow these steps to add the library in your Swift project.

1. [Clone this repository](#1-clone-this-repository)
2. [Add `AeroGearJsonSZ.xcodeproj` to your application target](#2-add-aerogearjsonsz-xcodeproj-to-your-application-target)
3. Start writing your app!

> **NOTE:** Hopefully in the future and as the Swift language and tools around it mature, more straightforward distribution mechanisms will be employed using e.g [cocoapods](http://cocoapods.org) and framework builds. Currently neither cocoapods nor binary framework builds support Swift. For more information, consult this [mail thread](http://aerogear-dev.1069024.n5.nabble.com/aerogear-dev-Swift-Frameworks-Static-libs-and-Cocoapods-td8456.html) that describes the current situation.

### 1. Clone this repository

```
git clone git@github.com:aerogear/aerogear-ios-jsonsz.git
```

### 2. Add `AeroGearJsonSZ.xcodeproj` to your application target

Right-click on the group containing your application target and select `Add Files To YourApp`
Next, select `AeroGearJsonSZ.xcodeproj`, which you downloaded in step 1.

### 3. Start writing your app!

If you run into any problems, please [file an issue](http://issues.jboss.org/browse/AEROGEAR) and/or ask our [user mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-users). You can also join our [dev mailing list](https://lists.jboss.org/mailman/listinfo/aerogear-dev).  

