local parent = script.Parent.Parent
local parent2 = parent.Parent

local SharedFlags = require(parent2.SharedFlags)
local GetFFlagGenerateLinkWithChannel = SharedFlags.GetFFlagGenerateLinkWithChannel
local WebViewServiceWrapper = require(parent.utils.WebViewServiceWrapper)

local React = require(parent2.React)

local UrlBuilder = require(parent2.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local LifecycleEvents = require(parent.utils.LifecycleEvents)
local kind = require(parent.type)
local notificationTypeEnum = kind.NotificationTypeEnum
local ToastNotificationsProtocol = require(parent2.ToastNotificationsProtocol)
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local LocalizationService = game:GetService("LocalizationService")
local RobloxAppLocales = require(parent2.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization

local function SecurityEventReceiver()
	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SecurityAlert,
			function(p)
				if not (p and p.notificationData and p.notificationData.notificationType and p.notificationData.clientEventsPayload and p.notificationData.clientEventsPayload.payload and p.notificationData.clientEventsPayload.username) then
					return
				end

				local payload = p.notificationData.clientEventsPayload.payload
				local username = p.notificationData.clientEventsPayload.username
				local url

				if GetFFlagGenerateLinkWithChannel() then
					url = urlBuilder.static.securityAlertWithChannel({
						payload = payload,
						username = username,
						channel = "toast"
					})
				else
					url = urlBuilder.static.securityAlert({ payload = payload, username = username })
				end

				local formatted = Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.SecurityFeedback.Header.NewLogin")

				WebViewServiceWrapper.new({ title = formatted, url = url }):open()

				default:dismissNotification(p.notificationData.id)
			end
		)

		return function()
			callback()
		end
	end, {})
end

return SecurityEventReceiver
