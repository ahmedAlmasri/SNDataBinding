//Copyright (c) 2018 ahmedAlmasri <ahmed.almasri@ymail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation
import UIKit

var UndefinedObjectsDictKey = "UndefinedObjectsDict"

open class Bindable: NSObject { 
    
   open func toDictionary() -> NSDictionary {
        
        let aClass : AnyClass? = type(of: self.self)
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass  = class_copyPropertyList(aClass, &propertiesCount)
        
        let propertiesDictionary : NSMutableDictionary = NSMutableDictionary()
        
        for i in 0 ..< Int(propertiesCount) {
            let strKey : NSString? = NSString(cString: property_getName(propertiesInAClass![i]), encoding: String.Encoding.utf8.rawValue)
            propertiesDictionary.setValue(self.value(forKey: strKey! as String), forKey: strKey! as String)
        }
        return propertiesDictionary
    }
}


extension UIView {
    
    open override  func setValue(_ value: Any?, forUndefinedKey key: String) {
        
        var undefinedDict:NSMutableDictionary?  = nil
        
        if objc_getAssociatedObject(self, &UndefinedObjectsDictKey) != nil {
            
            undefinedDict = (objc_getAssociatedObject(self, &UndefinedObjectsDictKey) as? NSMutableDictionary)
            
        }else{
            
            undefinedDict = NSMutableDictionary()
            objc_setAssociatedObject(self, &UndefinedObjectsDictKey, undefinedDict, .OBJC_ASSOCIATION_RETAIN)
        }
        
        undefinedDict?[key] =  value
        
        print(undefinedDict!.count)
    }
    
    
    open override func value(forUndefinedKey key: String) -> Any? {
        var undefinedDict:NSMutableDictionary? = nil
        if (objc_getAssociatedObject(self, &UndefinedObjectsDictKey) != nil) {
            undefinedDict = objc_getAssociatedObject(self, &UndefinedObjectsDictKey) as? NSMutableDictionary
            return (undefinedDict?.value(forKey: key) as? String)
        }
        else {
            return nil
        }
    }
    
   open func bind(withObject obj: NSDictionary) {
        
        let undefinedKeys = self.undefinedKeys()
        
        if let undefinedKeys = undefinedKeys {
            
            if undefinedKeys.count > 0 {
                for key in undefinedKeys {
                    if (key.count > 4) && ((key as NSString).substring(to: 4) == "bind") {
                        let keyToBind: String? = (key as NSString).substring(from: 4)
                        let keyValue: String? = (self.value(forKey: key) as? String)
                        
                        //  print(obj.value(forKeyPath: "a.@count") as? NSNumber)
                        
                        if let keyValue = keyValue {
                        if obj.value(forKeyPath: keyValue) is NSNumber && keyToBind != "value"{
                            self.setValue("\(obj.value(forKeyPath: keyValue) ?? "")", forKey: keyToBind!)
                            
                        }else{
                            if obj.value(forKeyPath: keyValue) != nil {
                                if let keyToBind = keyToBind {
                                self.setValue(obj.value(forKeyPath: keyValue), forKey: keyToBind)
                                }
                            }
                        }
                    }
                    }
                }
            }
        }
        for subview: UIView in self.subviews {
            subview.bind(withObject: obj)
        }
        
    }
    
    
    private  func undefinedKeys()->[String]?{
        
        if objc_getAssociatedObject(self, &UndefinedObjectsDictKey) != nil {
            
            let undefinedDict = (objc_getAssociatedObject(self, &UndefinedObjectsDictKey) as? NSDictionary)
            
            return undefinedDict?.allKeys as! [String]?
        }
        return nil
    }
    
    
    
}
