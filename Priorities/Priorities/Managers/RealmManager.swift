import Foundation
import RealmSwift

protocol DBProvider {
	func saveObject(_ event: DBObject)
	func deleteObject(_ event: DBObject)
	func getEvents(completion: @escaping (_ events: [DBObject]?) -> Void)
}

class RealmManager: DBProvider {
	let schemaVersion: UInt64 = 3

	func saveObject(_ event: DBObject) {
		DispatchQueue.global(qos: .background).sync {
			autoreleasepool {
				do {
					let config = Realm.Configuration(schemaVersion: self.schemaVersion)
					Realm.Configuration.defaultConfiguration = config

					let realm = try Realm()
					try realm.write {
						realm.add(event)
						realm.refresh()
					}
				} catch {
					print("Error: Can't save the object")
				}
			}
		}
	}

	func deleteObject(_ event: DBObject) {
		DispatchQueue.global(qos: .background).sync {
			do {
				let config = Realm.Configuration(schemaVersion: self.schemaVersion)
				Realm.Configuration.defaultConfiguration = config
				let realm = try Realm()
				try realm.write {
					realm.delete(event)
					realm.refresh()
				}
			} catch {
				print("Error: Can't delete the object")
			}
		}
	}

	func getEvents(completion: @escaping (_ events: [DBObject]?) -> Void) {
		DispatchQueue.global(qos: .background).sync {
			do {
				let config = Realm.Configuration(schemaVersion: schemaVersion)
				Realm.Configuration.defaultConfiguration = config
				let realm = try Realm()
				let results = realm.objects(DBObject.self)
				realm.refresh()
				completion(Array(results))
			} catch {
				print("Error: Can't load events")
			}
		}
	}
}
