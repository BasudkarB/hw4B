
import XCTest
@testable import MyLibrary

class WeatherIntegrationTests: XCTestCase {
    
    func test1() async {
        
        let myLibrary = MyLibrary(weatherService: WeatherServiceImpl(baseUrl: .mockapi))

        
        //When
        let isLuckyNumber = await myLibrary.isLucky(0)
        
        //Then
        XCTAssertNotNil(isLuckyNumber)        
    }
 
    
}
