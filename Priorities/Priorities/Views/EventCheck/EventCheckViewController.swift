import UIKit

class EventCheckViewController: UIViewController {
	@IBOutlet var eventName: UILabel!
	@IBOutlet var eventDescription: UILabel!
	@IBOutlet var beginningDate: UILabel!
	@IBOutlet var endingDate: UILabel!

	private var viewModel: EventCheckViewModel
	var onDismiss: (() -> Void)?

	init(viewModel: EventCheckViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	func setViewModel(viewModel: EventCheckViewModel) {
		self.viewModel = viewModel
	}

	required init?(coder: NSCoder) {
		let repository = Repository()
		let eventModel = Event(repository: repository)
		self.viewModel = EventCheckViewModel(model: eventModel)
		super.init(coder: coder)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .white

		setupUI()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		eventName.layer.masksToBounds = true
		eventDescription.layer.masksToBounds = true

		eventName.layer.cornerRadius = eventName.frame.height / 4
		eventDescription.layer.cornerRadius = eventDescription.frame.height / 4
	}

	@IBAction func deleteEventDidTap(_ sender: Any) {
		if let event = viewModel.event {
			viewModel.deleteEvent(event)
			dismiss(animated: true) { [weak self] in
				self?.onDismiss?()
			}
		}
	}
}

extension EventCheckViewController {
	private func setupUI() {
		eventName.text = viewModel.event?.name
		eventDescription.text = viewModel.event?.descripton ?? ""
		beginningDate.text = viewModel.event?.startDate.formatted(with: Locale(identifier: "ru_RU"))
		endingDate.text = viewModel.event?.endDate.formatted(with: Locale(identifier: "ru_RU"))
	}
}
