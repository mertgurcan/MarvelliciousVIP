//
//  CharacterDetailsViewControllerTest.swift
//  MarvelliciousVIPTests
//
//  Created by Mert Gürcan on 13.01.2024.
//

@testable import MarvelliciousVIP
import XCTest

final class CharacterDetailsViewControllerTest: XCTestCase {

    var sut: CharacterDetailsViewController!
    var window: UIWindow!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        sut = CharacterDetailsViewController()
    }
    
    func loadView() {
        window.addSubview(sut.view)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        window = nil
    }
    
    class CharacterDetailsBusinessLogicSpy : CharacterDetailsDataStore, CharacterDetailsBusinessLogic {
       
        var characterDetail: MarvelliciousVIP.Result?
        
        var getDetailsCalled = false
        
        func showDetails() {
            getDetailsCalled = true
        }
    }
    
    class TableViewSpy: UITableView {
        var reloadDataCalled = false
        
        override func reloadData() {
            reloadDataCalled = true
        }
    }

    func testShouldShowOrderWhenViewIsLoaded() throws {
        let characterDetailsBusinessLogicSpy = CharacterDetailsBusinessLogicSpy()
        sut.interactor = characterDetailsBusinessLogicSpy

        loadView()
        
        XCTAssert(characterDetailsBusinessLogicSpy.getDetailsCalled, "Should show order when the view is loaded")
    }

    func testDisplayList() throws {
        let characterListBusinessLogicSpy = CharacterDetailsBusinessLogicSpy()
        sut.interactor = characterListBusinessLogicSpy
        
        loadView()
        
        let displayDetails = CharacterDetails.ShowCharacterDetails.ViewModel.DisplayResult(name: "TestName", imageUrl: "TestUrl", resultDescription: "TestDescription", comics: Comics(available: nil, collectionURI: nil, items: [ComicsItem(resourceURI: nil, name: "TestComicName")], returned: nil))
        let viewModel = CharacterDetails.ShowCharacterDetails.ViewModel(displayResult: displayDetails)
        sut.displayCharacterDetails(viewModel: viewModel)
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 0.1)
        
        let cell = sut.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cell?.textLabel?.text!, "TestComicName", "Displaying an order should update the name label")
        
        XCTAssertEqual(sut.heroNameLabel.text!, "TestName", "Displaying an order should update the name label")
        XCTAssertEqual(sut.heroDetailsLabel.text!, "TestDescription", "Displaying an order should update the heroDetails label")
        XCTAssertEqual(sut.vm?.displayResult.imageUrl, "TestUrl", "Displaying an order should update the imageUrl label")
    }
    
    func testReloadData() throws {
        let tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        
        loadView()
        
        let displayDetails = CharacterDetails.ShowCharacterDetails.ViewModel.DisplayResult(name: "TestName", imageUrl: "TestUrl", resultDescription: "TestDescription", comics: Comics(available: nil, collectionURI: nil, items: [ComicsItem(resourceURI: nil, name: "TestComicName")], returned: nil))
        let viewModel = CharacterDetails.ShowCharacterDetails.ViewModel(displayResult: displayDetails)
        sut.displayCharacterDetails(viewModel: viewModel)
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 0.1)
        
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
    }

}

