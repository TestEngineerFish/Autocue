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
        case vertical, horizontal
        var videoPath: URL? {
            switch self {
            case .vertical:
                return Bundle.main.url(forResource: "vertical", withExtension: "mp4")
            case .horizontal:
                return Bundle.main.url(forResource: "horizontal", withExtension: "mp4")
            }
        }
    }
    
    /// 字体大小比例
    var fontScale: CGFloat {
        get {
            let value = config?.value(forKey: "font_scale") as? CGFloat ?? 0.5
            return value
        }
        set {
            let value = max(0.1, newValue)
            config?.setValue(value, forKey: "font_scale")
        }
    }
    
    /// 字间距
    var kernScale: CGFloat {
        get {
            return config?.value(forKey: "kern_scale") as? CGFloat ?? 0.5
        }
        set {
            let value = max(0.1, newValue)
            config?.setValue(value, forKey: "kern_scale")
        }
    }
    
    /// 行间距
    var lineScale: CGFloat {
        get {
            return config?.value(forKey: "line_scale") as? CGFloat ?? 0.5
        }
        set {
            let value = max(0.1, newValue)
            config?.setValue(value, forKey: "line_scale")
        }
    }
    
    /// 滚动速度
    var speedScale: CGFloat {
        get {
            return config?.value(forKey: "speed_scale") as? CGFloat ?? 0.5
        }
        set {
            let value = max(0.1, newValue)
            config?.setValue(value, forKey: "speed_scale")
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
