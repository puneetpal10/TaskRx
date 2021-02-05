//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Mohammad Azam on 2/26/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])//Variable<[Task]>([])
    private var filteredTask = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.filteredTask[indexPath.row].title
        
        return cell
    }
    
    
    private func updateTableView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let addTVC = navC.viewControllers.first as? AddTaskViewController else {
            fatalError("Controller not found...")
        }
        
        addTVC.taskSubjectObservable
            .subscribe(onNext: {[unowned self] task in
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                var existingTask = self.tasks.value
                existingTask.append(task)
                self.tasks.accept(existingTask)
                
                self.filterTasks(by: priority)
                
            }).disposed(by: disposeBag)
        
    }
    
    @IBAction func priorityChanged(_ segmentedControl: UISegmentedControl){
        let priority = Priority(rawValue: segmentedControl.selectedSegmentIndex - 1)
        self.filterTasks(by: priority)
    }
    
    private func filterTasks(by priority: Priority?){
        if priority == nil{
            self.filteredTask = self.tasks.value
            self.updateTableView()
        }else{
            self.tasks.map{ tasks in
                return tasks.filter{$0.priority == priority!}
            }.subscribe(onNext: {[weak self] tasks in
                self?.filteredTask = tasks
                print(tasks)
                self?.updateTableView()
            }).disposed(by: disposeBag)
        }
    }
    
}
