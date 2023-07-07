import UIKit

class CalendarCollectionView: UICollectionView {
	public private(set) var spacing: CGFloat = 2

	var viewModel: CalendarViewModelProtocol

	init(viewModel: CalendarViewModelProtocol) {
		self.viewModel = viewModel
		super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	}

	func setViewModel(viewModel: CalendarViewModelProtocol) {
		self.viewModel = viewModel
	}

	required init?(coder: NSCoder) {
		viewModel = CalendarViewModel()
		super.init(coder: coder)
	}

	override var intrinsicContentSize: CGSize {
		return contentSize
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
			self.invalidateIntrinsicContentSize()
		}
	}

	func setCellsView() {
		let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout
		flowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
		flowLayout?.minimumLineSpacing = spacing
		flowLayout?.minimumInteritemSpacing = spacing
	}

	func setCalendarView() {
		viewModel.days.removeAll()

		switch viewModel.selectedDisplaying {
		case .monthly:
			let daysInMonth = viewModel.daysInMonth(date: viewModel.getSelectedDate())
			let firstDayOfMonth = viewModel.firstOfMonth(date: viewModel.getSelectedDate())
			let startingSpaces = viewModel.weekDay(date: firstDayOfMonth)

			let previousMonth = viewModel.minusMonth(date: viewModel.getSelectedDate())
			let daysInPreviousMonth = viewModel.daysInMonth(date: previousMonth)

			var count: Int = 2

			while count <= 42 {
				if count <= startingSpaces {
					let previousMonthDay = daysInPreviousMonth - startingSpaces + count
					viewModel.addDay(
						day: String(previousMonthDay),
						month: Month.previous,
						date: viewModel.addDays(date: firstDayOfMonth, days: count - startingSpaces - 1)
					)
				} else if count - startingSpaces > daysInMonth {
					let nextMonthDay = count - daysInMonth - startingSpaces
					viewModel.addDay(
						day: String(nextMonthDay),
						month: Month.next,
						date: viewModel.addDays(date: firstDayOfMonth, days: count - startingSpaces - 1)
					)
				} else {
					let currentMonthDay = count - startingSpaces
					viewModel.addDay(
						day: String(currentMonthDay),
						month: Month.current,
						date: viewModel.addDays(date: firstDayOfMonth, days: currentMonthDay - 1)
					)
				}
				count += 1
			}
		case .weekly:
			var current = viewModel.sundayForDate(date: viewModel.getSelectedDate())
			let nextSunday = viewModel.addDays(date: current, days: 7)

			while current < nextSunday {
				var currentMonth: Month {
					if viewModel.monthNumber(date: viewModel.getSelectedDate()) > viewModel.monthNumber(date: current) {
						return .next
					} else if viewModel.monthNumber(date: viewModel.getSelectedDate()) < viewModel.monthNumber(date: current) {
						return .previous
					} else {
						return .current
					}
				}

				viewModel.addDay(
					day: String(viewModel.dayOfMonth(date: current)),
					month: currentMonth,
					date: current)
				current = viewModel.addDays(date: current, days: 1)
			}
		}

		self.reloadData()
		self.layoutIfNeeded()
	}
}
