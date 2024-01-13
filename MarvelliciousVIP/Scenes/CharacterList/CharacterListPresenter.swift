//
//  CharacterListPresenter.swift
//  MarvelliciousVIP
//
//  Created by Mert Gürcan on 4.01.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CharacterListPresentationLogic {
    func presentShowList(response: CharacterList.ShowCharacterList.Response)
}

class CharacterListPresenter: CharacterListPresentationLogic {
    
    weak var viewController: CharacterListDisplayLogic?
    
    func presentShowList(response: CharacterList.ShowCharacterList.Response) {
        var finalResults = response.ListResponse.data.results
        
        var viewModel = CharacterList.ShowCharacterList.ViewModel(results:  CharacterList.ShowCharacterList.ViewModel.DisplayResultList(list: []))
        
        for result in finalResults {
            if let thumbnail = result.thumbnail, let path = thumbnail.path, let thumbnailExtension = thumbnail.thumbnailExtension, let name = result.name {
                let photoURLString = "\(path.replacingOccurrences(of: "http", with: "https"))." + "\(thumbnailExtension)"
                let res = CharacterList.ShowCharacterList.ViewModel.DisplayResult(name: name, imageUrl: photoURLString)
                viewModel.results.list.append(res)
            }
        }
        
        viewController?.displayCharacterList(viewModel: viewModel)
    }
}
