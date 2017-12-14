//
//  UARTLogger.swift
//  UART
//
//  Created by kasuhisa on 2016/02/02.
//  Copyright © 2016年 Bascule Inc. All rights reserved.
//

import Foundation

@objc
public protocol UARTLogger
{
    /**
     ログレベルを設定する
     - parameter logLevel: ログ出力レベル
     */
    @objc optional func setLoglevel( _ logLevel:uint )
	/**
	詳細
	- parameter message: メッセージ
	*/
	@objc optional func verbose( _ message:String )
	/**
	デバッグ
	- parameter message: メッセージ
	*/
	@objc optional func debug( _ message:String )
	/**
	情報
	- parameter message: メッセージ
	*/
	@objc optional func info( _ message:String )
	/**
	警告
	- parameter message: メッセージ
	*/
	@objc optional func warn( _ message:String )
	/**
	エラー
	- parameter message: デバッグ
	*/
	@objc optional func error( _ message:String )
}

internal class UARTDefaultLogger:NSObject, UARTLogger
{
    internal var logLevel:uint = 0
    
    func setLoglevel( _ logLevel:uint )
    {
        self.logLevel = logLevel
    }
	func verbose( _ message:String )
	{
        if logLevel <= 0 { NSLog( "[V]\(message)" ) }
	}
	func debug( _ message:String )
	{
		if logLevel <= 1 { NSLog( "[D]\(message)" ) }
	}
	func info( _ message:String )
	{
		if logLevel <= 2 { NSLog( "[I]\(message)" ) }
	}
	func warn( _ message:String )
	{
		if logLevel <= 3 { NSLog( "[W]\(message)" ) }
	}
	func error( _ message:String )
	{
		if logLevel <= 4 { NSLog( "[E]\(message)" ) }
	}
}

internal class UARTMuteLogger:NSObject, UARTLogger
{
    func verbose( message:String )
    {
        
    }
    func debug( message:String )
    {
        
    }
    func info( message:String )
    {
        
    }
    func warn( message:String )
    {
        
    }
    func error( message:String )
    {
        
    }
}

