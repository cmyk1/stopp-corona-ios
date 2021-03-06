//
//  SicknessCertificateTanConfirmationViewController.swift
//  CoronaContact
//

import Reusable
import UIKit

final class SicknessCertificateTanConfirmationViewController: UIViewController,
    StoryboardBased, ViewModelBased, ActivityModalPresentable, FlashableScrollIndicators
{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var tanTextField: StandardTextField!

    private var keyboardAdjustingBehavior: KeyboardAdjustingBehavior?
    var viewModel: SicknessCertificateTanConfirmationViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        flashScrollIndicators()
    }

    private func setupUI() {
        let behavior = KeyboardAdjustingBehavior(scrollView: scrollView)
        behavior.keyboardPadding = 40
        keyboardAdjustingBehavior = behavior

        title = "sickness_certificate_tan_confirmation_title".localized
        tanTextField.labelText = "sickness_certificate_tan_confirmation_tan_label".localized
        tanTextField.inputType = .numbers

        if let mobileNumber = viewModel?.mobileNumber {
            descriptionLabel.text = String(format: "sickness_certificate_tan_confirmation_description".localized, mobileNumber)
        }
    }

    private func setupViewModel() {
        viewModel?.composeTanNumber = { [weak self] in
            self?.tanTextField.text
        }
    }

    @IBAction func resendTanButtonTapped(_ sender: Any) {
        showActivity()
        viewModel?.resendTan(completion: { [weak self] in
            self?.hideActivity()
        })
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        tanTextField.forceValidation()

        guard tanTextField.isValid else {
            return
        }

        viewModel?.goToNext()
    }
}
