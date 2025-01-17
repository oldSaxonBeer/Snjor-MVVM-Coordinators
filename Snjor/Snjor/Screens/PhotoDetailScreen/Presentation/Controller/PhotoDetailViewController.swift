//
//  PhotoDetailViewController.swift
//  Snjor
//
//  Created by Адам on 18.06.2024.
//

import UIKit
import Combine

final class PhotoDetailViewController: BaseViewController<PhotoDetailViewControllerRootView> {
  // MARK: Private Properties
  private var cancellable = Set<AnyCancellable>()
  private(set) weak var delegate: (any PhotoDetailViewControllerDelegate)?
  private(set) var downloadService = DownloadService()
  private(set) var viewModel: any PhotoDetailViewModelProtocol
  private(set) var documentsPath = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  ).first!
  
  // MARK: Override Properties
  override var shouldShowTabBarOnScroll: Bool {
    return false
  }

  // MARK: Initializers
  init(
    viewModel: any PhotoDetailViewModelProtocol,
    delegate: any PhotoDetailViewControllerDelegate
  ) {
    self.viewModel = viewModel
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError(ErrorMessage.initCoderNotImplementedError)
  }

  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupRootViewDelegate()
    stateController()
    viewModel.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    hideCustomTabBar()
    setupNavigationItems()
    configureDownloadSession()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    resetSearchState()
  }
  
  func resetSearchState() {
    downloadService.invalidateSession(withID: Self.sessionID)
  }
  
  // MARK: Private Methods
  private func configureDownloadSession() {
    downloadService.configureSession(
      delegate: self,
      id: Self.sessionID
    )
  }

  private func stateController() {
    viewModel
      .state
      .receive(on: RunLoop.current)
      .sink { [weak self] state in
        guard let self = self else { return }
        switch state {
        case .success:
          rootView.setupPhotoInfoData(viewModel: viewModel)
        case .loading: break
        case .fail(error: let error):
          showError(error: error)
        }
      }
      .store(in: &cancellable)
  }

  private func showError(error: String) {
    guard let navigationController = navigationController else { return }
    navigationItem.leftBarButtonItem?.isHidden = true
    navigationItem.rightBarButtonItems?.forEach { $0.isHidden = true }
    rootView.mainView.isHidden = true
    showError(error: error, navigationController: navigationController)
  }
  
  private func setupNavigationItems() {
    rootView.setupData(viewModel: viewModel)
    rootView.setupBarButtonItems(
      navigationItem: navigationItem,
      navigationController: navigationController
    )
  }
  
  private func setupRootViewDelegate() {
    rootView.delegate = self
    rootView.tagsCollectionView.tagsDelegate = self
  }
}
