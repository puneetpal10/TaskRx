import UIKit
import RxSwift
import RxCocoa

var str = "Hello, playground"

let disposeBag = DisposeBag()

//Transformation of an array of elements
//Observable.of(1,2,3,4,5,6)
//    .toArray().subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//
//
//
//Observable.of(1,2,3,4,5,6)
//    .map{ return $0 * 2 }.subscribe(onNext: {
//        print($0)
//    }).disposed(by: disposeBag)
//


struct Student{
    var score: BehaviorRelay<Int>
}


let john = Student(score: BehaviorRelay(value: 75))
let smith = Student(score: BehaviorRelay(value: 80))

let student = PublishSubject<Student>()

student.asObserver().flatMap{ $0.score.asObservable()}.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


student.onNext(john)
john.score.accept(100)


student.onNext(smith)
smith.score.accept(90)

john.score.accept(50)



student.asObserver().flatMapLatest{ $0.score.asObservable()}.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


student.onNext(john)
john.score.accept(100)


student.onNext(smith)
smith.score.accept(90)

john.score.accept(50) // It will not printed in the case of flatmapLatest
