import Foundation

class Event {
	private let repository: RepositoryProtocol

	init(repository: RepositoryProtocol) {
		self.repository = repository
	}

	func getEvents(completion: @escaping (_ events: [DBObject]?) -> Void) {
		repository.getEvents { events in
			completion(events)
		}
	}

	func saveEvent(_ event: DBObject) {
		repository.saveEvent(event)
	}

	func deleteEvent(_ event: DBObject) {
		repository.deleteEvent(event)
	}

	func getCurrentEvent() -> DBObject? {
		return repository.getCurrentEvent()
	}

	func setCurrentEvent(_ event: DBObject?) {
		repository.setCurrentEvent(event)
	}

	func getEventModel() -> Event {
		return Event(repository: repository)
	}
}
