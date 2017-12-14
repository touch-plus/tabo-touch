//
//  Queue.swift
//  TaboDemo1
//
//  Created by Michiyasu Wada on 2016/01/07.
//  Copyright © 2016年 Michiyasu Wada. All rights reserved.
//
//
//  # ---- Usage ----
//
//  let queue:Queue = Queue()
//  queue.sleep(1.5)
//  queue.append({()
//      print("1")
//  })
//  queue.sleep(2)
//  queue.append({(queue:Queue) in
//      print("2")
//      queue.insert({(queue:Queue) in
//          print("3")
//          queue.next()
//      })
//      queue.next()
//  })
//  queue.append({()
//      print("4")
//  })
//  queue.append(CustomTask())
//  queue.run()
//

import Foundation

class Queue {
    
    private var list:[(_ queue:Queue)->Void] = []
    
    var data:Any?
    var running:Bool = false
    var aborted:Bool = false
    
    private var _timer:Timer?
    
    init()
    {
        
    }
    deinit
    {
        if let timer:Timer = _timer
        {
            timer.invalidate()
        }
        self.list.removeAll()
        self.data = nil
        self.running = false
        self.aborted = false
        self._timer = nil
    }
    
    public func sleep(_ time:TimeInterval)
    {
        self.append({ (queue:Queue) in
            self._timer = self._setTimeout(delay: time, block: self.next)
        })
    }
    
    public func sleep(_ time:Float)
    {
        self.append({ (queue:Queue) in
            self._timer = self._setTimeout(delay: TimeInterval(time), block: self.next)
        })
    }
    
    public func run()
    {
        aborted = false
        running = true
        next()
    }
    
    public func abort()
    {
        aborted = true
    }
    
    public func done()
    {
        
    }
    
    public func append(_ task: @escaping (_ queue:Queue)-> Void)
    {
        list.append(task)
    }
    
    public func append(_ task: @escaping ()-> Void)
    {
        list.append({ (queue:Queue) in
            task()
            queue.next()
        })
    }
    
    public func append(_ task:ITask)
    {
        list.append(task.doIt)
    }
    
    public func insert(_ task: @escaping (_ queue:Queue)-> Void)
    {
        list.insert( task, at:0 )
    }
    
    public func insert(_ task: @escaping ()-> Void)
    {
        list.insert( { (queue:Queue) in
            task()
            queue.next()
            }, at:0 )
    }
    
    public func insert(_ task:ITask)
    {
        list.insert( task.doIt, at:0 )
    }
    
    public func next()
    {
        if !running
        {
            return
        }
        if aborted
        {
            if let timer:Timer = self._timer
            {
                timer.invalidate()
            }
            self._timer = nil
            return
        }
        self._timer = nil
        if hasNext()
        {
            _doTask()
        }
        else
        {
            running = false
            done()
        }
    }
    
    public func hasNext() -> Bool
    {
        return list.count > 0
    }
    
    private func _doTask()
    {
        let task:((_ queue:Queue)->Void)? = list.remove(at: list.startIndex)
        if task != nil
        {
            task!(self)
        }
    }
    
    private func _setTimeout(delay:TimeInterval, block:@escaping ()->Void) -> Timer
    {
        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
}

protocol ITask
{
    func doIt(_ queue:Queue) -> Void
}

class Task:ITask
{
    var queue:Queue?
    
    init(){}
    deinit
    {
        self.queue = nil
    }
    
    func doIt(_ queue:Queue) -> Void
    {
        self.queue = queue
        operation()
    }
    
    func operation()
    {
        self.done()
    }
    
    func done()
    {
        if let _queue:Queue = self.queue
        {
            _queue.next()
        }
        self.queue = nil
    }
}

