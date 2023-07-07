import Foundation

protocol DiaryViewModelProtocol {
	var events: [DBObject] { get set }
	var selectedDate: Date { get set }
	func numberOfEvents() -> Int
	func getEvents(completion: @escaping (_ hasEventsUpdated: Bool) -> Void)
	func event(at index: Int) -> DBObject
	func getEvents() -> [DBObject]
	func getEventCreateViewModel() -> EventCreateViewModelProtocol
	func getEventCheckViewModel(event: DBObject?) -> EventCheckViewModel
	func getEventsForDateAndTime(date: Date, hour: Int) -> [DBObject]
}

class DiaryViewModel: DiaryViewModelProtocol {
	private let model: Event
	var events: [DBObject] = []
	var selectedDate: Date

	init(model: Event, selectedDate: Date) {
		self.model = model
		self.selectedDate = selectedDate
	}

	func setSelectedDate(date: Date) {
		selectedDate = date
	}

	func numberOfEvents() -> Int {
		events.count
	}

	func getEvents(completion: @escaping (_ hasEventsUpdated: Bool) -> Void) {
		model.getEvents { [weak self] events in
			guard
				let self,
				let events
			else { return }

			self.events = events
			completion(true)
		}
	}

	func event(at index: Int) -> DBObject {
		events[index]
	}

	func getEvents() -> [DBObject] {
		events
	}

	func getEventsForDateAndTime(date: Date, hour: Int) -> [DBObject] {
		var daysEvents: [DBObject] = []
		for event in events where Calendar.current.isDate(event.startDate, inSameDayAs: date) {
			let eventHour = CalendarHelper.shared.hourFromDate(date: event.startDate)
			if eventHour == hour {
				daysEvents.append(event)
			}
		}
		return daysEvents
	}

	func getEventCreateViewModel() -> EventCreateViewModelProtocol {
		return EventCreateViewModel(model: model, selectedDate: selectedDate)
	}
	
	func getEventCheckViewModel(event: DBObject?) -> EventCheckViewModel {
		return EventCheckViewModel(model: model, event: event)
	}
}
