import Foundation
import RealmSwift

protocol EventCreateViewModelProtocol {
	var selectedDate: Date { get set }
	func saveEvent(name: String, descripton: String, startDate: Date, endDate: Date)
	func getCurrentEvent()
	func getEventCreateViewModel() -> EventCreateViewModel
}

class EventCreateViewModel: EventCreateViewModelProtocol {
	private let model: Event

	var currentEvent: DBObject?
	var selectedDate: Date

	init(model: Event, selectedDate: Date) {
		self.model = model
		self.selectedDate = selectedDate
	}

	func saveEvent(name: String, descripton: String, startDate: Date, endDate: Date) {
		let newEvent = DBObject(
			name: name,
			descripton: descripton,
			startDate: startDate,
			endDate: endDate
		)

		if let currentEvent {
			do {
				let realm = try Realm()
				try realm.write {
					currentEvent.name = newEvent.name
					currentEvent.descripton = newEvent.descripton
					currentEvent.startDate = newEvent.startDate
					currentEvent.endDate = newEvent.endDate
				}
			} catch {
				print("Error: Can't save the object: \(error)")
			}
		} else {
			model.saveEvent(newEvent)
		}
	}

	func getCurrentEvent() {
		currentEvent = model.getCurrentEvent()
	}

	func getEventCreateViewModel() -> EventCreateViewModel {
		return EventCreateViewModel(model: model.getEventModel(), selectedDate: selectedDate)
	}
}
