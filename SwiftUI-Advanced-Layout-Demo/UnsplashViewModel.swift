import SwiftUI

@Observable
class UnsplashViewModel {
    
    var photos: [Photo] = []
    
    var isFetching: Bool = false
    
    var hasError: Bool = false
    
    init() {
        fetchNextBatch()
    }
    
    func fetchNextBatch() {
        Task {
            do {
                isFetching = true
                
                let response = try await UnsplashAPI.shared.fetchRandomPhoto()
                
                print("Loaded \(response.count) photos")
                
                self.photos.append(contentsOf: response)
                
                hasError = false
            } catch {
                print(error )
                
                hasError = true
            }
            
            isFetching = false
        }
    }
    
}
