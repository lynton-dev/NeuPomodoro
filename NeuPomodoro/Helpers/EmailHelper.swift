//
//  EmailHelper.swift
//  NeuPomodoro
//
//  Created by Lynton Schoeman on 2023-04-24.
//

import SwiftUI


final class EmailHelper {
    public static let shared = EmailHelper()
    
    func sendEmail(to:String, subject:String, completion: @escaping (Bool) -> Void) {
        var mailto = "mailto:\(to)?subject=\(subject)"
        mailto = mailto.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? mailto
        
        var canSendMail = false
        
        #if os(iOS)
        if let emailURL = URL(string: mailto), UIApplication.shared.canOpenURL(emailURL)
        {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
            canSendMail = true
        }
        #else
        if let url = URL(string: mailto) {
            NSWorkspace.shared.open(url)
            canSendMail = true
        }
        #endif
        
        completion(canSendMail)
    }
}
