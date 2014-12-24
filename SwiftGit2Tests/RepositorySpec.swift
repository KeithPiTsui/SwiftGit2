//
//  RepositorySpec.swift
//  RepositorySpec
//
//  Created by Matt Diephouse on 11/7/14.
//  Copyright (c) 2014 GitHub, Inc. All rights reserved.
//

import LlamaKit
import SwiftGit2
import Nimble
import Quick

class RepositorySpec: QuickSpec {
	override func spec() {
		describe("+atURL()") {
			it("should work if the repo exists") {
				let repo = Fixtures.simpleRepository
				expect(repo.directoryURL).notTo(beNil())
			}
			
			it("should fail if the repo doesn't exist") {
				let url = NSURL(fileURLWithPath: "blah")!
				let result = Repository.atURL(url)
				expect(result.error()).notTo(beNil())
			}
		}
		
		describe("-blobWithOID()") {
			it("should return the commit if it exists") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "41078396f5187daed5f673e4a13b185bbad71fba")!
				
				let result = repo.blobWithOID(oid)
				let blob = result.value()
				expect(blob).notTo(beNil())
				expect(blob?.oid).to(equal(oid))
			}
			
			it("should error if the blob doesn't exist") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")!
				
				let result = repo.blobWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
			
			it("should error if the oid doesn't point to a blob") {
				let repo = Fixtures.simpleRepository
				// This is a tree in the repository
				let oid = OID(string: "f93e3a1a1525fb5b91020da86e44810c87a2d7bc")!
				
				let result = repo.blobWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
		}
		
		describe("-commitWithOID()") {
			it("should return the commit if it exists") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "dc220a3f0c22920dab86d4a8d3a3cb7e69d6205a")!
				
				let result = repo.commitWithOID(oid)
				let commit = result.value()
				expect(commit).notTo(beNil())
				expect(commit?.oid).to(equal(oid))
			}
			
			it("should error if the commit doesn't exist") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")!
				
				let result = repo.commitWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
			
			it("should error if the oid doesn't point to a commit") {
				let repo = Fixtures.simpleRepository
				// This is a tree in the repository
				let oid = OID(string: "f93e3a1a1525fb5b91020da86e44810c87a2d7bc")!
				
				let result = repo.commitWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
		}
		
		describe("-tagWithOID()") {
// This test crashes the swift complier. :'(
//			it("should return the tag if it exists") {
//				let repo = Fixtures.simpleRepository
//				let oid = OID(string: "57943b8ee00348180ceeedc960451562750f6d33")!
//				
//				let result = repo.tagWithOID(oid)
//				let tag = result.value()
//				expect(tag).notTo(beNil())
//				expect(tag?.oid).to(equal(oid))
//			}
			
			it("should error if the tag doesn't exist") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")!
				
				let result = repo.tagWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
			
			it("should error if the oid doesn't point to a tag") {
				let repo = Fixtures.simpleRepository
				// This is a commit in the repository
				let oid = OID(string: "dc220a3f0c22920dab86d4a8d3a3cb7e69d6205a")!
				
				let result = repo.tagWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
		}
		
		describe("-treeWithOID()") {
			it("should return the tree if it exists") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "f93e3a1a1525fb5b91020da86e44810c87a2d7bc")!
				
				let result = repo.treeWithOID(oid)
				let tree = result.value()
				expect(tree).notTo(beNil())
				expect(tree?.oid).to(equal(oid))
			}
			
			it("should error if the tree doesn't exist") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")!
				
				let result = repo.treeWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
			
			it("should error if the oid doesn't point to a tree") {
				let repo = Fixtures.simpleRepository
				// This is a commit in the repository
				let oid = OID(string: "dc220a3f0c22920dab86d4a8d3a3cb7e69d6205a")!
				
				let result = repo.treeWithOID(oid)
				expect(result.error()).notTo(beNil())
			}
		}
		
		describe("-objectFromPointer()") {
			it("should work with commits") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "dc220a3f0c22920dab86d4a8d3a3cb7e69d6205a")!
				
				let pointer = PointerTo<Commit>(oid)
				let commit = repo.commitWithOID(oid).value()!
				expect(repo.objectFromPointer(pointer).value()).to(equal(commit))
			}
			
			it("should work with trees") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "f93e3a1a1525fb5b91020da86e44810c87a2d7bc")!
				
				let pointer = PointerTo<Tree>(oid)
				let tree = repo.treeWithOID(oid).value()!
				expect(repo.objectFromPointer(pointer).value()).to(equal(tree))
			}
			
			it("should work with blobs") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "41078396f5187daed5f673e4a13b185bbad71fba")!
				
				let pointer = PointerTo<Blob>(oid)
				let blob = repo.blobWithOID(oid).value()!
				expect(repo.objectFromPointer(pointer).value()).to(equal(blob))
			}
			
			it("should work with tags") {
				let repo = Fixtures.simpleRepository
				let oid = OID(string: "57943b8ee00348180ceeedc960451562750f6d33")!
				
				let pointer = PointerTo<Tag>(oid)
				let tag = repo.tagWithOID(oid).value()!
				expect(repo.objectFromPointer(pointer).value()).to(equal(tag))
			}
		}
	}
}
