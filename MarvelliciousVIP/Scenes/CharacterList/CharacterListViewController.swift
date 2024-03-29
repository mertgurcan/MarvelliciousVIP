//
//  CharacterListViewController.swift
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

protocol CharacterListDisplayLogic: AnyObject {
    func displayCharacterList(viewModel: CharacterList.ShowCharacterList.ViewModel)
}

final class CharacterListViewController: UIViewController, CharacterListDisplayLogic {
    
    var interactor: CharacterListBusinessLogic?
    var router: (NSObjectProtocol & CharacterListRoutingLogic & CharacterListDataPassing)?
    private let CELL_IDENTIFIER = "cellIdentifier"
    
    var vm : CharacterList.ShowCharacterList.ViewModel?
    var numberOfPage : Int = 1
    var stop : Bool = true
    
    // MARK: Views
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(CharacterListTableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        return tv
    }()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = CharacterListInteractor()
        let presenter = CharacterListPresenter()
        let router = CharacterListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        makeShowCharacterListRequest()
    }
    
    func setupView() {
        self.navigationItem.title = "Marvel Characters"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bot: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, botConstant: 0, rightConstant: 0, width: 0, height: 0)
    }
    
    func makeShowCharacterListRequest(){
        let request = CharacterList.ShowCharacterList.Request(page: self.numberOfPage)
        interactor?.showCharacterList(request: request)
    }
    
    func displayCharacterList(viewModel: CharacterList.ShowCharacterList.ViewModel){
        self.vm = viewModel
        DispatchQueue.main.async {
            self.stop = false
            self.tableView.reloadData()
        }
    }
}

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm?.results.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath) as! CharacterListTableViewCell
        cell.result = vm?.results.list[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > tableView.contentSize.height - 200 - scrollView.frame.size.height{
            if stop == false {
                stop = true
                numberOfPage += 1
                makeShowCharacterListRequest()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.routeToCharacterDetail(indexPath: indexPath)
    }
}
