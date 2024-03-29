//
//  CharacterListInteractor.swift
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

protocol CharacterListBusinessLogic {
    func showCharacterList(request: CharacterList.ShowCharacterList.Request)
}

protocol CharacterListDataStore {
    var list: ListResponse? { get set }
}

class CharacterListInteractor: CharacterListBusinessLogic, CharacterListDataStore {
    
    var list: ListResponse?
    
    var presenter: CharacterListPresentationLogic?
    var worker: CharacterListWorker?
    
    private let url = "https://gateway.marvel.com/v1/public/characters"
    
    func showCharacterList(request: CharacterList.ShowCharacterList.Request) {
        let service = Service()
        worker = CharacterListWorker(service: service)
        worker?.fetchCharacterList(from: url, and: request.page) { data in
            if request.page == 1 {
                self.list = data
            } else {
                self.list?.data.results.append(contentsOf: data.data.results)
            }
            
            if let list = self.list {
                let response = CharacterList.ShowCharacterList.Response(ListResponse: list)
                self.presenter?.presentShowList(response: response)
            }
        }
    }
}
