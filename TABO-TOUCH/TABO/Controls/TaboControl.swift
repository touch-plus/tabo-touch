//
//  TaboControl.swift
//  TaboDemo1
//
//  Created by Michiyasu Wada on 2016/01/04.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class TaboControl:NSObject, TaboControlDelegate
{
    internal var tabo:TABO!
    internal var uart:UART!
    internal var uuid:String!
    internal var autoConnect:Bool = false
    internal let delegate:TaboControlDelegateList = TaboControlDelegateList()
    
    private var _sendTime:TimeInterval = NSDate().timeIntervalSince1970
    private var _nextCommand:String?
    private var _timer:Timer?
    private var _nameList:TABOScanList = TABOScanList()
    
    public var isReady:Bool = false
    
    
    init(tabo:TABO)
    {
        super.init()
        
        self.tabo = tabo
        self.delegate += self
    }
    
    deinit
    {
    }
    
    public func connect()
    {
        UART.logger = UARTMuteLogger()
        self.uart = UART.sharedInstance
        self.uart.addDelegate( self, delegate:self )
        self._startScan()
    }
    
    private func _startScan()
    {
        if (self.uuid != nil)
        {
            return
        }
        
        let removedList = self._nameList.getRemovedList()
        for removed:TABOName in removedList
        {
            print(removed.name)
            TABO.ui.removeConnect(removed.name)
        }
        self._nameList.clear()
        self.uart.stopScan()
        self.uart.startScan(false)
        _ = setTimeout(1, block: {()
            self._startScan()
        })
    }
    
    public func disconnect()
    {
        if self.uart != nil && self.uuid != nil
        {
            self.uart.disconnect(self.uuid)
        }
        if self.uart != nil
        {
            self.uart.removeDelegate(self)
        }
        self.uuid = nil
        self.uart = nil
    }
    
    public func send(_ cmd:String)
    {
        if self.uuid != nil
        {
            let time:TimeInterval = NSDate().timeIntervalSince1970
            if time < _sendTime
            {
                _nextCommand = cmd
                return
            }
            
            if _nextCommand != nil
            {
                _emit(_nextCommand!)
                _nextCommand = nil
                _sendTime = time + 0.04
            }
            else
            {
                _emit(cmd)
                _sendTime = time + 0.04
            }
        }
    }
    
    public func next(_ cmd:String)
    {
        _nextCommand = cmd
        self.send(cmd)
    }
    
    public func clear()
    {
        _nextCommand = nil
    }
    
    private func _emit(_ cmd:String)
    {
        self.uart.writeString(self.uuid, string: cmd)
        delegate.forEach() { (delegate:TaboControlDelegate?) in
            delegate?.didSendCommand(self.tabo, cmd)
        }
    }
    
    private func frameUpdate()
    {
        if self.uuid != nil && _nextCommand != nil
        {
            let time:TimeInterval = NSDate().timeIntervalSince1970
            if time < _sendTime { return }
            
            if _nextCommand != nil
            {
                send(_nextCommand!)
            }
        }
    }
    
    /// 接続通知
    internal func didConnect()
    {
        _timer = setInterval(1/30, block:frameUpdate)
    }
    
    /// 切断通知
    internal func didDisconnect()
    {
        _timer?.invalidate()
        disconnect()
    }
    
    ///
    internal func didSendCommand(_ tabo:TABO, _ command:String )
    {
//        print(command)
    }
    
    ///
    internal func didReceiveCommand( response:String )
    {
        
    }
    
}


extension TaboControl:UARTDelegate
{
    
    /**
     準備が完了した場合に呼ばれる
     */
    func didReady(_ uuid:String )
    {
        print( "準備完了：didReady:\(uuid)" )
        self.uuid = uuid
        self.isReady = true
        delegate.forEach() { (delegate:TaboControlDelegate?) in
            delegate?.didConnect()
        }
    }
    /**
     データを受信した場合に呼ばれる
     
     - parameter data: バイトデータ
     */
    func didReceiveDataByte( _ uuid:String, data:Data )
    {
        var string:String = NSString( data:data as Data, encoding:String.Encoding.utf8.rawValue )! as String
        string = string.replacingOccurrences(of: "\0", with:"", options:[], range:nil )
//        print( "データ受信：didReceiveDataByte:\(string)" )
        delegate.forEach() { (delegate:TaboControlDelegate?) in
            delegate?.didReceiveCommand(response: string)
        }
    }
    
