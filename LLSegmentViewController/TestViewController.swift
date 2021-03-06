//
//  LLTestViewController.swift
//  LLSegmentViewController
//
//  Created by lilin on 2018/12/18.
//  Copyright © 2018年 lilin. All rights reserved.
//

import UIKit
import MJRefresh

func LLRandomRGB() -> UIColor {
    return UIColor.init(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1)
}

func factoryCtl(title:String,imageName:String,selectedImageNameStr:String) -> UIViewController {
    let test2Ctl = TestViewController()
    test2Ctl.title = title
    test2Ctl.tabBarItem.image = imageName.isEmpty ? nil : UIImage.init(named: imageName)
    test2Ctl.tabBarItem.selectedImage = selectedImageNameStr.isEmpty ? nil : UIImage.init(named: selectedImageNameStr)
    return test2Ctl
}


class TestViewController: UIViewController {
    var showTableView = true
    var tableView:UITableView!
    
    typealias scrollViewEndDragClosure =  (_ isScrollToTop:Bool)-> Void
    var scrollViewEndDragBlock:scrollViewEndDragClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LLRandomRGB()
        if showTableView == true {
            initSubView()
        }
    }
}

extension TestViewController {
    func initSubView() {
        tableView = addTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(headRefreshAction))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefreshAction))
    }
    
    @objc func headRefreshAction(){
        if tableView.mj_header?.isRefreshing == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:{ [weak self] in
                self?.tableView.mj_header?.endRefreshing()
            })
        }
    }
    
    @objc func footerRefreshAction(){
        if tableView.mj_footer?.isRefreshing == true {
            DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute:{ [weak self] in
                self?.tableView.mj_footer?.endRefreshing()
            })
        }
    }

}

extension TestViewController:UITableViewDelegate,UITableViewDataSource{
    //列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = (self.title ?? "") + "第\(indexPath.row)行"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarItem.badgeValue = "\(indexPath.row)"
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewEndDragBlock?(velocity.y > 0)
    }
}

extension UIViewController{
    func addTableView()->UITableView {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        return tableView
    }
}


