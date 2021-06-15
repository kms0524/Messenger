//
//  ConversationModel.swift
//  Messenger
//
//  Created by 강민성 on 2021/06/14.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
