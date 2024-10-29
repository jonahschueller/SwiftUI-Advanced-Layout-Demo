import Foundation

struct Photo: Identifiable, Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let downloads: Int
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let exif: Exif
    let location: Location
    let urls: Urls
    let links: Links
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case downloads
        case likes
        case likedByUser = "liked_by_user"
        case description
        case exif
        case location
        case urls
        case links
        case user
    }
}

struct Exif: Codable {
    let make: String
    let model: String
    let exposureTime: String
    let aperture: String
    let focalLength: String
    let iso: Int

    enum CodingKeys: String, CodingKey {
        case make
        case model
        case exposureTime = "exposure_time"
        case aperture
        case focalLength = "focal_length"
        case iso
    }
}

struct Location: Codable {
    let name: String?
    let city: String?
    let country: String?
    let position: Position
}

struct Position: Codable {
    let latitude: Double
    let longitude: Double
}

struct Urls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Links: Codable {
    let `self`: String
    let html: String
    let download: String
    let downloadLocation: String

    enum CodingKeys: String, CodingKey {
        case `self`
        case html
        case download
        case downloadLocation = "download_location"
    }
}

struct User: Codable {
    let id: String
    let updatedAt: String
    let username: String
    let name: String
    let portfolioUrl: String?
    let bio: String?
    let location: String?
    let totalLikes: Int
    let totalPhotos: Int
    let totalCollections: Int
    let instagramUsername: String?
    let twitterUsername: String?
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case username
        case name
        case portfolioUrl = "portfolio_url"
        case bio
        case location
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case links
    }
}

struct UserLinks: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
}
