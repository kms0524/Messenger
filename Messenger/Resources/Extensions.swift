//
//  Extensions.swift
//  Messenger
//
//  Created by 강민성 on 2021/05/18.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
}

extension Notification.Name {
    /// 사용자가 로그인할때의 Noti
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
