//
//  ConfigModel.swift
//  Autocue
//
//  Created by 老沙 on 2024/7/11.
//

import UIKit

class ConfigModel  {
    static let share = ConfigModel()
    private let config = UserDefaults(suiteName: "config")
    
    enum ViewDirection: Int {
        case horizontal, vertical
        var videoPath: URL? {
            switch self {
            case .horizontal:
                return Bundle.main.url(forResource: "vertical", withExtension: "mp4")
            case .vertical:
                return Bundle.main.url(forResource: "horizontal", withExtension: "mp4")
            }
        }
    }
    
    /// 字体大小
    var font: UIFont {
        get {
            let font = config?.value(forKey: "font") as? CGFloat ?? 15
            return UIFont.systemFont(ofSize: font)
        }
        set {
            config?.setValue(newValue.pointSize, forKey: "font")
        }
    }
    
    /// 字间距
    var kernSpacing: CGFloat {
        get {
            return config?.value(forKey: "kern_spacing") as? CGFloat ?? 1.0
        }
        set {
            config?.setValue(newValue, forKey: "kern_spacing")
        }
    }
    
    /// 行间距
    var lineSpacing: CGFloat {
        get {
            return config?.value(forKey: "line_spacing") as? CGFloat ?? 1.0
        }
        set {
            config?.setValue(newValue, forKey: "line_spacing")
        }
    }
    
    /// 滚动速度
    var scrollSpeed: Float {
        get {
            return config?.value(forKey: "speed") as? Float ?? 1.0
        }
        set {
            config?.setValue(newValue, forKey: "speed")
        }
    }
    
    /// 是否开启镜像
    var isMirror: Bool {
        get {
            return config?.value(forKey: "mirror") as? Bool ?? false
        }
        set {
            config?.setValue(newValue, forKey: "mirror")
        }
    }
    
    /// 视图方向
    var viewDirection: ViewDirection {
        get {
            let value = config?.value(forKey: "view_direction") as? Int ?? 0
            return ViewDirection(rawValue: value) ?? .vertical
        }
        set {
            config?.setValue(newValue.rawValue, forKey: "view_direction")
        }
    }
    
}
