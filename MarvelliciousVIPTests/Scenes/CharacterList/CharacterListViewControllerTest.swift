//
//  CharacterListViewControllerTest.swift
//  MarvelliciousVIPTests
//
//  Created by Mert Gürcan on 13.01.2024.
//

@testable import MarvelliciousVIP
import XCTest

final class CharacterListViewControllerTest: XCTestCase {
    
    var sut: CharacterListViewController!
    var window: UIWindow!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        sut = CharacterListViewController()
    }
    
    func loadView() {
        window.addSubview(sut.view)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        window = nil
    }
    
    class CharacterListBusinessLogicSpy : CharacterListDataStore, CharacterListBusinessLogic {
        
        var list: ListResponse?
        
        var getListCalled = false
        
        func showCharacterList(request: MarvelliciousVIP.CharacterList.ShowCharacterList.Request) {
            getListCalled = true
        }
    }
    
    func testShouldShowOrderWhenViewIsLoaded() throws {
        let characterListBusinessLogicSpy = CharacterListBusinessLogicSpy()
        sut.interactor = characterListBusinessLogicSpy

        loadView()
        
        XCTAssert(characterListBusinessLogicSpy.getListCalled, "Should show order when the view is loaded")
      }

    func testDisplayList() throws {
        
        let characterListBusinessLogicSpy = CharacterListBusinessLogicSpy()
        sut.interactor = characterListBusinessLogicSpy
        loadView()
        
        let displayResult = CharacterList.ShowCharacterList.ViewModel.DisplayResult(name: "TestName", imageUrl: "TestImage1")
        let displayList = CharacterList.ShowCharacterList.ViewModel.DisplayResultList(list: [displayResult])
        
        
        let viewModel = CharacterList.ShowCharacterList.ViewModel(results: displayList)
        sut.displayCharacterList(viewModel: viewModel)
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 0.3)
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CharacterListTableViewCell
        
        XCTAssertEqual(cell?.characterName.text!, "TestName", "Displaying an order should update the name label")
        XCTAssertEqual(cell?.result?.imageUrl, "TestImage1", "Displaying an order should update the imageUrl label")
    }
}
