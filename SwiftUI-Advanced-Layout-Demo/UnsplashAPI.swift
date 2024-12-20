import Foundation

let UNSPLASH_BASE_URL = "https://api.unsplash.com"

enum UnsplashError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidData
}

class UnsplashAPI {

    static let shared = UnsplashAPI()

    private init() {

    }

    func fetchRandomPhoto(count: Int = 15) async throws -> [Photo] {
        guard
            let url = URL(
                string:
                    "\(UNSPLASH_BASE_URL)/photos/random?count=\(count)&orientation=portrait"
            )
        else {
            throw UnsplashError.invalidURL
        }

        print("Fetching random photos from Unsplash... \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request
            .setValue(
                "Client-ID \(UnsplashAuth.accessKey)",
                forHTTPHeaderField: "Authorization"
            )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            let statusCode =
                (response as? HTTPURLResponse)?.statusCode ?? -1

            throw UnsplashError.invalidStatusCode(statusCode)
        }

        do {
            let photo = try JSONDecoder().decode([Photo].self, from: data)

            return photo
        } catch {
            print(error)
            throw UnsplashError.invalidData
        }

    }

}
