# ITBookShelf
Swift, Combine, IT Book Store, pagination, image cache

사용된 API는 이곳을 참고 [IT Bookstore API](https://api.itbook.store)




## Feature

**Base**

공용으로 사용되는 Base ViewController와  
TableView Cell을 구성 하기 위한 BaseCell Protocol
(MVVM의 View 기반 피쳐)

**Model**

MVVM의 **Model**에 해당하는 피쳐로  
CoreModular의 통신모듈(**Remote**)을 확장하여  
각 통신 인스턴스를 static 인스턴스를 생성 함

**BookSehlf**



## CoreModular

**Feature**와 별도로 통신, 유틸리티 기능들을 모아둔  
Local SPM(Swift Package Manager)  
Local SPM을 이용하여 빈번 하게 사용 되는 중심/공용  
기능의 수정이 없을 시 쓸데없는 빌드 시간을 줄이는데 큰 역할을 함  


### 1. Combine을 중점으로 한 통신 모듈
**sample code**
```
Remote<Codable Model>.lookup().asObservable()
.compactMap({ $0 })
.sink(receiveCompletion: { [unowned self] in
    switch $0 {
        case .failure(let error):
            // handle someerror
        case .finished: print($0)
            // handle finished event
    }
}, receiveValue: { [unowned self] in
    handle receiveValue
}).cancel()
```

**ETC Extensions**
