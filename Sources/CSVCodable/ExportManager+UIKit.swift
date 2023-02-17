//
//  ExportManager+UIKit.swift
//  
//
//  Created by Anna Münster on 14.02.23.
//

import Foundation

#if canImport(UIKit)
import UIKit

extension ExportManager {
    /**
     Opens ActivityViewController for Sharing- and Saving-Options
     */
    public static func share(url: URL, viewController: UIViewController, completion: (() -> Void)? = nil) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        if let completion = completion {
            activityVC.completionWithItemsHandler = {_, _, _, _ in
                completion()
            }
        }
        viewController.present(activityVC, animated: true)
    }
}
#endif
