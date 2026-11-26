local getFFlagGenerateLinkWithChannel = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags").GetFFlagGenerateLinkWithChannel
local WebViewServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/WebViewServiceWrapper")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/UrlBuilder").UrlBuilder
local LifecycleEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/LifecycleEvents")
local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotificationsProtocol").ToastNotificationProtocol.default
local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/RobloxAppLocales").Localization

local function SecurityEventReceiver()
	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SecurityAlert,
			function(p2)
				if not (p2 and p2.notificationData and p2.notificationData.notificationType and p2.notificationData.clientEventsPayload and p2.notificationData.clientEventsPayload.payload and p2.notificationData.clientEventsPayload.username) then
					return
				end

				local payload = p2.notificationData.clientEventsPayload.payload
				local username = p2.notificationData.clientEventsPayload.username
				local v5

				if getFFlagGenerateLinkWithChannel() then
					v5 = urlBuilder.static.securityAlertWithChannel({
						payload = payload,
						username = username,
						channel = "toast"
					})
				else
					v5 = urlBuilder.static.securityAlert({
						payload = payload,
						username = username
					})
				end

				local formatted = localization.new(LocalizationService.RobloxLocaleId):Format("Feature.SecurityFeedback.Header.NewLogin")

				WebViewServiceWrapper.new({ title = formatted, url = v5 }):open()

				default:dismissNotification(p2.notificationData.id)
			end
		)

		return function()
			callback()
		end
	end, {})
end

return SecurityEventReceiver
