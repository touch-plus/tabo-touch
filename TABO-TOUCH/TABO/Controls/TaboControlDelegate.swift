//
//  TaboControlDelegate.swift
//  TABO-TOUCH
//
//  Created by 和田教寧 on 2017/09/13.
//  Copyright © 2017年 Michiyasu Wada. All rights reserved.
//

import Foundation

protocol TaboControlDelegate
{
    /// 接続通知
    func didConnect()
    
    /// 切断通知
    func didDisconnect()
    
    ///
    func didReceiveCommand( response:String )
    
    ///
    func didSendCommand(_ tabo:TABO, _ command:String )
}
