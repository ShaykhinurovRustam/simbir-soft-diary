import Foundation

class CalendarHelper {
	static let shared = CalendarHelper()
	var calendar = Calendar.current

	func plusMonth(date: Date) -> Date {
		return calendar.date(byAdding: .month, value: 1, to: date)!
	}

	func minusMonth(date: Date) -> Date {
		return calendar.date(byAdding: .month, value: -1, to: date)!
	}

	func plusWeek(date: Date) -> Date {
		return calendar.date(byAdding: .day, value: 7, to: date)!
	}

	func minusWeek(date: Date) -> Date {
		return calendar.date(byAdding: .day, value: -7, to: date)!
	}

	func monthNumber(date: Date) -> Int {
		return calendar.component(.month, from: date)
	}

	func monthString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.dateFormat = "LLLL"
		return dateFormatter.string(from: date).capitalized
	}

	func yearString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		return dateFormatter.string(from: date)
	}

	func timeString(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale(identifier: "ru_RU")
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}

	func formatHour(hour: Int) -> String {
		return String(format: "%02d:%02d", hour, 0)
	}

	func daysInMonth(date: Date) -> Int {
		let range = calendar.range(of: .day, in: .month, for: date)!
		return range.count
	}

	func dayOfMonth(date: Date) -> Int {
		let components = calendar.dateComponents([.day], from: date)
		return components.day!
	}

	func firstOfMonth(date: Date) -> Date {
		let components = calendar.dateComponents([.year, .month, .hour, .minute], from: date)
		return calendar.date(from: components)!
	}

	func weekDay(date: Date) -> Int {
		let components = calendar.dateComponents([.weekday], from: date)
		return components.weekday! - 1
	}

	func addDays(date: Date, days: Int) -> Date {
		return calendar.date(byAdding: .day, value: days, to: date)!
	}

	func sundayForDate(date: Date) -> Date {
		var current = date
		let oneWeekAgo = addDays(date: current, days: -7)

		while current > oneWeekAgo {
			let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
			if currentWeekDay == 1 {
				return addDays(date: current, days: 1)
			}
			current = addDays(date: current, days: -1)
		}
		return current
	}

	func hourFromDate(date: Date) -> Int {
		let components = calendar.dateComponents([.hour], from: date)
		return components.hour!
	}
}
