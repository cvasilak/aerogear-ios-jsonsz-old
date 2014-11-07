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

import UIKit
import XCTest
import AeroGearJsonSZ

class AeroGearJsonSZTests: XCTestCase {
    
    var serializer: JsonSZ!
    
    override func setUp() {
        super.setUp()
        
        serializer = JsonSZ()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testJSONToObjectModelWithPrimitiveAttributes() {
        var employeeJSON = ["id": 100, "firstname": "John", "lastname": "Doe", "title": "Software Engineer", "salary": 123.50, "married": true, "weight": 60.2]
        // serialize from json
        let employee:Employee = self.serializer.fromJSON(employeeJSON, to: Employee.self)
        
        // assert construction has succeeded on primitive fields
        XCTAssertTrue(employee.id == 100)
        XCTAssertTrue(employee.firstname == "John")
        XCTAssertTrue(employee.lastname == "Doe")
        XCTAssertTrue(employee.title == "Software Engineer")
        XCTAssertTrue(employee.salary == 123.50)
        XCTAssertTrue(employee.married == true)
        XCTAssertTrue(employee.weight == 60.2)
    }

    func testObjectModelToJSONWithPrimitiveAttributes() {
        // construct object
        let employee = Employee()
        employee.id = 100
        employee.firstname = "John"
        employee.lastname = "Doe"
        employee.title = "Software Engineer"
        employee.salary = 123.50
        employee.married = true
        employee.weight = 60.2
        
        // serialize to json
        let json = self.serializer.toJSON(employee)
        
        // assert json dictionary has been populated
        XCTAssertTrue(json["id"] as Int == 100)
        XCTAssertTrue(json["firstname"] as String == "John")
        XCTAssertTrue(json["lastname"] as String == "Doe")
        XCTAssertTrue(json["title"] as String == "Software Engineer")
        XCTAssertTrue(json["salary"] as Double == 123.50)
        XCTAssertTrue(json["married"] as Bool == true)
        XCTAssertTrue(json["weight"] as Float == 60.2)
    }
    
     func testJSONToObjectModelWithPrimitiveAttributesAndMissingValues() {
        var employeeJSON = ["id": 100, "title":  "Software Engineer"]
        // serialize from json
        let employee:Employee = self.serializer.fromJSON(employeeJSON, to: Employee.self)
        
        // assert construction has succeeded and missing values are nil
        XCTAssertTrue(employee.id == 100)
        XCTAssertTrue(employee.firstname == nil)
        XCTAssertTrue(employee.lastname == nil)
        XCTAssertTrue(employee.title == "Software Engineer")
        XCTAssertTrue(employee.salary == nil)
        XCTAssertTrue(employee.married == nil)
        XCTAssertTrue(employee.weight == nil)
    }
    
    func testObjectModelToJSONWithPrimitiveAttributesAndMissingValues() {
        // construct object
        let employee = Employee()
        employee.id = 100
        employee.title = "Software Engineer"
        
        // serialize to json
        let json = self.serializer.toJSON(employee)
        
        // assert json dictionary has been populated
        XCTAssertTrue(json["id"] as? Int == 100)
        XCTAssertTrue(json["firstname"] == nil)
        XCTAssertTrue(json["lastname"] == nil)
        XCTAssertTrue(json["title"] as? String == "Software Engineer")
        XCTAssertTrue(json["salary"]  == nil)
        XCTAssertTrue(json["married"] == nil)
        XCTAssertTrue(json["weight"] == nil)
    }
    
    func testOneToOneRelationshipFromJSON() {
        var addressJSON = ["street": "Buchanan Street", "poBox": 123, "city": "Glasgow", "country": "UK"]
        var employeeJSON = ["firstname": "John", "address": addressJSON]
        
        // serialize from json
        let employee:Employee = self.serializer.fromJSON(employeeJSON, to: Employee.self)
        
        // assert construction has succeeded
        XCTAssertTrue(employee.firstname == "John")
        // asssert relationship has succeeded
        XCTAssertTrue(employee.address?.street == "Buchanan Street")
        XCTAssertTrue(employee.address?.poBox == 123)
        XCTAssertTrue(employee.address?.city == "Glasgow")
        XCTAssertTrue(employee.address?.country == "UK")
    }
    
    func testOneToOneRelationshipToJSON() {
        // construct objects
        let address = Address()
        address.street = "Buchanan Street"
        address.poBox = 123
        address.city = "Glasgow"
        address.country = "UK"
        
        let employee = Employee()
        employee.firstname = "John"
        // assign relationship
        employee.address = address
        
        // serialize to json
        let json = self.serializer.toJSON(employee)

        // assert construction has succeeded
        XCTAssertTrue(json["firstname"] as String == "John")
        // asssert relationship has succeeded
        let addressJSON = json["address"] as [String: AnyObject]
        XCTAssertTrue(addressJSON["street"] as String == "Buchanan Street")
        XCTAssertTrue(addressJSON["poBox"] as Int == 123)
        XCTAssertTrue(addressJSON["city"] as String == "Glasgow")
        XCTAssertTrue(addressJSON["country"] as String == "UK")
    }
    
    func testOneToManyRelationshipFromJSON() {
       // construct objects
        var employeeAJSON = ["id": 100, "firstname": "John"]
        var employeeBJSON = ["id": 101, "firstname": "Maria"]
        
        var teamJSON = ["name": "AeroGear", "employees": [employeeAJSON, employeeBJSON]]
        
        // serialize from json
        let team:Team = self.serializer.fromJSON(teamJSON, to: Team.self)
        
        // assert construction has succeeded
        XCTAssertTrue(team.name == "AeroGear")
        // asssert one-to-many relationship has succeeded
        XCTAssertTrue(team.employees?.count == 2)
        
        // verify each object
        let employeeA = team.employees?[0]
        XCTAssertTrue(employeeA?.id == 100)
        XCTAssertTrue(employeeA?.firstname == "John")
        
        let employeeB = team.employees?[1]
        XCTAssertTrue(employeeB?.id == 101)
        XCTAssertTrue(employeeB?.firstname == "Maria")
    }
    
    func testOneToManyRelationshipToJSON() {
        // construct objects
        let employeeA = Employee()
        employeeA.id = 100
        employeeA.firstname = "John"
        
        let employeeB = Employee()
        employeeB.id = 101
        employeeB.firstname = "Maria"
        
        let team = Team()
        team.name = "AeroGear"
        // assign relationship
        team.employees = [employeeA, employeeB]
        
        // serialize to json
        let json = self.serializer.toJSON(team)
        
        // assert construction has succeeded
        XCTAssertTrue(json["name"] as String == "AeroGear")
        // asssert relationship has succeeded
        let employeesJSON = json["employees"] as [[String: AnyObject]]

        let employeeAJSON = employeesJSON[0] as [String: AnyObject]
        XCTAssertTrue(employeeAJSON["id"] as Int == 100)
        XCTAssertTrue(employeeAJSON["firstname"] as String == "John")

        let employeeBJSON = employeesJSON[1] as [String: AnyObject]
        XCTAssertTrue(employeeBJSON["id"] as Int == 101)
        XCTAssertTrue(employeeBJSON["firstname"] as String == "Maria")
    }
}
