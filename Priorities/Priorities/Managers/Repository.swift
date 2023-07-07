import Foundation
import RealmSwift

protocol RepositoryProtocol {
	func getEvents(completion: @escaping (_ events: [DBObject]?) -> Void)
	func saveEvent(_ event: DBObject)
	func deleteEvent(_ event: DBObject)
	func setCurrentEvent(_ event: DBObject?)
	func getCurrentEvent() -> DBObject?
}

class Repository: RepositoryProtocol {
	private let dbProvider: DBProvider
	private var currentEvent: DBObject?

	init(realmManager: RealmManager = RealmManager()) {
		self.dbProvider = realmManager
	}

	func getEvents(completion: @escaping ([DBObject]?) -> Void) {
		dbProvider.getEvents { (events) in
			completion(events)
		}
	}

	func saveEvent(_ event: DBObject) {
		dbProvider.saveObject(event)
	}

	func deleteEvent(_ event: DBObject) {
		dbProvider.deleteObject(event)
	}

	func setCurrentEvent(_ event: DBObject?) {
		currentEvent = event
	}

	func getCurrentEvent() -> DBObject? {
		return currentEvent
	}
}
