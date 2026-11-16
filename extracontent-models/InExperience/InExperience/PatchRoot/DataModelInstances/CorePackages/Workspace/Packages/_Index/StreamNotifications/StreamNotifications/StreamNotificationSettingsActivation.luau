local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent

local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationHelper = NotificationsCommon.NotificationHelper
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDownToNotificationSettings = NavigationRodux.Thunks.NavigateDownToNotificationSettings
local analyticsService = require(StreamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local constants = require(StreamNotifications.constants)

return {
	createOnSettingsActivated = function(flag: boolean, flag2: boolean, callback, callback2)
		return function()
			if not flag then
				return
			end

			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.goToSettingPage,
				{ in_app = true, sendrVersion = constants.SENDRVersion }
			)

			if flag2 then
				callback(false)
			end

			callback2(NavigateDownToNotificationSettings())
		end
	end
}