    /**
     ハードウェアリビジョン文字列を受信した場合に呼ばれる
     
     - parameter data: 受信文字列データ
     */
    func didReadHardwareRevisionString( _ uuid:String, data:String )
    {
         print( "リビジョン取得：didReadHardwareRevisionString" )
    }
    
    /**
     セントラルマネージャの状態変化が変化した場合に呼ばれる
     
     - parameter state: 状態
     */
    func didUpdateState( state:UARTCentralState )
    {
         print( "状態変更：didUpdateState:\(state)" )
    }
    
    /**
     スキャン結果を受け取る
     
     - parameter peripheral: ペリフェラル
     - parameter advertisementData: アドバタイズデータ
     - parameter RSSI: 電波強度
     */
    func didDiscoverPeripheral( _ uuid:String, advertisementData:[AnyHashable: Any]!, RSSI:NSNumber! )
    {
        var name:String? = advertisementData["kCBAdvDataLocalName"] as? String
        if( name == nil ){
            name = "no name";
        }
        
        _nameList.add(TABOName(uuid, name!))
        
        TABO.ui.addConnect(String(name!), callback: { ()
            if self.uart != nil && (self.uuid == nil || AppConfig.MULTI_CONNECTION)
            {
                self.uuid = uuid
                self.uart.connect( uuid, retry:false )
                self.uart.stopScan()
                print( "接続：Did discover peripheral:\(name!):::\(uuid)" )
            }
        })
    }
    
    /**
     ペリフェラルとの接続が成功すると呼ばれる
     
     - parameter peripheral: ペリフェラル
     */
    func didConnectPeripheral( _ uuid:String )
    {
        print( "コネクト成功：didConnectPeripheral:\(uuid)" )
        TABO.ui.clear()
        TABO.ui.hide()
    }
    
    /**
     ペリフェラルへの接続が失敗すると呼ばれる
     
     - parameter peripheral: ペリフェラル
     - parameter error: エラー
     */
    func didFailToConnectPeripheral( _ uuid:String, error:NSError! )
    {
        print( "コネクト失敗：didFailToConnectPeripheral:\(uuid)" )
    }
    
    /**
     ペリフェラルとの接続が切断されると呼ばれる
     
     - parameter peripheral: ペリフェラル
     */
    func didDisconnectPeripheral( _ uuid:String )
    {
        print( "切断：didDisconnectPeripheral:\(uuid)" )
        delegate.forEach() { (delegate:TaboControlDelegate?) in
            delegate?.didDisconnect()
        }
    }
    
    /**
     ペリフェラルのRSSIが更新されると呼ばれる
     
     - parameter peripheral: ペリフェラル
     */
    func didReadRSSI( uuid:String, RSSI:NSNumber )
    {
        print( "uuid:\(uuid), RSSI:\(RSSI)" )
    }
}

class TaboControlDelegateList
{
    private let _delegates:NSHashTable<AnyObject> = NSHashTable<AnyObject>()
    
    static func += (left: TaboControlDelegateList, right: TaboControlDelegate)
    {
        left._delegates.add(right as AnyObject)
    }
    
    static func -= (left: TaboControlDelegateList, right: TaboControlDelegate)
    {
        left._delegates.remove(right as AnyObject)
    }
    
    func forEach(_ block:@escaping (_ delegate:TaboControlDelegate?)-> Void)
    {
        _delegates.objectEnumerator().enumerated()
            .map { $0.element as? TaboControlDelegate }
            .forEach { block($0) }
    }
}

class TABOScanList
{
    var list:[TABOName] = []
    var oldList:[TABOName] = []
    
    func clear()
    {
        oldList = list
        list = []
    }
    
    func getRemovedList() -> [TABOName]
    {
        var result:[TABOName] = []
        for old:TABOName in oldList
        {
            var has:Bool = false
            for current:TABOName in list
            {
                if current.uuid == old.uuid
                {
                    has = true
                    break
                }
            }
            if has == false
            {
                result.append(old)
            }
        }
        return result
    }
    
    func add(_ item:TABOName)
    {
        list.append(item)
    }
    
    func getName(_ uuid:String) -> String
    {
        for item:TABOName in list
        {
            if item.uuid == uuid
            {
                return item.name
            }
        }
        return ""
    }
}

class TABOName
{
    var uuid:String
    var name:String
    
    init(_ uuid:String, _ name:String)
    {
        self.uuid = uuid
        self.name = name
    }
}
