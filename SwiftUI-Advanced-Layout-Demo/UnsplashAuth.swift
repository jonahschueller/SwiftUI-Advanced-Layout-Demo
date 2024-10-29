struct UnsplashAuth {
    static let applicationID = "YOUR_APP_ID"
    static let accessKey = "YOUR_ACCESS_KEY"
    static let secretKey = "YOUR_SECRET_KEY"
}

enum UnsplashAuthError: Error {
    case missingCrendentials
}

func verifyCredentials() throws {
    guard UnsplashAuth.applicationID != "YOUR_APP_ID", UnsplashAuth.accessKey != "YOUR_ACCESS_KEY", UnsplashAuth.secretKey != "YOUR_SECRET_KEY" else {
        throw UnsplashAuthError.missingCrendentials
    }
}
