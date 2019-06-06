//
//  BaseService.swift
//  CoreDataPersistence
//
//  Created by Tunde on 05/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import CoreData
import RxSwift

class BaseService<Target: TargetType> {
    
    typealias PersistableObject = (PersistedObject & NSManagedObject)
    
    private var plugins: [PluginType]!
    private var moyaProvider: MoyaProvider<Target>!
    
    private let disposeBag = DisposeBag()
    private lazy var reachability = NetworkReachabilityManager()
    
    init(plugins: [PluginType] = []) {
        self.plugins = []
        self.moyaProvider = self.createServiceProvider(plugins: plugins)
    }
}

extension BaseService {
    
    func set(plugins: [PluginType]) {
        self.plugins = plugins
        self.moyaProvider = self.createServiceProvider(plugins: plugins)
    }
}

extension BaseService {
    
    func executeObservableRequest<Type: Codable>(target: Target, mapTo type: Type.Type, decoder: DecodableMappingModel) -> Observable<Result<ResponseObject<Type>>>  {
        
        return Observable.create { observer in
            
            self.getServiceProvider()
                .rx
                .request(target)
                .baseObservable()
                .filterSuccessfulStatusCodes()
                .subscribe(onNext: { response in
                    
                    if let decodedObj = try? response.map(Type.self, atKeyPath: decoder.keyPath, using: decoder.jsonDecoder, failsOnEmptyData: decoder.failsOnEmpty) {
                        observer.onNext(.success(ResponseObject(response: response, data: decodedObj)))
                    } else {
                        observer.onNext(.success(ResponseObject(response: response, data: nil)))
                    }
                    
                }, onError: { error in
                    observer.onNext(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func executePersistedObservableRequest<Type: PersistableObject>(target: Target,
                                                                    mapTo type: Type.Type,
                                                                    decoder: DecodableMappingModel,
                                                                    useCache: Bool = true) -> Observable<Result<ResponseObject<Type>>>  {
        
        return Observable.create { observer in
            
            if useCache {
                
                guard let reachability = self.reachability,
                    reachability.isReachable else {
                        observer.onNext(.success(ResponseObject(response: nil, data: Type.storedObjects().first)))
                        return Disposables.create()
                }
            }
            
            self.executeObservableRequest(target: target, mapTo: type, decoder: decoder)
                .subscribe(onNext: { res in
                    observer.onNext(res)
                    self.persist()
                }, onError: { error in
                    observer.onNext(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func executePersistedObservableArrayRequest<Type: PersistableObject>(target: Target,
                                                                         mapTo type: Array<Type>.Type,
                                                                         decoder: DecodableMappingModel,
                                                                         useCache: Bool = true) -> Observable<Result<ResponseObject<Array<Type>>>>  {
        
        return Observable.create { observer in
            
            if useCache {

                guard let reachability = self.reachability,
                    reachability.isReachable else {
                    observer.onNext(.success(ResponseObject(response: nil, data: Type.storedObjects())))
                    return Disposables.create()
                }
            }
            
            self.executeObservableRequest(target: target, mapTo: type, decoder: decoder)
                .subscribe(onNext: { res in
                    observer.onNext(res)
                    self.persist()
                }, onError: { error in
                    observer.onNext(.failure(error))
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

private extension BaseService {
    
    func getServiceProvider() -> MoyaProvider<Target> {
        return self.moyaProvider
    }
    
    func createServiceProvider<Target>( plugins: [PluginType]) -> MoyaProvider<Target> where Target : TargetType {
        return MoyaProvider<Target>(plugins: plugins)
    }
    
    func persist() {

        let backgroundContext = CoreDataManager.shared.backgroundContext
            backgroundContext.perform {
                try? backgroundContext.save()
            }
        
    }
}
