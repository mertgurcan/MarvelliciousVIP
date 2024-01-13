//
//  CharacterDetailsPresenter.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 6.01.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CharacterDetailsPresentationLogic {
    func presentCharacterDetail(response: CharacterDetails.ShowCharacterDetails.Response)
}

class CharacterDetailsPresenter: CharacterDetailsPresentationLogic {
    
    weak var viewController: CharacterDetailsDisplayLogic?
    
    func presentCharacterDetail(response: CharacterDetails.ShowCharacterDetails.Response) {
        var characterDetail = response.characterDetail
        
        var name = ""
        if let n = characterDetail.name {
            name = n
        }
        var detail = ""
        if let d = characterDetail.resultDescription {
            detail = d.isEmpty ? "No description" : d
        }
        
        var photoURLString : String = ""
        if let thumbnail = characterDetail.thumbnail, let path = thumbnail.path, let thumbnailExtension = thumbnail.thumbnailExtension {
            photoURLString = "\(path.replacingOccurrences(of: "http", with: "https"))." + "\(thumbnailExtension)"
        }
        
        var comics = Comics(available: nil, collectionURI: nil, items: nil, returned: nil)
        if let c = characterDetail.comics {
            comics = c
        }
        
        let displayDetails = CharacterDetails.ShowCharacterDetails.ViewModel.DisplayResult(name: name, imageUrl: photoURLString, resultDescription: detail, comics: comics)
        
        let viewModel = CharacterDetails.ShowCharacterDetails.ViewModel(displayResult: displayDetails)
        viewController?.displayCharacterDetails(viewModel: viewModel)
    }
}

