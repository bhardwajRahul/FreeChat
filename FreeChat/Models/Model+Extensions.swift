//
//  Model+Extensions.swift
//  Chats
//
//  Created by Peter Sugihara on 8/8/23.
//

import Foundation

extension Model {
  var url: URL? {
    if bookmark == nil { return nil }
    var stale = false
    do {
      let res = try URL(resolvingBookmarkData: bookmark!, options: .withSecurityScope, bookmarkDataIsStale: &stale)

      guard res.startAccessingSecurityScopedResource() else {
        print("error starting security scoped access")
        return nil
      }
      
      if stale {
        print("renewing stale bookmark", res)
        bookmark = try res.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess])
      }

      return res
    } catch (let error){
      print("Error resolving model bookmark", error.localizedDescription)
      return nil
    }
  }
  
  public override func willSave() {
    super.willSave()
    
    if !isDeleted, changedValues()["updatedAt"] == nil {
      self.setValue(Date(), forKey: "updatedAt")
    }
  }
}