import Alamofire

public protocol WeatherService {
    func getTemperature() async throws -> Int
}

enum BaseUrl :String {
    case realapi = "https://api.openweathermap.org/data/2.5/weather"
    case mockapi = "https://assign5b.herokuapp.com/data/2.5/weather"
}

class WeatherServiceImpl: WeatherService {

    
    // let url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=1900765e0a715901f579ab8c62df9610"

    // let url = "https://assign5b.herokuapp.com/data/2.5/weather"

    private let baseUrl: BaseUrl
    private let url: String
    
    public init(baseUrl: BaseUrl? = nil) {
        self.baseUrl = baseUrl ?? .mockapi
        if self.baseUrl == .mockapi {
            url = "https://assign5b.herokuapp.com/data/2.5/weather"
        }
        else {            
            url = "https://api.openweathermap.org/data/2.5/weather?q=corvallis&units=imperial&appid=1900765e0a715901f579ab8c62df9610"
        }
    }

    func getTemperature() async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get).validate(statusCode: 200..<300).responseDecodable(of: Weather.self) { response in
                switch response.result {
                case let .success(weather):
                    let temperature = weather.main.temp
                    let temperatureAsInteger = Int(temperature)
                    continuation.resume(with: .success(temperatureAsInteger))

                case let .failure(error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
}

public struct Weather: Decodable {
    let main: Main

    struct Main: Decodable {
        let temp: Double
    }
}
