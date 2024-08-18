//
//  PhotoDetailFactory.swift
//  Snjor
//
//  Created by Адам on 20.06.2024.
//

import UIKit
import Combine

struct PhotoDetailFactory: PhotoDetailFactoryProtocol {
  
  // MARK: - Internal Properties
  let photo: Photo

  // MARK: - Internal Methods
  func makeModule() -> UIViewController {
    let state = PassthroughSubject<StateController, Never>()
    let networkService = NetworkService()
    let repository = LoadPhotoDetailRepository(
      networkService: networkService
    )
    let loadUseCase = LoadPhotoDetailUseCase(
      repository: repository,
      photo: photo
    )
    let viewModel = PhotoDetailViewModel(
      state: state,
      loadUseCase: loadUseCase
    )
    
    viewModel.photo = photo
    let module = PhotoDetailViewController(viewModel: viewModel)
    return module
  }
}