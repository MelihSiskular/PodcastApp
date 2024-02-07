//
//  Extension.swift
//  PodcastSwift
//
//  Created by Melih Şişkular on 1.02.2024.
//

import Foundation
import UIKit
import CoreMedia

extension UIImageView { //sürekkli bu işlemi yapıyoruz diye extension yazdık artık bunu çağırınca bizim işlemler tek satırda olcak!
    func customMode() {
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension CMTime {
    func formatString() -> String {
        let totalSecond = Int(CMTimeGetSeconds(self))
        let second = totalSecond % 60
        let minutes = totalSecond / 60
        let formatString = String(format: "%02d : %02d", minutes,second)
        return formatString
    }
}

extension NSNotification.Name {
    static let downloadNotificationName = NSNotification.Name("downloadNotificationName")
}
