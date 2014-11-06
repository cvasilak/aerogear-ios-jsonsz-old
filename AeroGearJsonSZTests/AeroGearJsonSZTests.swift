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
    let serializer = JsonSZ()
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParseFromJSON() {
        let json: String = "{\n" +
            "    \"id\": \"b55f515be0b1d40aba01\",\n" +
            "    \"created_at\": \"2014-10-30T09:51:24Z\",\n" +
            "    \"updated_at\": \"2014-10-30T09:51:24Z\",\n" +
            "    \"public\": true,\n" +
            "    \"description\": \"a test gist\",\n" +
            "    \"url\": \"https://api.github.com/gists/c5af515be0b1d40aba01\",\n" +
            "    \"files\": [\n" +
            "        {\n" +
            "            \"filename\": \"foo.diff\",\n" +
            "            \"type\": \"text/plain\",\n" +
            "            \"size\": 1234\n" +
            "        },\n" +
            "        {\n" +
            "            \"filename\": \"bar.diff\",\n" +
            "            \"type\": \"text/plain\",\n" +
            "            \"size\": 4321\n" +
            "        }\n" +
            "    ],\n" +
            "    \"owner\": {\n" +
            "        \"id\": 1,\n" +
            "        \"login\": \"auser\",\n" +
            "        \"repos_url\": \"https://api.github.com/users/auser/repos\",\n" +
            "        \"site_admin\": false\n" +
            "    }\n" +
        "}";
        
        let gist:Gist = self.serializer.fromJSON(json, to: Gist.self)
        
    }
    
    func testJsonToObjectModelWithOptionalSimplePrimitivettributes() {
        var json: [String: AnyObject] = ["first_name" : "lucy", "last" : "smith"]
        let name:Name = self.serializer.fromJSON(json, to: Name.self)
        XCTAssert(name.description == "firstname: lucy,lastname: smith", "from json to object model for simple json")
        
        let obj = self.serializer.toJSON(name)
        //TODO make it pass
        //XCTAssert(obj.description == "firstname: lucy, lastname: smith", "")
    }

    func testOneToOneRelationshipFromJson() {
        var nameJson: [String: AnyObject] = ["first_name": "lucy", "last": "smith"]
        var buddyJson: [String: AnyObject] = ["name": nameJson]
        
        let buddy = self.serializer.fromJSON(buddyJson, to: Buddy.self)
        XCTAssert(buddy.description == "name: firstname: lucy,lastname: smith", "from json to object model for one to one relationship")
    }
    
    func testOptionalMissingLastName() {
        var nameJson: [String: AnyObject] = ["first_name": "lucy"]
        
        let name = self.serializer.fromJSON(nameJson, to: Name.self)
        XCTAssert(name.description == "firstname: lucy,lastname: default", "from json to object model with optional values missing")
        println(">>>\(name)")
    }
    
    func testOptionalMissingLastNameForBuddy() {
        var nameJson: [String: AnyObject] = ["first_name": "lucy"]
        var buddyJson: [String: AnyObject] = ["name": nameJson]
        
        let buddy = self.serializer.fromJSON(buddyJson, to: Buddy.self)
        XCTAssert(buddy.description == "name: firstname: lucy,lastname: default", "from json to object model with optional values missing")
    }
    
    func testOptionalMissingNameForBuddy() {
        var buddyJson: [String: AnyObject] = [:]
        
        let buddy = self.serializer.fromJSON(buddyJson, to: Buddy.self)
        XCTAssert(buddy.description == "", "from json to object model with optional values missing")
    }
    
    func testOneToOneRelationshipToJson() {
        let lucy = Buddy()
        lucy.name = Name()
        lucy.name?.firstname = "lucy"
        lucy.name?.lastname = "smith"
        let serializer = JsonSZ()
        
        let buddy = serializer.toJSON(lucy)
        //TODO make it pass
        //XCTAssert(buddy.description == "...", "")
    }
    
    func testOneToManyRelationshipFromJson() {
        var nameJson: [String: AnyObject] = ["first_name": "lucy", "last": "smith"]
        var buddyJson: [String: AnyObject] = ["name": nameJson]
        var teamJson: [String: AnyObject] = ["team-name": "slackers", "team-members": [buddyJson]]
        
        let team = self.serializer.fromJSON(teamJson, to: Team.self)
        XCTAssert(team.description == "team-name: slackers, team-members: [name: firstname: lucy,lastname: smith]", "from json to object model for one to many relationship")
    }
    
    func testOneToManyRelationshipToJson() {
        //TODO
    }
}
