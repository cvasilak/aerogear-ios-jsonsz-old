//
//  AeroGearJsonSZTests.swift
//  AeroGearJsonSZTests
//
//  Created by Christos Vasilakis on 11/4/14.
//  Copyright (c) 2014 AeroGear. All rights reserved.
//

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
        
        //let serializer = JsonSZ()
        
        let gist:Gist = self.serializer.fromJSON(json, to: Gist.self)
        
    }
    
    func testObjectModelToJsonWithSimplePrimitiveAttibutesObject() {
        let name = Name()
        name.firstname = "corinne"
        name.lastname = "krych"
        
        let nameJson = self.serializer.toJSON(name)
        println(":::::::::::::\(nameJson)")
    }
    
    func testJsonToObjectModelWithSimplePrimitivettributes() {
        var json: [String: String] = ["first_name" : "Corinne", "last" : "krych"]
        let name:Name = self.serializer.fromJSON(json, to: Name.self)
        println(":::::::::::::\(name)")
        let obj = self.serializer.toJSON(name)
        println(":::::::::::::\(obj)")
    }
//    func testOneToOneRelationship() {
//        let corinne = Buddy()
//        corinne.name = Name()
//        corinne.name?.firstname = "Corinne"
//        corinne.name?.lastname = "Krych"
//        //corinne.friends = []
//        let serializer = JsonSZ()
//        
//        let buddyString = serializer.toJSON(corinne)
//        println("\(buddyString)")
//    }
}
