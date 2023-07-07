import UIKit

class DailyCell: UITableViewCell {
	@IBOutlet var time: UILabel!
	@IBOutlet var eventName: UILabel!
	var event: DBObject?
}
