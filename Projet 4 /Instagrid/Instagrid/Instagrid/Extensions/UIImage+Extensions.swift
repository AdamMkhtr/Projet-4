//
//  UIImage+Extensions.swift
//  Instagrid
//
//  Created by Adam Mokhtar on 16/12/2019.
//  Copyright © 2019 Adam Mokhtar. All rights reserved.
//

import UIKit

extension UIImage {
  
  class func imageWithView(_ view: UIView) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,
                                           view.isOpaque,
                                           0)
    defer { UIGraphicsEndImageContext() }
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
  }
  
}
