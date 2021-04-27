//
//  ViewController.swift
//  MVVMRxSwift
//
//  Created by Edo Oktarifa on 26/04/21.
//

import UIKit
import RxSwift

class PostViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var vm = PostVM()
    private var albums = PublishSubject<Post>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBinding()
        vm.requestData()
    }
    
    private func setupBinding(){
        vm.error.observeOn(MainScheduler.instance).subscribe(onNext: { error in
            
            switch error {
            case .notFound:
                print(ErrorMessage.notFound.rawValue)
            case .forbidden:
                print(ErrorMessage.forbidden.rawValue)
            case .conflict:
                print(ErrorMessage.conflict.rawValue)
            case .internalServerError:
                print(ErrorMessage.internalServerError.rawValue)
            case .unknownError:
                print(ErrorMessage.unknownError.rawValue)
            }
        }
                        
        ).disposed(by: disposeBag)
        
        vm.albums.observeOn(MainScheduler.instance).bind(to: self.albums).disposed(by: disposeBag)
        
        //MARK: - show data
        albums.subscribe(onNext: {
            (post) in
            self.titleLabel.text = post.title
        }).disposed(by: disposeBag)
    }
}

