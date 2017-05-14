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

    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailField: CustomTextField!
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var storeBtn: UIButton!
        @IBOutlet weak var itemTypeBtn: UIButton!
    
    var stores = [Store]()
    var itemTypes = [ItemType]()
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topNav = self.navigationController?.navigationBar.topItem {
            topNav.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        storePicker.tag = 1
        typePicker.delegate = self
        typePicker.dataSource = self
        typePicker.tag = 2
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        genStoreData()
        
        getStores()
        
        genItemTypeData()
        
        getItemTypes()
        
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
                
                storeBtn.setTitle(store.name, for: .normal)
                
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
            
            if let itemType = item.toItemType {
                itemTypeBtn.setTitle(itemType.type, for: .normal)
                
                var index2 = 0
                
                repeat {
                    
                    let s = itemTypes[index2]
                    if s.type == itemType.type {
                        typePicker.selectRow(index2, inComponent: 0, animated: false)
                        break
                    }
                    
                    index2 += 1
                    
                } while(index2 < itemTypes.count)
            }
        }
    }
    
    func genItemTypeData() {
        
        
        if CoreDataUtil.isNotEmpty(entityName: "ItemType") {
            return
        }
        
        let car = ItemType(context: context)
        car.type = "Car"
        
        let electronic = ItemType(context: context)
        electronic.type = "Electronics"
        
        let computer = ItemType(context: context)
        computer.type = "Computers"
        
        let hgt = ItemType(context: context)
        hgt.type = "Home, Garden & Tools"
        
        let sports = ItemType(context: context)
        sports.type = "Sports"
        
        let toys = ItemType(context: context)
        toys.type = "Toys"
        
        let kids = ItemType(context: context)
        kids.type = "Kids"
        
        let baby = ItemType(context: context)
        baby.type = "Baby"
        
        let clothing = ItemType(context: context)
        clothing.type = "Clothing"
        
        let shoes = ItemType(context: context)
        shoes.type = "Shoes"
        
        let jewelry = ItemType(context: context)
        jewelry.type = "Jewelry"
        
        let health = ItemType(context: context)
        health.type = "Health"
        
        ad.saveContext()
        
    }

    func genStoreData() {
        
        
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

    func getItemTypes() {
        
        let fetchRequest : NSFetchRequest<ItemType> = ItemType.fetchRequest()
        let sort = NSSortDescriptor(key: "type", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            self.typePicker.reloadAllComponents()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            
            let store = stores[row]
            return store.name
            
        } else {
            
            let itemType = itemTypes[row]
            return itemType.type
            
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            
            return stores.count
            
        } else {
            
            return itemTypes.count
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            
            let store = stores[row]
            storeBtn.setTitle(store.name, for: .normal)
            
        } else {
            
            let type = itemTypes[row]
            itemTypeBtn.setTitle(type.type, for: .normal)
            
        }
        
        pickerView.isHidden = true
        
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
        
        item.toItemType = itemTypes[typePicker.selectedRow(inComponent: 0)]
        
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
    
    @IBAction func storeBtnPressed(_ sender: UIButton) {
        
        storePicker.isHidden = false
        typePicker.isHidden = true
        
    }
    @IBAction func itemTypeBtnPressed(_ sender: UIButton) {
        
        storePicker.isHidden = true
        typePicker.isHidden = false
        
    }
}
