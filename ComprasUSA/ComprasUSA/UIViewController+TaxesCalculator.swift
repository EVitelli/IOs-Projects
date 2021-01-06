//
//  UIViewController+TaxesCalculator.swift
//  ComprasUSA
//
//  Created by Erik Vitelli on 09/05/19.
//  Copyright © 2019 IOS. All rights reserved.
//

import UIKit

extension UIViewController{
    var taxesCalculator: TaxesCalculator{
        return TaxesCalculator.shared
    }
}
