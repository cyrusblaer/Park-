//
//  ParkManagerViewController.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import FoldingCell
import MJRefresh
import ChameleonFramework

class ParkTableViewController: UITableViewController {

    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    var currentUser: User?
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            User.info(phone) { (user) in
                self.currentUser = user
            }
        }
        setup()
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.init(hexString: "ECF3F9")
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: Selector(("headerRefresh")))
        // 现在的版本要用mj_header
        tableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: Selector(("footerRefresh")))
        tableView.mj_footer = footer
        
//        self.shyNavBarManager.scrollView = self.tableView;
        
    }
    @IBAction func addSpaceAction(_ sender: Any) {
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let userType = userInformation["userType"] as! Int
            
            if userType == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSpaceVC") as! AddParkSpaceViewController
                self.present(vc, animated: true, completion: nil)
            }
//            else if userType == 2 {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLotVC") as! AddLotViewController
//                self.present(vc, animated: true, completion: nil)
//            }
        }
        
        
    }
    
    func pushToAddSpaceVC() {
        
    }
    
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        tableView.mj_header.endRefreshing()
    }
    
    // 底部刷新
    var index = 0
    func footerRefresh(){
        print("上拉刷新")
        tableView.mj_footer.endRefreshing()
        // 2次后模拟没有更多数据
        index = index + 1
        if index > 2 {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
}

// MARK: - TableView

extension ParkTableViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 10
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HomeTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}

