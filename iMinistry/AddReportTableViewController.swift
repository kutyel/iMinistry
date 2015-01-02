//
//  AddReportTableViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright (c) 2014 Flavio Corpa. All rights reserved.
//

import UIKit
import CoreData

class AddReportTableViewController: UITableViewController {

    typealias DidCancelDelegate = AddReportTableViewController -> ()
    typealias DidFinishDelegate = AddReportTableViewController -> ()
    var didCancel: DidCancelDelegate?
    var didFinish: DidFinishDelegate?
    
    var report: Report?
    
    @IBOutlet var hoursTextField: UITextField!
    @IBOutlet var booksTextField: UITextField!
    @IBOutlet var magazinesTextField: UITextField!
    
    @IBAction func hoursChange(sender: UIStepper) {
        hoursTextField.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        hoursTextField.resignFirstResponder()
        booksTextField.resignFirstResponder()
        magazinesTextField.resignFirstResponder()
        
        let report = self.report!
        let managedObjectContext = report.managedObjectContext!
        managedObjectContext.deleteObject(report)
        
        var e: NSError?
        if !managedObjectContext.save(&e) {
            println("Error at cancel: \(e?.localizedDescription)")
            abort()
        }
        
        self.didCancel!(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        
        hoursTextField.resignFirstResponder()
        booksTextField.resignFirstResponder()
        magazinesTextField.resignFirstResponder()
        
        let report = self.report!
        report.hours = (hoursTextField.text as NSString).doubleValue
        report.books = booksTextField.text.toInt()
        report.magazines = magazinesTextField.text.toInt()
        let managedObjContext = report.managedObjectContext!
        
        var e: NSError?
        if !managedObjContext.save(&e) {
            println("Error at done: \(e?.localizedDescription)")
            abort()
        }
        
        self.didFinish!(self)
    }
}
