//
//  PostVM.swift
//  MVVMRxSwift
//
//  Created by Edo Oktarifa on 26/04/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PostVM {
    
    var disposeBag = DisposeBag()
    
    public let loading: PublishSubject<Bool> = PublishSubject()
    public var albums: PublishSubject<Post> = PublishSubject()
    public let error: PublishSubject<ErrorMessage> = PublishSubject()
    
    func requestData(){
        
        self.loading.onNext(true)
        
        ApiClient.getPosts(userId: 1)
                 .observeOn(MainScheduler.instance)
                 .subscribe(onNext: { postsList in
                    
                    self.albums.onNext(postsList)
                    self.loading.onNext(false)
                    print("List of posts:", postsList)
                 }, onError: { error in
                    self.loading.onNext(false)
                     switch error {
                     case ApiError.conflict:
                         print("Conflict error")
                        self.error.onNext(.conflict)
                     case ApiError.forbidden:
                        self.error.onNext(.forbidden)
                     case ApiError.notFound:
                        self.error.onNext(.notFound)
                     case ApiError.internalServerError:
                        self.error.onNext(.internalServerError)
                     default:
                        self.error.onNext(.unknownError)
//                        print("Unknown error:", error)
                     }
                 })
                 .disposed(by: disposeBag)
    }
    
}
