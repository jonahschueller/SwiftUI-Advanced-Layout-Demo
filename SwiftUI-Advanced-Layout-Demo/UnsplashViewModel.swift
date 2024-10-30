import SwiftUI

@Observable
class UnsplashViewModel {
    
    var currentPhoto: Photo? {
        return photos.first
    }
    var photos: [Photo] = []
    
    init() {
        fetchNextBatch()
    }
    
    private func fetchNextBatch() {
        Task {
            do {
                let response = try await UnsplashAPI.shared.fetchRandomPhoto()
                
                print("Loaded \(response.count) photos")
                
                self.photos.append(contentsOf: response)
            } catch {
                print(error )
            }
        }
    }
    
    func nextPhoto() {
        if (photos.count < 3) {
            fetchNextBatch()
        }
        
        photos.removeFirst()
    }
    
}
