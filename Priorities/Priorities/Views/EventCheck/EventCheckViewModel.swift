import Foundation

class EventCheckViewModel {
	private let model: Event
	var event: DBObject?

	init(model: Event, event: DBObject? = nil) {
		self.model = model
		self.event = event
	}

	func deleteEvent(_ event: DBObject) {
		model.deleteEvent(event)
	}
}
