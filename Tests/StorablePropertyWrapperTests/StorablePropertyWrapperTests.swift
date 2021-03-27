import XCTest
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

    @Storable(key: "TestURL", default: nil, store: UserDefaults.standard)
    var url: URL?

    @Storable(key: "TestTheURL", default: URL(string: "www.example.com")!, store: UserDefaults.standard)
    var theUrl: URL

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
        UserDefaults.standard.removeObject(forKey: "TestURL")
        UserDefaults.standard.removeObject(forKey: "TestTheURL")
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
        XCTAssertNotNil($date.storedValue())
    }
    
    func testArray() throws {
        XCTAssertNil(array)

        let a = ["A", "B"]
        array = a
        
        XCTAssertEqual(array, a)
        XCTAssertNotNil($array.storedValue())
    }
    
    func testDictionary() {
        XCTAssertNil(dict)

        let d: Dictionary<String, Date> = ["A": Date(timeIntervalSince1970: 0), "B": Date()]
        dict = d
        
        XCTAssertEqual(dict, d)
        XCTAssertNotNil($dict.storedValue())
    }
    
    func testURL() {
        XCTAssertNil(url)
        
        let u = URL(string: "http://www.tapsandswipes.com/")
        url = u
        
        XCTAssertEqual(url, u)
        XCTAssertNotNil($url.storedValue())
    }
    
    func testCodable() {
        XCTAssertNil(codableStruct)
        
        let now = Date()
        let cs = CodableStruct(name: "hi", date: now)
        codableStruct = cs
        
        XCTAssertEqual(codableStruct, cs)
        XCTAssertEqual(codableStruct?.name, "hi")
        XCTAssertEqual(codableStruct?.date, now)
        XCTAssertNotNil($codableStruct.storedValue())
    }
    
    func testNotNilURL() {
        XCTAssertEqual(theUrl, URL(string: "www.example.com")!)
        
        let u: URL = URL(string: "www.tapsandswipes.com")!
        theUrl = u
        XCTAssertEqual(theUrl, u)
        XCTAssertNotNil($theUrl.storedValue())
        
        $theUrl.remove()
        XCTAssertEqual(theUrl, URL(string: "www.example.com")!)
    }
    
    func testNil() {
        date = Date()
        XCTAssertNotNil($date.storedValue())

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
        
        XCTAssertNotNil($date.storedValue())

        $date.remove()
        XCTAssertNil(date)
        XCTAssertNil($date.storedValue())
    }
    
    static var allTests = [
        ("testString", testString),
        ("testDate", testDate),
        ("testCodable", testCodable),
    ]
}


struct CodableStruct: Codable, Equatable {
    let name: String
    let date: Date
}

extension CodableStruct: StorableCodableValue {}
