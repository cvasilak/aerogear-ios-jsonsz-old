//
//  Gist.swift
//  AeroGearJsonSZ
//
//  Created by Christos Vasilakis on 11/4/14.
//  Copyright (c) 2014 AeroGear. All rights reserved.
//

import Foundation
import AeroGearJsonSZ

/*
{
  "id": "b55f515be0b1d40aba01",
  "created_at": "2014-10-30T09:51:24Z",
  "updated_at": "2014-10-30T09:51:24Z",
  "public": true,
  "description": "a test gist",
  "url": "https://api.github.com/gists/c5af515be0b1d40aba01",
  "files": [
    {
      "filename": "foo.diff",
      "type": "text/plain",
      "size": 7308
    },
    {
      "filename": "bar.diff",
      "type": "text/plain",
      "size": 7308
    }
  ],
  "owner": {
    "id": 1,
    "login": "auser",
    "repos_url": "https://api.github.com/users/auser/repos",
    "site_admin": false
  }
}
*/
class Gist: JSONSerializable, Printable {
    
    class File: JSONSerializable, Printable {
        var filename: String?
        var type: String?
        var size: Int?
        
       required init() {}
        
        class func serialize(source: JsonSZ, object: File) {
            object.filename <= source["filename"]
            object.type <= source["type"]
            object.size <= source["size"]
        }
        
        var description: String {
            get {
                return "filename: \(filename) \ntype:\(type) \nsize: \(size)\n"
            }
        }
    }
    
    var id: String?
    var createdAt: String?
    var updatedAt: String?
    var isPublic: Bool?
    var descr: String?
    var url: String?
    var files:[File]?
    
    required init() {        
    }
    
    class func serialize(source: JsonSZ, object: Gist) {
            object.id <= source["id"]
            object.createdAt <= source["created_at"]
            object.updatedAt <= source["updated_at"]
            object.isPublic <= source["public"]
            object.descr  <= source["description"]
            object.url  <= source["url"]
            object.files <= source["files"]
    }
    
    var description: String {
        get {
            return "id: \(id) \ncreatedAt:\(createdAt) \nupdatedAt: \(updatedAt)\nisPublic:\(isPublic) \ndescription: \(descr)\niurl:\(url) \nfiles: \(files)"
        }
    }
}


