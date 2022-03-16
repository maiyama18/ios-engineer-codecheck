//
//  UIViewController+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by maiyama on 2022/03/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import SwiftUI

extension UIViewController {
    public func hostSwiftUIView<Content: View>(_ rootView: Content) {
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        view.addSubview(hostingVC.view)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        hostingVC.view.pinEdgesToSuperView()
    }
}
