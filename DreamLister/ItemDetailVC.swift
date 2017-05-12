//
//  ItemDetailVC.swift
//  DreamLister
//
//  Created by David Santos on 11/05/17.
//  Copyright © 2017 dscode. All rights reserved.
//

import UIKit

class ItemDetailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topNav = self.navigationController?.navigationBar.topItem {
            topNav.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }

}
