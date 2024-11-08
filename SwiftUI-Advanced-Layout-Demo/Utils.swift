import Foundation

extension String {
    func dateFromString() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium  // Medium style like "Nov 4, 2023"
            outputFormatter.timeStyle = .short

            let readableDate = outputFormatter.string(from: date)

            return readableDate
        } else {
            return "-"
        }
    }
}
