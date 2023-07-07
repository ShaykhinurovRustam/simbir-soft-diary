import Foundation

protocol CalendarViewModelProtocol {
	var days: [CalendarDay] { get set }
	var hours: [Int] { get set }
	var selectedDisplaying: Display { get set }
	var selectedDate: Date { get set }

	func setSelectedDate(date: Date)
	func getSelectedDate() -> Date
	func setSelectedDisplaying(display: Display)

	func plusMonth(date: Date) -> Date
	func minusMonth(date: Date) -> Date
	func plusWeek(date: Date) -> Date
	func minusWeek(date: Date) -> Date

	func monthNumber(date: Date) -> Int
	func monthString(date: Date) -> String
	func thisMonthString() -> String
	func yearString(date: Date) -> String
	func thisYearString() -> String
	func timeString(date: Date) -> String

	func daysInMonth(date: Date) -> Int
	func dayOfMonth(date: Date) -> Int
	func firstOfMonth(date: Date) -> Date

	func weekDay(date: Date) -> Int
	func addDays(date: Date, days: Int) -> Date
	func addDay(day: String, month: Month, date: Date)
	func sundayForDate(date: Date) -> Date

	func initHours()
	func formatHour(hour: Int) -> String
	func hourFromDate(date: Date) -> Int
}

class CalendarViewModel: CalendarViewModelProtocol {
	private let calendarHelper = CalendarHelper.shared

	var days: [CalendarDay] = []
	var hours: [Int] = []
	var selectedDate = Date()
	var selectedDisplaying: Display = .monthly

	func setSelectedDate(date: Date) {
		selectedDate = date
	}

	func getSelectedDate() -> Date {
		let components = calendarHelper.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
		return calendarHelper.calendar.date(from: components)!
	}

	func setSelectedDisplaying(display: Display) {
		selectedDisplaying = display
	}

	func plusMonth(date: Date) -> Date {
		calendarHelper.plusMonth(date: date)
	}

	func minusMonth(date: Date) -> Date {
		calendarHelper.minusMonth(date: date)
	}

	func plusWeek(date: Date) -> Date {
		calendarHelper.plusWeek(date: date)
	}

	func minusWeek(date: Date) -> Date {
		calendarHelper.minusWeek(date: date)
	}

	func monthNumber(date: Date) -> Int {
		calendarHelper.monthNumber(date: date)
	}

	func monthString(date: Date) -> String {
		calendarHelper.monthString(date: selectedDate)
	}

	func thisMonthString() -> String {
		monthString(date: selectedDate)
	}

	func yearString(date: Date) -> String {
		calendarHelper.yearString(date: date)
	}

	func thisYearString() -> String {
		yearString(date: selectedDate)
	}

	func timeString(date: Date) -> String {
		calendarHelper.timeString(date: date)
	}

	func daysInMonth(date: Date) -> Int {
		calendarHelper.daysInMonth(date: date)
	}

	func dayOfMonth(date: Date) -> Int {
		calendarHelper.dayOfMonth(date: date)
	}

	func firstOfMonth(date: Date) -> Date {
		calendarHelper.firstOfMonth(date: date)
	}

	func weekDay(date: Date) -> Int {
		calendarHelper.weekDay(date: date)
	}

	func addDays(date: Date, days: Int) -> Date {
		calendarHelper.addDays(date: date, days: days)
	}

	func sundayForDate(date: Date) -> Date {
		calendarHelper.sundayForDate(date: date)
	}

	func addDay(day: String, month: Month, date: Date) {
		let calendarDay = setupCalendarDay(day: day, month: month, date: date)
		days.append(calendarDay)
	}

	private func setupCalendarDay(day: String, month: Month, date: Date) -> CalendarDay {
		let calendarDay = CalendarDay()
		calendarDay.day = day
		calendarDay.month = month
		calendarDay.date = date
		return calendarDay
	}

	func initHours() {
		for hour in 0...23 {
			hours.append(hour)
		}
	}

	func formatHour(hour: Int) -> String {
		return calendarHelper.formatHour(hour: hour)
	}

	func hourFromDate(date: Date) -> Int {
		return calendarHelper.hourFromDate(date: date)
	}
}
