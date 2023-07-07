import UIKit
import SnapKit

class EventCreateViewController: UIViewController {
	var viewModel: EventCreateViewModelProtocol

	private var eventName: UITextField = {
		let field = UITextField()
		field.autocorrectionType = .no
		field.autocapitalizationType = .none
		return field
	}()

	private var eventDescription = UITextView()

	private lazy var beginningDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
		return datePicker
	}()

	private lazy var endingDatePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
		return datePicker
	}()

	private var beginningLabel = UILabel()
	private var endingLabel = UILabel()

	private var beginningStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
		return stackView
	}()

	private var endingStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
		return stackView
	}()

	private lazy var saveButton = UIBarButtonItem(
		title: "Cохранить",
		style: .done,
		target: self,
		action: #selector(saveButtonDidTap)
	)

	init(viewModel: EventCreateViewModelProtocol) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		setupUI()
		setupDatePickers()
		setupConstraints()
    }

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		eventName.layer.masksToBounds = true
		eventDescription.layer.masksToBounds = true
		beginningLabel.layer.masksToBounds = true
		endingLabel.layer.masksToBounds = true

		eventName.layer.cornerRadius = eventName.frame.height / 4
		eventDescription.layer.cornerRadius = eventDescription.frame.height / 48
		beginningLabel.layer.cornerRadius = beginningLabel.frame.height / 4
		endingLabel.layer.cornerRadius = endingLabel.frame.height / 4
	}

	@objc private func textFieldDidChange(_ textField: UITextField) {
		if textField == eventName {
			self.navigationItem.rightBarButtonItem?.isHidden = !((eventName.text?.isEmpty) != true)
		}
	}

	@objc func startDateChanged(_ datePicker: UIDatePicker) {
		endingDatePicker.minimumDate = datePicker.date
	}

	@objc func endDateChanged(_ datePicker: UIDatePicker) {
		beginningDatePicker.maximumDate = datePicker.date
	}

	@objc private func saveButtonDidTap() {
		if beginningDatePicker.date > endingDatePicker.date {
			let alert = UIAlertController(
				title: "Ошибка",
				message: "Дата конца не может быть раньше даты начала.",
				preferredStyle: .alert
			)
			let okAction = UIAlertAction(
				title: "OK",
				style: .default,
				handler: nil
			)
			alert.addAction(okAction)
			present(alert, animated: true, completion: nil)
			return
		}

		viewModel.saveEvent(
			name: eventName.text ?? "Null",
			descripton: eventDescription.text,
			startDate: beginningDatePicker.date,
			endDate: endingDatePicker.date)

		self.navigationController?.popViewController(animated: true)
	}
}

extension EventCreateViewController {
	private func setupUI() {
		view.backgroundColor = .white

		addSubviews(
			for: view,
			subviews: eventName,
			eventDescription,
			beginningStackView,
			endingStackView,
			endingLabel,
			endingDatePicker
		)

		addSubviews(
			for: beginningStackView,
			subviews: beginningLabel,
			beginningDatePicker
		)

		addSubviews(
			for: endingStackView,
			subviews: endingLabel,
			endingDatePicker
		)

		eventName.placeholder = "Название"
		eventName.layer.borderColor = UIColor.black.cgColor
		eventName.layer.borderWidth = 1
		eventName.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
		eventName.leftViewMode = .always
		eventName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

		eventDescription.layer.borderColor = UIColor.black.cgColor
		eventDescription.layer.borderWidth = 1
		eventDescription.font = .systemFont(ofSize: 16)
		eventDescription.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)

		beginningLabel.text = "Начало"
		beginningLabel.font = .systemFont(ofSize: 20, weight: .light)
		beginningLabel.textAlignment = .center
		beginningLabel.layer.borderColor = UIColor.black.cgColor
		beginningLabel.layer.borderWidth = 1

		endingLabel.text = "Конец"
		endingLabel.font = .systemFont(ofSize: 20, weight: .light)
		endingLabel.textAlignment = .center
		endingLabel.layer.borderColor = UIColor.black.cgColor
		endingLabel.layer.borderWidth = 1

		self.navigationItem.rightBarButtonItem = saveButton
		self.navigationItem.rightBarButtonItem?.isHidden = true
	}

	private func setupDatePickers() {
		beginningDatePicker.datePickerMode = .dateAndTime
		beginningDatePicker.date = viewModel.selectedDate
		beginningDatePicker.minimumDate = viewModel.selectedDate
		beginningDatePicker.locale = Locale(identifier: "ru_RU")

		endingDatePicker.datePickerMode = .dateAndTime
		endingDatePicker.date = viewModel.selectedDate
		endingDatePicker.minimumDate = viewModel.selectedDate
		endingDatePicker.locale = Locale(identifier: "ru_RU")
	}

	private func setupConstraints() {
		eventName.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.right.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.height.equalTo(32)
		}

		beginningStackView.snp.makeConstraints { make in
			make.top.equalTo(eventName.snp.bottom).offset(16)
			make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.right.equalTo(view.safeAreaLayoutGuide).inset(16)
		}

		endingStackView.snp.makeConstraints { make in
			make.top.equalTo(beginningStackView.snp.bottom).offset(8)
			make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.right.equalTo(view.safeAreaLayoutGuide).inset(16)
		}

		eventDescription.snp.makeConstraints { make in
			make.top.equalTo(endingStackView.snp.bottom).offset(16)
			make.left.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.right.equalTo(view.safeAreaLayoutGuide).inset(16)
			make.bottom.equalTo(view.safeAreaLayoutGuide).inset(48)
		}
	}
}
