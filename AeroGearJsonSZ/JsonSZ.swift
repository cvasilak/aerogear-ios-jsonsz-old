/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

public protocol JSONSerializable {
    init()
    class func serialize(source: JsonSZ, object: Self)
}

enum Operation {
    case fromJSON
    case toJSON
}

public class JsonSZ {
    var values: [String:  AnyObject] = [:]

    var key: String?
    var value: AnyObject?
    
    var operation: Operation = .fromJSON
    
    public init() {}
    
    public subscript(key: String) -> JsonSZ {
        get {
            self.key = key
            self.value = self.values[key]
            
            return self
        }
    }
    
    public func fromJSON<N: JSONSerializable>(JSON: AnyObject,  to type: N.Type) -> N! {
        if let string = JSON as? String {
            if let data =  JSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
               self.values = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as [String : AnyObject]
            }
        } else if let dictionary = JSON as? Dictionary<String, AnyObject> {
            self.values = dictionary
        }

        var object = N()
        N.serialize(self, object: object)
        return object
    }
    
    public func toJSON<N: JSONSerializable>(object: N) -> [String:  AnyObject] {
        self.values = [String : AnyObject]()
        N.serialize(self, object: object)
        
        return self.values
    }
}

// primitive types
public func <=<T>(inout left: T?, right: JsonSZ) {
    if right.operation == .fromJSON {
        FromJSON<T>().primitiveType(&left, value: right.value)
    }
}

// object types
public func <=<T: JSONSerializable>(inout left: T?, right: JsonSZ) {
    if right.operation == .fromJSON {
        FromJSON<T>().objectType(&left, value: right.value)
    }
}

// array
public func <=<T: JSONSerializable>(inout left: Array<T>?, right: JsonSZ) {
    if right.operation == .fromJSON {
        FromJSON<T>().arrayType(&left, value: right.value)
    }
}

// dictionary
public func <=<T: JSONSerializable>(inout left: [String:  T]?, right: JsonSZ) {
    if right.operation == .fromJSON {
        FromJSON<T>().dictionaryType(&left, value: right.value)
    }
}

class FromJSON<CollectionType> {
    
    func primitiveType<FieldType>(inout field: FieldType?, value: AnyObject?) {
        if let value: AnyObject = value {
            switch FieldType.self {
            case is String.Type:
                field = value as? FieldType
            case is Bool.Type:
                field = value as? FieldType
            case is Int.Type:
                field = value as? FieldType
            case is Double.Type:
                field = value as? FieldType
            case is Float.Type:
                field = value as? FieldType
            case is Array<CollectionType>.Type:
                field = value as? FieldType
            case is Dictionary<String, CollectionType>.Type:
                field = value as? FieldType
            case is NSDate.Type:
                field = value as? FieldType
            default:
                field = nil
                return
            }
        }
    }

    func objectType<N: JSONSerializable>(inout field: N?, value: AnyObject?) {
        if let value = value as? [String:  AnyObject] {
            field = JsonSZ().fromJSON(value, to: N.self)
        }
    }
        
    func arrayType<N: JSONSerializable>(inout field: Array<N>?, value: AnyObject?) {
        let serializer = JsonSZ()
        
        var objects = Array<N>()

        if let array = value as [AnyObject]? {
            for object in array {
                var object = serializer.fromJSON(object as [String: AnyObject],  to: N.self)
                objects.append(object)
            }
        }
        
        field = objects.count > 0 ? objects: nil
    }
        
    func dictionaryType<N: JSONSerializable>(inout field: [String: N]?, value: AnyObject?) {
        let serializer = JsonSZ()
        
        if let dictionary = value as? [String: AnyObject] {
            var objects = [String: N]()
            
            for (key, object) in dictionary {
                var object = serializer.fromJSON(object as [String:  AnyObject], to: N.self)
                objects[key] = object
            }

            field = objects.count > 0 ? objects: nil
        }
    }
}