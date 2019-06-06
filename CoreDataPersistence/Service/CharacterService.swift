//
//  CharacterService.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Moya
import RxSwift
import Alamofire

class CharacterService: BaseService<RickAndMortyEndpoint> {
    
    typealias CharacterResponse = ResponseObject<Array<Character>>
    typealias CharacterResult = Swift.Result<CharacterResponse, Error>
    
    private let networkConfig: NetworkConfig!
    
    private let disposeBag = DisposeBag()
    private var characters = PublishSubject<CharacterResult>()
    
    init(networkConfig: NetworkConfig) {
        self.networkConfig = networkConfig
        super.init(plugins: [NetworkLoggerPlugin(verbose: true)])
    }
    
    func getCharactersObservable() -> Observable<CharacterResult> {
        return self.characters.asObservable()
    }
}

extension CharacterService {
    
    func find(name: String?) {
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decoderMappingModel = DecodableMappingModel(jsonDecoder: jsonDecoder, keyPath: "results", failsOnEmpty: false)
        
        self.executePersistedObservableArrayRequest(target: .characters(networkConfig: networkConfig, name: name),
                                      mapTo: Array<Character>.self,
                                      decoder: decoderMappingModel)
            .subscribe(onNext: { res in
                
                switch res {
                    
                case .success(let response):                    
                    self.characters.onNext(.success(response))
                case .failure(let error):
                    self.characters.onNext(.failure(error))
                }
            }, onError: { error in
                self.characters.onNext(.failure(error))
            }).disposed(by: disposeBag)
    }
}
