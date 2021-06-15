# ITBookShelf
Swift, Combine, IT Book Store, pagination, image cache  
Standalone Application without thrird party library  
Local Swift Package Manager  

For the API used, see here [(IT Bookstore API)](https://api.itbook.store)

## purpose

Works Standalone without 3rd party libraries.  
Combine based MVVM application.  
  
Understanding Search, SearchResult View controller hierarchies.  
Smooth pagination scrollview (tableview, collectionview)  
Completly seperated Core Module. (using Swift Pakage Manager)

## CoreModular

It is a collection of core functions with little change   
such as communication and utility.  
Local Swift Package Manager (SPM)

### ViewModelStream, ViewModelType  

https://github.com/kickstarter/ios-oss

Based on the kicstater MVVM Style.  

**points of better then original style.**  

less typing and changes then original style.    
completly separation of interfaces.    
still using unidirectional data flow  
and enhanced access control.  
more extendable easier. 

**sample code**
```
Class SomeClass {
  class ViewModel {
      // MARK: - Lazy properties
      lazy var inputs: Inputs = { Inputs(base: self) }()
      lazy var outputs: Outputs = { Outputs(base: self) }()
  }
}
...

extension SomeController.ViewModel: ViewModelStream {
    typealias ViewModel = BookShlefViewController.ViewModel
    /// Implement only functions, if possible
    struct Inputs: ViewModelStreamInternals {
        private unowned var base: ViewModel
        init(base: ViewModel) { self.base = base }
    }
    /// Implement only functions, if possible
    struct Outputs: ViewModelStreamInternals {
        private unowned var base: ViewModel
        init(base: ViewModel) { self.base = base }
    }
}

fileprivate typealias Inputs = SomeController.ViewModel.Inputs
fileprivate typealias Outputs = SomeController.ViewModel.Outputs

extension Inputs {
    /// event binder, these property types must not be relay and subject
    var someValueObservable: SomeObservable { base.someValue }
    func fetchSomething() { base.fetchSomething() }
    func configureSomeDepandancy(_ depandancy: Depandancy) { base.depandancy = depandancy }
}

extension Outputs {
    var item: SomeObservable { base.item }
    var error: SomeObservable<Error, Never> { base.error }
    var someValue: String { base.someValue }
}

```

### 1. HTTP module based on Combine framework.  
**sample code**
```
Remote<Some Codable>.somefunction().asObservable()
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


## Feature

**Base**

The ViewController used as the base and  
BaseCell Protocol to configure TableView Cell  
(View-based feature of MVVM)  

**Model**


This feature is a category of the **MVVM** model.
By extending Core Modular's HTTP module (**Remote**)
Each transaction instance can be create.
The model conforms the Codable protocol.

```
protocol BookShelf: Codable {
    var total: String { get }
    var error: String { get }
    var books: [Model.Book] { get }
}

protocol BookInfo: Codable & Equatable {
    var title: String { get }
    var subtitle: String { get }
    var isbn13: String { get }
    var price: String { get }
    var image: String { get }
    var url: String { get }
}

    struct Book: BookInfo, Equatable {
        var title: String
        var subtitle: String
        var isbn13: String
        var price: String
        var image: String 
        var url: String
    }
```

#### Common View protocol

conforms MVVM View's protocol

**BookSehlf**

1. 사용자가 검색했던 책이 없는 경우 신규 책 리스트를 불러와서 표시함.  
2. 사용자가 검색했던 책이 저장 되어있는 경우 리스트를 불러와서 표시함.  
3. 이미지는 각 아이템 마 URL 문자열로 제공 되며 이미지는 비동기처리됨.      
(CoreModular에 속해있는 ImageCache 관련 기능 사용)  
4. 책 검색 기능 제공  


**Search Result**

**Book Detail**

**PDF**

**ETC Extensions**
