//
//  CharacterDetailsViewController.swift
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

protocol CharacterDetailsDisplayLogic: AnyObject {
    func displayCharacterDetails(viewModel: CharacterDetails.ShowCharacterDetails.ViewModel)
}

final class CharacterDetailsViewController: UIViewController, CharacterDetailsDisplayLogic {
    
    var interactor: CharacterDetailsBusinessLogic?
    var router: (NSObjectProtocol & CharacterDetailsRoutingLogic & CharacterDetailsDataPassing)?
    private let CELL_IDENTIFIER = "cellIdentifier"
    
    var details: Result? {
        didSet {
            guard let details = details else { return }
            ImageDownloader.downloaded(from: details.finalPhoto) { image in
                self.heroImage.image = image
            }
            heroNameLabel.text = details.name
            heroDetailsLabel.text = details.resultDescription
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.navigationItem.title = details.name
        }
    }
    
    // MARK: Views
    var heroNameLabel : UILabel = {
        var l = UILabel()
        l.textColor = .black
        l.textAlignment = .center
        return l
    }()
    
    var heroDetailsLabel : UILabel = {
        var l = UILabel()
        l.numberOfLines = 0
        l.textColor = .black
        return l
    }()
    
    var heroImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(UITableViewCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
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
        let interactor = CharacterDetailsInteractor()
        let presenter = CharacterDetailsPresenter()
        let router = CharacterDetailsRouter()
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
        makeShowDetailsRequest()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(heroNameLabel)
        heroNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bot: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 10, botConstant: 0, rightConstant: 10, width: 0, height: 40)
        
        view.addSubview(heroImage)
        heroImage.anchor(top: heroNameLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bot: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 0, botConstant: 0, rightConstant: 0, width: 0, height: 200)
        
        view.addSubview(heroDetailsLabel)
        heroDetailsLabel.anchor(top: heroImage.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bot: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 10, botConstant: 0, rightConstant: 10, width: 0, height: 150)
        
        view.addSubview(tableView)
        tableView.anchor(top: heroDetailsLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bot: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 10, leftConstant: 0, botConstant: 0, rightConstant: 0, width: 0, height: 0)
    }
    
    func makeShowDetailsRequest() {
        interactor?.showDetails()
    }
    
    func displayCharacterDetails(viewModel: CharacterDetails.ShowCharacterDetails.ViewModel){
        self.details = viewModel.characterDetail
    }
}

extension CharacterDetailsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (details?.comics?.items?.count)! > 10 {
            return 10
        } else {
            return (details?.comics?.items?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)
        cell.textLabel?.text = details?.comics?.items?[indexPath.row].name
        cell.textLabel?.textColor = .black
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
