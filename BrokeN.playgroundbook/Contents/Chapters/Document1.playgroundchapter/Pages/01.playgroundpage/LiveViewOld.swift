//
//  LiveView.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let liveViewController: InitialPageViewController = InitialPageViewController.makeFromStoryboard()
page.liveView = liveViewController
