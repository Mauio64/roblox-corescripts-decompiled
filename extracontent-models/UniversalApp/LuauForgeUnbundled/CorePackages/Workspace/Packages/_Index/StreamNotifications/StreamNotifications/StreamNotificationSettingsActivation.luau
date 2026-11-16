local notificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").NotificationHelper
local navigateDownToNotificationSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NavigationRodux").Thunks.NavigateDownToNotificationSettings
local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")

return {
	createOnSettingsActivated = function(p2, p3, callback, callback2)
		return function()
			if not p2 then
				return
			end

			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.goToSettingPage,
				{ in_app = true, sendrVersion = constants.SENDRVersion }
			)

			if p3 then
				callback(false)
			end

			callback2(navigateDownToNotificationSettings())
		end
	end
}
