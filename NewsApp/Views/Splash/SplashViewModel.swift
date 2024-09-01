//
//  SplashViewModel.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation
import UserNotifications

protocol SplashViewModelProtocol: AnyObject {
    func didAskPermissionNotification(granted: Bool)
    func didFailWithError(error: Error)
}

class SplashViewModel {
    weak var delegate: SplashViewModelProtocol?
    
    func askPermissionNotification() async {
        let center = UNUserNotificationCenter.current()
        
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            delegate?.didAskPermissionNotification(granted: granted)
        } catch {
            delegate?.didFailWithError(error: error)
        }
    }
}
