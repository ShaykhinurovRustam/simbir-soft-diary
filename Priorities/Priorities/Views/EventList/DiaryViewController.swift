import UIKit
import SnapKit

class DiaryViewController: UIViewController {
	@IBOutlet var monthLabel: UILabel!
	@IBOutlet var calendarView: CalendarCollectionView!
	@IBOutlet var eventsTableView: UITableView!
	@IBOutlet var switchDisplayButton: UIButton!

	private var viewModel: DiaryViewModelProtocol

	init(viewModel: DiaryViewModelProtocol, calendarViewModel: CalendarViewModelProtocol) {
		self.viewModel = viewModel
		calendarView = CalendarCollectionView(viewModel: calendarViewModel)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		let repository = Repository()
		let eventModel = Event(repository: repository)
		let calendarViewModel = CalendarViewModel()

		viewModel = DiaryViewModel(model: eventModel, selectedDate: calendarViewModel.selectedDate)
		calendarView = CalendarCollectionView(viewModel: calendarViewModel)
		super.init(coder: coder)
	}

	override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		setCellsView()
		setCalendarView()
		initHours()
		updateEvents()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		updateEvents()
	}

	@IBAction func previousDateTapped(_ sender: Any) {
		switch calendarView.viewModel.selectedDisplaying {
		case .monthly:
			calendarView.viewModel.setSelectedDate(
				date: calendarView.viewModel.minusMonth(date: calendarView.viewModel.getSelectedDate())
			)
			viewModel.selectedDate = calendarView.viewModel.getSelectedDate()
		case .weekly:
			calendarView.viewModel.setSelectedDate(
				date: calendarView.viewModel.minusWeek(date: calendarView.viewModel.getSelectedDate())
			)
			viewModel.selectedDate = calendarView.viewModel.getSelectedDate()
		}
		setCalendarView()
	}

	@IBAction func nextDateTapped(_ sender: Any) {
		switch calendarView.viewModel.selectedDisplaying {
		case .monthly:
			calendarView.viewModel.setSelectedDate(
				date: calendarView.viewModel.plusMonth(date: calendarView.viewModel.getSelectedDate())
			)
			viewModel.selectedDate = calendarView.viewModel.getSelectedDate()
		case .weekly:
			calendarView.viewModel.setSelectedDate(
				date: calendarView.viewModel.plusWeek(date: calendarView.viewModel.getSelectedDate())
			)
			viewModel.selectedDate = calendarView.viewModel.getSelectedDate()
		}
		setCalendarView()
	}

	@IBAction func switchDisplayTapped(_ sender: Any) {
		switch calendarView.viewModel.selectedDisplaying {
		case .monthly:
			calendarView.viewModel.setSelectedDisplaying(display: .weekly)
			switchDisplayButton.setTitle("Неделя", for: .normal)
		case .weekly:
			calendarView.viewModel.setSelectedDisplaying(display: .monthly)
			switchDisplayButton.setTitle("Месяц", for: .normal)
		}
		setCalendarView()
	}

	@IBAction func addEventTapped(_ sender: Any) {
		let eventVC = EventCreateViewController(viewModel: viewModel.getEventCreateViewModel())
		self.navigationController?.pushViewController(eventVC, animated: true)
	}
}

extension DiaryViewController {
	private func setupUI() {
		view.backgroundColor = .white
		eventsTableView.backgroundColor = .white
	}

	private func setCellsView() {
		calendarView.setCellsView()
	}

	private func initHours() {
		calendarView.viewModel.initHours()
	}

	private func setCalendarView() {
		monthLabel.text = calendarView.viewModel.thisMonthString()
		+ " " + calendarView.viewModel.thisYearString()

		calendarView.setCalendarView()
		eventsTableView.reloadData()
	}

	private func updateEvents() {
		DispatchQueue.main.async { [self] in
			viewModel.getEvents { [weak self] hasEventsUpdated in
				guard let self, hasEventsUpdated else { return }
				self.eventsTableView.refreshControl?.endRefreshing()
				self.eventsTableView.reloadData()
			}
		}
	}
}

extension DiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendarView.viewModel.days.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard
			let cell = calendarView.dequeueReusableCell(
				withReuseIdentifier: "calendarCell",
				for: indexPath
			) as? CalendarCell
		else {
			fatalError("Could not dequeue reusable cell as a CalendarCell")
		}
		let calendarDay = calendarView.viewModel.days[indexPath.item]

		cell.day.text = calendarDay.day
		if calendarDay.month == Month.current {
			cell.day.textColor = .black
		} else {
			cell.day.textColor = .gray
		}

		cell.layer.cornerRadius = cell.layer.frame.height / 4
		cell.clipsToBounds = true
		if calendarDay.date == calendarView.viewModel.getSelectedDate() {
			cell.layer.borderColor = UIColor.black.cgColor
			cell.layer.borderWidth = 1
		} else {
			cell.layer.borderColor = UIColor.white.cgColor
			cell.layer.borderWidth = 1
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		calendarView.viewModel.setSelectedDate(date: calendarView.viewModel.days[indexPath.row].date)
		viewModel.selectedDate = calendarView.viewModel.getSelectedDate()
		setCalendarView()
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numberOfItemsPerRow: CGFloat = 7
		let spacingBetweenCells: CGFloat = 2

		let totalSpacing = (2 * calendarView.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
		let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
		return CGSize(width: width, height: width)
	}
}

extension DiaryViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return calendarView.viewModel.hours.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = eventsTableView.dequeueReusableCell(
				withIdentifier: "dailyCell"
			) as? DailyCell
		else {
			fatalError("Could not dequeue reusable cell as a DailyCell")
		}

		let hour = calendarView.viewModel.hours[indexPath.row]

		cell.time.text = calendarView.viewModel.formatHour(hour: hour)
		cell.eventName.isHidden = true
		cell.eventName.layer.cornerRadius = cell.eventName.frame.height / 4
		cell.eventName.layer.borderWidth = 1
		cell.eventName.layer.borderColor = UIColor.black.cgColor
		cell.eventName.layer.masksToBounds = true

		let events = viewModel.getEventsForDateAndTime(
			date: calendarView.viewModel.getSelectedDate(),
			hour: hour
		)

		if !events.isEmpty {
			cell.eventName.isHidden = false
			cell.eventName.text = events[0].name
			cell.event = events[0]
		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		eventsTableView.deselectRow(at: indexPath, animated: true)
		guard
			let cell = eventsTableView.cellForRow(at: indexPath) as? DailyCell
		else {
			fatalError("Could not dequeue reusable cell as a DailyCell")
		}

		if !cell.eventName.isHidden {
			let eventCheckVM = viewModel.getEventCheckViewModel(event: cell.event)

			guard
				let eventCheckVC = self.storyboard?.instantiateViewController(
					withIdentifier: "EventCheckViewController") as? EventCheckViewController
			else {
				fatalError("Could not create Event Check View Controller")
			}
			eventCheckVC.setViewModel(viewModel: eventCheckVM)
			eventCheckVC.onDismiss = { [weak self] in
				self?.updateEvents()
			}
			self.present(eventCheckVC, animated: true, completion: nil)
		}
	}
}
