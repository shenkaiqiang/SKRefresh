//
//  SKRefreshHeader.swift
//  shen
//
//  Created by 沈凯强 on 2021/01/01.
//  Copyright © 2021 mn. All rights reserved.
//

import UIKit

class SKRefreshHeader: SKRefreshBase {
    /// 刷新的各个状态
    enum RefreshState:String {
        ///普通状态(nomal state)
        case normal = "下拉即可刷新"
        ///将要刷新(will refresh state)
        case willRefresh = "松开立即刷新"
        ///正在刷新(refreshing state)
        case refreshing = "正在刷新数据"
        ///刷新完成(refreshed state)
        case refreshed = "刷新完成"
    }
    
    var headerBlock:(()->Void)?
    
    // 记录顶部刷新状态 set方法,当状态发生改变时，调用
    private var refreshState: RefreshState = .normal {
        didSet{
            refreshStateChanged(refreshState: refreshState)
            switch refreshState {
            case .normal:
                break
            case .willRefresh:
                break
            case .refreshing:
                showHeaderView()
                // 开始刷新
                headerBlock?()
            case .refreshed:
                hiddenHeaderView()
            }
        }
        
    }
    /// 更新视图内容
    func refreshStateChanged(refreshState:RefreshState) {
        
    }
    
    override func scrollViewContentOffsetDidChangedInHeader(scrollView: UIScrollView, offsetY: CGFloat) {
        // 父视图偏移量,上滑,返回
        if offsetY >= 0{
            return
        }
        // 当前是正在刷新状态,返回
        if refreshState == .refreshing {
            return
        }
        //定义新的头部刷新状态（待会要判断状态是否发生改变，没改变就不用刷新）
        var newState =  refreshState
        if offsetY >= -SKRefreshConstant.headerHeight {
            //小余临界值，正常状态
            newState = .normal
        } else {
            //到达临界值时
            if scrollView.isDragging {
                //手指未松开，保持预备刷新状态
                newState = .willRefresh
            } else if newState == .willRefresh {
                //手指松开，立即进入开始刷新状态
                newState = .refreshing
            }
        }
        //如果头部刷新状态发生了改变就更新
        if refreshState != newState {
            refreshState = newState
        }
    }
    
    /// 开始刷新
    func beginRefresh() {
        if refreshState != .refreshing {
            refreshState = .refreshing
        }
    }
    /// 结束刷新
    func endRefresh() {
        if refreshState == .refreshing {
            refreshState = .refreshed
        }
    }
    
}
