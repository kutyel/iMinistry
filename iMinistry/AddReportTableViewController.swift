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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Prevent weird space between nav controller and the view
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var hoursTimePicker: UIDatePicker!
    @IBOutlet var booksTextField: UITextField!
    @IBOutlet var magazTextField: UITextField!
    @IBOutlet var brochTextField: UITextField!
    @IBOutlet var returTextField: UITextField!
    @IBOutlet var studiTextField: UITextField!
    
    @IBAction func booksChanged(sender: UIStepper) {
        booksTextField.text = String(Int(sender.value))
    }
    @IBAction func magazChanged(sender: UIStepper) {
        magazTextField.text = String(Int(sender.value))
    }
    @IBAction func brochChanged(sender: UIStepper) {
        brochTextField.text = String(Int(sender.value))
    }
    @IBAction func returChanged(sender: UIStepper) {
        returTextField.text = String(Int(sender.value))
    }
    @IBAction func studiChanged(sender: UIStepper) {
        studiTextField.text = String(Int(sender.value))
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        booksTextField.resignFirstResponder()
        magazTextField.resignFirstResponder()
        brochTextField.resignFirstResponder()
        returTextField.resignFirstResponder()
        studiTextField.resignFirstResponder()
        
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
        
        booksTextField.resignFirstResponder()
        magazTextField.resignFirstResponder()
        brochTextField.resignFirstResponder()
        returTextField.resignFirstResponder()
        studiTextField.resignFirstResponder()
        
        let report = self.report!
        report.date = datePicker.date
        report.hours = hoursTimePicker.date
        report.books = booksTextField.text.toInt()
        report.magazines = magazTextField.text.toInt()
        report.brochures = brochTextField.text.toInt()
        report.return_visits = returTextField.text.toInt()
        report.bible_studies = studiTextField.text.toInt()
        let managedObjContext = report.managedObjectContext!
        
        var e: NSError?
        if !managedObjContext.save(&e) {
            println("Error at done: \(e?.localizedDescription)")
            abort()
        }
        
        self.didFinish!(self)
    }
}
