//
//  ItemDetailVC.swift
//  DreamLister
//
//  Created by David Santos on 11/05/17.
//  Copyright © 2017 dscode. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topNav = self.navigationController?.navigationBar.topItem {
            topNav.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        genTestData()
        
        getStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = String(describing: item.price)
            detailField.text = item.details
            
            if let picture = item.toImage?.image as? UIImage {
                thumbImg.image = picture
            }
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat{
                    
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    
                    index += 1
                }while(index < stores.count)
                
            }
        }
    }
    
    func genTestData() {
        
        
        if CoreDataUtil.isNotEmpty(entityName: "Store") {
            return
        }
        
        let bestBuy = Store(context: context)
        bestBuy.name = "Best Buy"
        
        let tesla = Store(context: context)
        tesla.name = "Tesla Dealership"
        
        let frys = Store(context: context)
        frys.name = "Frys Electronics"
        
        let amazon = Store(context: context)
        amazon.name = "Amazon"
        
        let target = Store(context: context)
        target.name = "Target"
        
        let kmart = Store(context: context)
        kmart.name = "K Mart"
        
        ad.saveContext()
        
    }
    
    func getStores() {
        
        let fetchRequest : NSFetchRequest<Store> = Store.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let store = stores[row]
        return store.name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stores.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        var item: Item!
        
        if itemToEdit != nil {
            item = itemToEdit
        } else {
            item = Item(context: context)
        }

        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailField.text {
            item.details = details
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        item.created = NSDate()
        
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        item.toImage = picture
        
        ad.saveContext()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
