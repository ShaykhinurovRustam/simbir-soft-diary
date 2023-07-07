import XCTest
@testable import Priorities

final class PrioritiesTests: XCTestCase {
	var realmManager = RealmManager()

    func testAddEvent() throws {
		let event = DBObject(
			name: "new event",
			descripton: "testing event",
			startDate: Date(),
			endDate: Date()
		)
		var lastEvent: DBObject?

		realmManager.saveObject(event)
		realmManager.getEvents { events in
			lastEvent = events?.last
		}

		XCTAssertEqual(lastEvent?.name, "new event")
    }
}
