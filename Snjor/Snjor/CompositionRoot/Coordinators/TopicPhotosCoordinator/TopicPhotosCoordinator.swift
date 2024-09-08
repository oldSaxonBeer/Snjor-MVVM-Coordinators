//
//  TopicPhotosCoordinator.swift
//  Snjor
//
//  Created by Адам Мирзаканов on 16.08.2024.
//

final class TopicPhotosCoordinator: Coordinatable {
  // MARK: Internal Properties
  var navigation: any Navigable
  var childCoordinators: [any Coordinatable] = []
  
  // MARK: Private Properties
  private(set) var factory: any TopicPhotosFactoryProtocol
  private weak var parentCoordinator: (any ParentCoordinator)?
  
  // MARK: Initializers
  init(
    factory: any TopicPhotosFactoryProtocol,
    navigation: any Navigable,
    parentCoordinator: (any ParentCoordinator)?
  ) {
    self.factory = factory
    self.navigation = navigation
    self.parentCoordinator = parentCoordinator
  }

  // MARK: Internal Methods
  func start() {
    let controller = factory.makeController(delegate: self)
    navigation.pushViewController(controller, animated: true) { [weak self] in
      guard let self = self else { return }
      self.parentCoordinator?.removeChildCoordinator(self)
    }
  }
}