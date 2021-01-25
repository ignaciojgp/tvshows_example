//
//  APIServiceTest.swift
//  tv showsTests
//
//  Created by Ignacio J Gonzalez Pérez on 23/01/21.
//

import XCTest
import tv_shows

class HelpersTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetShows() throws {
        
        let promise = expectation(description: "Wait for async response")
        
        let service = RemoteDataHelper()
        
        service.getShowsList { (list, error) in
            
            XCTAssertNotNil(list)
            XCTAssertGreaterThanOrEqual(list!.count, 0)
            promise.fulfill()

        }
        
        wait(for: [promise], timeout: 10)
    }
    
    func testGetLocal(){
       
        //  must have an empty list
        var list = Resolver.shared.localDataHelper.getEntityList(name: .tvShow)

        XCTAssertNotNil(list)
        XCTAssertEqual(list!.count, 0)
        
        
        // sets two instances
        let instance1 = Resolver.shared.localDataHelper.createObject(name: .tvShow)
        instance1.setValue(1, forKey: "id")
        instance1.setValue("name test 1", forKey: "name")
        instance1.setValue("summary 2", forKey: "summary")
        XCTAssertNotNil(instance1)

        let instance2 = Resolver.shared.localDataHelper.createObject(name: .tvShow)
        instance2.setValue(2, forKey: "id")
        instance2.setValue("name test 2", forKey: "name")
        instance2.setValue("summary 2", forKey: "summary")

        XCTAssertNotNil(instance2)

        // save on disk
        do {
            try Resolver.shared.localDataHelper.save()
        } catch  {
            print("error")
        }
        
        
        //check if lists get two objects
        list = Resolver.shared.localDataHelper.getEntityList(name: .tvShow)
        XCTAssertNotNil(list)
        XCTAssertEqual(list!.count, 2)
        
        
        //retrieve some object by id
        let sameObject = Resolver.shared.localDataHelper.getEntity(name: .tvShow, by: 2)
        XCTAssertNotNil(sameObject)
        

        //delete one object by id
        let deleted = Resolver.shared.localDataHelper.deleteEntity(name: .tvShow, by: 2)
        XCTAssertEqual(deleted, 1)
        
        
        list = Resolver.shared.localDataHelper.getEntityList(name: .tvShow)
        XCTAssertNotNil(list)
        XCTAssertEqual(list!.count, 1)
        
        
        //clear all data
        let deletedRows = Resolver.shared.localDataHelper.deleteAll(name: .tvShow)
        
        XCTAssertGreaterThanOrEqual(deletedRows, 0)
        list = Resolver.shared.localDataHelper.getEntityList(name: .tvShow)
        XCTAssertNotNil(list)
        XCTAssertEqual(list!.count, 0)
        
        //Save the database to be clean 
        // save on disk
        do {
            try Resolver.shared.localDataHelper.save()
        } catch  {
            print("error")
        }
        
    }
    

    func testPerformanceExample() throws {
        self.measure {
        }
    }

}
