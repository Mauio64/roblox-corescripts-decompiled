local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local NotificationHelper = require(StreamNotificationsParent.NotificationsCommon).NotificationHelper
local NavigateDownToNotificationSettings = require(StreamNotificationsParent.NavigationRodux).Thunks.NavigateDownToNotificationSettings
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local constants = require(StreamNotifications.constants)

return {
	createOnSettingsActivated = function(b1: boolean, b2: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any)) -- line: 11
		-- upvalues: NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), NavigateDownToNotificationSettings (copy)
		return function() -- line: 17
			-- upvalues: b1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), constants (copy), b2 (copy), p1 (copy), p2 (copy), NavigateDownToNotificationSettings (copy)
			if not b1 then
				return
			end

			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.goToSettingPage, {
				in_app = true,
				sendrVersion = constants.SENDRVersion
			})

			if b2 then
				p1(false)
			end

			p2(NavigateDownToNotificationSettings())
		end
	end
}
