//
//  SideBarView.swift
//  SideBar
//
//  Created by J Tan on 10/22/18.
//  Copyright © 2018 J Tan. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
import CoreData

protocol SideBarViewDelegate: class {
    func sideBarDidSelectItem(item: String)
    func sideBarViewWillDisappear()
}

let myCornerRadius: CGFloat = 10
let myViewAlpha: CGFloat = 0.3

class SideBarView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SideBarViewDelegate?
    
    var yOffSet: CGFloat = 0.0
    
    var didSetupConstraints = false
    
    private var tableView: UITableView!
    
    let dismissViewButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let viewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        return view
    }()
    
    let sideBarView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 0
        blurEffectView.layer.masksToBounds = true
        view.addSubview(blurEffectView)
        view.backgroundColor = UIColor.white.withAlphaComponent(0)
        view.layer.cornerRadius = 0
        //shadow
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.30
        view.layer.shadowRadius = 0
        if #available(iOS 11.0, *) {
            blurEffectView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        return view
    }()
    
    let threadSample: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        // button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.isEnabled = true
        return button
    }()
    
    let tableHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Bookmarked Threads"
        return label
    }()
    
    var sideBarData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isOpaque = false
        modalPresentationCapturesStatusBarAppearance = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.view.addSubview(viewContainer)
        self.viewContainer.addSubview(self.sideBarView)
        
        sideBarData = ["first", "Second", "third"]
        
        tableView = UITableView(frame: sideBarView.frame, style: UITableView.Style.grouped)
        tableView.register(SideBarTableCell.self, forCellReuseIdentifier: "MyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() //hide empty rows
        tableView.separatorColor = themeDict["seperator"]
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isOpaque = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        //        if bookmarks.count > 1 {
        //            tableView.scrollToTop()
        //        }
        //    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: burgerView.frame.width, height: 20))
        //    footerView.backgroundColor = UIColor.clear
        //    tableView.tableFooterView = footerView
        
        self.sideBarView.addSubview(tableView)
        self.threadSample.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
        
        self.updateViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.20, animations: {
            self.viewContainer.backgroundColor = UIColor.black.withAlphaComponent(myViewAlpha)
            //      self.burgerView.frame.origin.x = self.burgerView.frame.origin.x - self.view.frame.width * 0.8
        }, completion: { (finished: Bool) in
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! SideBarTableCell
        cell.threadLabel.text = sideBarData[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        cell.backgroundColor = .clear
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = themeDict["table"]
        cell.selectedBackgroundView = backgroundView
        
        //cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // self.delegate?.burgerViewWillDisappear()
        UIView.animate(withDuration: 0.20, animations: {
            self.sideBarView.frame.origin.x = self.view.frame.width
            self.viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { (finished: Bool) in
            //self.delegate?.didSelectItem(item: 11402918)
            self.dismiss(animated: false)
            self.delegate?.sideBarDidSelectItem(item: self.sideBarData[indexPath.row])
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bookmarked Threads"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        header.textLabel?.frame = header.frame
    }
    
    @nonobjc func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        //    let direction = panGesture.direction(in: view)
        //    let translation = panGesture.translation(in: view)
        //
        if panGesture.state == .began {
        } else if panGesture.state == .changed {
            // self.navigationController!.view.frame.origin.x = translation.x
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.x >= 500 {
                print("burger dis")
                // self.delegate?.burgerViewWillDisappear()
                UIView.animate(withDuration: 0.20, animations: {
                    self.sideBarView.frame.origin.x = self.view.frame.width
                    self.viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
                }, completion: { (finished: Bool) in
                    self.dismiss(animated: false)
                })
            }
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        UIView.animate(withDuration: 0.20, animations: {
            self.sideBarView.frame.origin.x = 375
            self.viewContainer.backgroundColor = UIColor.black.withAlphaComponent(0)
        }, completion: { (finished: Bool) in
            //self.delegate?.didSelectItem(item: 11402918)
            self.dismiss(animated: false)
        })
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            viewContainer.snp.makeConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom)
                make.right.equalTo(self.view.snp.right)
                make.size.equalTo(CGSize(width: self.view.frame.width, height: self.view.frame.height - yOffSet))
            }
            
            sideBarView.snp.makeConstraints { make in
                make.bottom.equalTo(self.viewContainer.snp.bottom)
                make.right.equalTo(self.viewContainer.snp.right)
                print("burger y offset", self.yOffSet)
                make.size.equalTo(CGSize(width: self.view.frame.width * 0.82, height: self.view.frame.height - yOffSet))
            }
            
            tableView.snp.makeConstraints { make in
                //        make.centerY.equalTo(self.view.snp.centerY)
                make.left.equalTo(self.sideBarView.snp.left)
                make.size.equalTo(sideBarView)
                make.top.equalTo(sideBarView)
                make.bottom.equalTo(sideBarView)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}


