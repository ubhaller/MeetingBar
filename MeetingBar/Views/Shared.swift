//
//  Shared.swift
//  MeetingBar
//
//  Created by Andrii Leitsius on 13.01.2021.
//  Copyright © 2021 Andrii Leitsius. All rights reserved.
//

import SwiftUI
import Defaults
import UserNotifications

struct JoinEventNotificationPicker: View {
    @Default(.joinEventNotification) var joinEventNotification
    @Default(.joinEventNotificationTime) var joinEventNotificationTime

    func checkNotificationSettings() -> (Bool, Bool) {
        var noAlertStyle = false
        var notificationsDisabled = false

        let center = UNUserNotificationCenter.current()
        let group = DispatchGroup()
        group.enter()

        center.getNotificationSettings { notificationSettings in
            noAlertStyle = notificationSettings.alertStyle != UNAlertStyle.alert
            notificationsDisabled = notificationSettings.authorizationStatus == UNAuthorizationStatus.denied
            group.leave()
        }

        group.wait()
        return (noAlertStyle, notificationsDisabled)
    }


    var body: some View {
        HStack {
            Toggle("shared_send_notification_toggle".loco(), isOn: $joinEventNotification)
            Picker("", selection: $joinEventNotificationTime) {
                Text("shared_send_notification_directly_value".loco()).tag(JoinEventNotificationTime.atStart)
                Text("shared_send_notification_one_minute_value".loco()).tag(JoinEventNotificationTime.minuteBefore)
                Text("shared_send_notification_three_minute_value".loco()).tag(JoinEventNotificationTime.threeMinuteBefore)
                Text("shared_send_notification_five_minute_value".loco()).tag(JoinEventNotificationTime.fiveMinuteBefore)
            }.frame(width: 150, alignment: .leading).labelsHidden().disabled(!joinEventNotification)
        }
        let (noAlertStyle, disabled) = checkNotificationSettings()

        if noAlertStyle && !disabled && joinEventNotification {
            Text("shared__send_notification_no_alert_style_tip".loco()).foregroundColor(Color.gray).font(.system(size: 12))
        }

        if disabled && joinEventNotification {
            Text("shared_send_notification_disabled_tip".loco()).foregroundColor(Color.gray).font(.system(size: 12))
        }
    }
}
