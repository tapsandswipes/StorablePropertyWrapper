import XCTest
import Foundation
@testable import StorablePropertyWrapper


final class StorablePropertyWrapperTests: XCTestCase {
        
    @Storable(key: "TestString", default: "", store: UserDefaults.standard)
    var string: String

    @Storable(key: "TestDate", default: nil, store: UserDefaults.standard)
    var date: Date?

    @Storable(key: "TestCodable", default: nil, store: UserDefaults.standard)
    var codableStruct: CodableStruct?
    
    @Storable(key: "TestArray", default: nil, store: UserDefaults.standard)
    var array: Array<String>?

    @Storable(key: "TestDictionary", default: nil, store: UserDefaults.standard)
    var dict: Dictionary<String, Date>?

    @Storable(key: "TestSet", default: nil, store: UserDefaults.standard)
    var set: Set<String>?

    @Storable(key: "TestURL", default: nil, store: UserDefaults.standard)
    var url: URL?

    @Storable(key: "TestAURL", default: URL(string: "www.example.com")!, store: UserDefaults.standard)
    var aUrl: URL

    @Storable(key: "TestEnum", default: .value1, store: UserDefaults.standard)
    var theEnum: TestEnum
    
    @Storable(key: "TestString2", default: nil, store: UserDefaults.standard)
    var string2: String?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: "TestString")
        UserDefaults.standard.removeObject(forKey: "TestDate")
        UserDefaults.standard.removeObject(forKey: "TestCodable")
        UserDefaults.standard.removeObject(forKey: "TestArray")
        UserDefaults.standard.removeObject(forKey: "TestDictionary")
        UserDefaults.standard.removeObject(forKey: "TestSet")
        UserDefaults.standard.removeObject(forKey: "TestURL")
        UserDefaults.standard.removeObject(forKey: "TestAURL")
        UserDefaults.standard.removeObject(forKey: "TestEnum")
    }

    func testString() throws {
        XCTAssertEqual(string, "")
        
        string = "Test"
        XCTAssertEqual(string, "Test")
        XCTAssertNotNil($string.storedValue())
    }

    func testDate() throws {
        XCTAssertNil(date)
        
        let now = Date()
        date = now
        
        XCTAssertEqual(date, now)
        XCTAssertNotNil($date.storedValue()!)
    }
    
    func testArray() throws {
        XCTAssertNil(array)

        let a = ["A", "B"]
        array = a
        
        XCTAssertEqual(array, a)
        XCTAssertNotNil($array.storedValue()!)
    }
    
    func testDictionary() {
        XCTAssertNil(dict)

        let d: Dictionary<String, Date> = ["A": Date(timeIntervalSince1970: 0), "B": Date()]
        dict = d
        
        XCTAssertEqual(dict, d)
        XCTAssertNotNil($dict.storedValue()!)
    }
    
    func testSet() throws {
        XCTAssertNil(set)
        
        let s: Set<String> = ["A", "B"]
        set = s
        
        XCTAssertEqual(set, s)
        XCTAssertNotNil($set.storedValue()!)
    }
    
    func testURL() {
        XCTAssertNil(url)
        
        let u = URL(string: "http://www.tapsandswipes.com/")
        url = u
        
        XCTAssertEqual(url, u)
        XCTAssertNotNil($url.storedValue()!)
    }
    
    func testCodable() {
        XCTAssertNil(codableStruct)
        
        let now = Date()
        let cs = CodableStruct(name: "hi", date: now)
        codableStruct = cs
        
        XCTAssertEqual(codableStruct, cs)
        XCTAssertEqual(codableStruct?.name, "hi")
        XCTAssertEqual(codableStruct?.date, now)
        XCTAssertNotNil($codableStruct.storedValue()!)
    }
    
    func testNotNilURL() {
        XCTAssertEqual(aUrl, URL(string: "www.example.com")!)
        
        let u: URL = URL(string: "www.tapsandswipes.com")!
        aUrl = u
        XCTAssertEqual(aUrl, u)
        XCTAssertNotNil($aUrl.storedValue())
        
        $aUrl.remove()
        XCTAssertEqual(aUrl, URL(string: "www.example.com")!)
    }
    
    func testEnum() {
        XCTAssertEqual(theEnum, .value1)

        theEnum = .value2
        XCTAssertEqual(theEnum, .value2)
    }
    
    func testNil() {
        date = Date()
        XCTAssertNotNil($date.storedValue()!)

        date = nil
        XCTAssertNil(date)
    }
    
    func testRemoveKeepDefault() {
        string = "Test"
        XCTAssertNotNil($string.storedValue())
        
        $string.remove()
        XCTAssertEqual(string, $string.default)
        XCTAssertNotNil($string.storedValue())
    }

    func testRemove() {
        date = Date()
        
        XCTAssertNotNil($date.storedValue()!)

        $date.remove()
        XCTAssertNil(date)
        XCTAssertNil($date.storedValue()!)
    }
    
    func testNotification() {
        let expectation = XCTestExpectation(description: "notification")
        let token = NotificationCenter.default.addObserver(forName: $string2.didChangeNotification, object: nil, queue: .main) { _ in
            expectation.fulfill()
        }
        
        withExtendedLifetime(token) {
            self.string2 = "Test"
            wait(for: [expectation], timeout: 2)
        }
        
        XCTAssertEqual(self.string2, "Test")
    }    
}


struct CodableStruct: Codable, Equatable {
    let name: String
    let date: Date
}

extension CodableStruct: StorableCodableValue {}

enum TestEnum: String {
    case value1
    case value2
}

extension TestEnum: StorableValue {}

extension Storable {
    /// Get the value directly from the store without going through the wrappedValue
    func storedValue() -> T.ValueToStore? {
        guard let v: T.ValueToStore = store.get(key) else { return nil }
        
        return v
    }
}
