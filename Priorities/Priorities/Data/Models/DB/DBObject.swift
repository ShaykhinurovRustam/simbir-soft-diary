import Foundation
import RealmSwift

class DBObject: Object {
	@Persisted var name: String = ""
	@Persisted var descripton: String?
	@Persisted var startDate: Date
	@Persisted var endDate: Date

	convenience init(name: String, descripton: String?, startDate: Date, endDate: Date) {
		self.init()
		self.name = name
		self.descripton = descripton
		self.startDate = startDate
		self.endDate = endDate
	}
}
