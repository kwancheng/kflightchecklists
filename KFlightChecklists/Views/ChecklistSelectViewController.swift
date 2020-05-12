//
//  ChecklistSelectViewController.swift
//  KFlightChecklists
//
//  Created by Kwan Cheng on 6/13/15.
//  Copyright (c) 2015 Acproma llc. All rights reserved.
//

import UIKit

class ChecklistSelectViewController : ViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var lbChecklists : UITableView!
    
    fileprivate var selectedChecklist : Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbChecklists.dataSource = self
        lbChecklists.delegate = self
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "main_background")!)
        lbChecklists.backgroundColor = UIColor.clear
    }
    
    // MARK : UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if let tCount = self.checklistPack.checklists?.count {
            count = tCount
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChecklistCell
        
        cell.lblChecklistName?.text = self.checklistPack.checklists?[indexPath.row].title
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // MARK : UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChecklist = self.checklistPack.checklists?[indexPath.row]
        performSegue(withIdentifier: "PerformChecklist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        let destVC = segue.destination as! ChecklistViewController
        destVC.setChecklist(selectedChecklist!)
    }
}
