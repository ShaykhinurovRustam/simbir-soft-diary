import Foundation

extension Date {
	func formatted(with locale: Locale) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = locale
		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .medium
		
		return dateFormatter.string(from: self)
	}
}
