//
//  AddReportTableViewController.swift
//  iMinistry
//
//  Created by Flavio Corpa on 28/12/14.
//  Copyright © 2014 Flavio Corpa. All rights reserved.
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
        if (self.respondsToSelector(Selector("edgesForExtendedLayout"))) {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        if self.report?.date != nil {
            let r = self.report!
            self.title = "Edit Report"
            datePicker.date = r.date
            hoursTimePicker.date = r.hours!
            booksTextField.text = r.books?.stringValue
            magazTextField.text = r.magazines?.stringValue
            brochTextField.text = r.brochures?.stringValue
            returTextField.text = r.return_visits?.stringValue
            studiTextField.text = r.bible_studies?.stringValue
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
        
        //self.view.endEditing(true)
        booksTextField.resignFirstResponder()
        magazTextField.resignFirstResponder()
        brochTextField.resignFirstResponder()
        returTextField.resignFirstResponder()
        studiTextField.resignFirstResponder()
        
        if self.report?.date == nil {
            let report = self.report!
            let managedObjectContext = report.managedObjectContext!
            managedObjectContext.deleteObject(report)
            var e: NSError?
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                e = error
                print("Error at cancel: \(e?.localizedDescription)")
                abort()
            }
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
        report.books = Int(booksTextField.text!)
        report.magazines = Int(magazTextField.text!)
        report.brochures = Int(brochTextField.text!)
        report.return_visits = Int(returTextField.text!)
        report.bible_studies = Int(studiTextField.text!)
        let managedObjContext = report.managedObjectContext!
        
        var e: NSError?
        do {
            try managedObjContext.save()
        } catch let error as NSError {
            e = error
            print("Error at done: \(e?.localizedDescription)")
            abort()
        }
        
        self.didFinish!(self)
    }
}
