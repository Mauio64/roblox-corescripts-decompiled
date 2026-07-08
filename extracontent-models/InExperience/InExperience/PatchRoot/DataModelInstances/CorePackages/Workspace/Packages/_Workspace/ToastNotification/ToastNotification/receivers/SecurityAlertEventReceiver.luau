local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GetFFlagGenerateLinkWithChannel = require(ParentParentParent.SharedFlags).GetFFlagGenerateLinkWithChannel
local WebViewServiceWrapper = require(ParentParent.utils.WebViewServiceWrapper)
local React = require(ParentParentParent.React)
local UrlBuilder = require(ParentParentParent.UrlBuilder).UrlBuilder
local LifecycleEvents = require(ParentParent.utils.LifecycleEvents)
local NotificationTypeEnum = require(ParentParent.type).NotificationTypeEnum
local default = require(ParentParentParent.ToastNotificationsProtocol).ToastNotificationProtocol.default
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.RobloxAppLocales).Localization

local function SecurityEventReceiver() -- line: 19
	-- upvalues: React (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), GetFFlagGenerateLinkWithChannel (copy), UrlBuilder (copy), Localization (copy), LocalizationService (copy), WebViewServiceWrapper (copy), default (copy)
	React.useEffect(function() -- line: 20
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), GetFFlagGenerateLinkWithChannel (copy), UrlBuilder (copy), Localization (copy), LocalizationService (copy), WebViewServiceWrapper (copy), default (copy)
		local v13 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SecurityAlert, function(p1) -- line: 24
			-- upvalues: GetFFlagGenerateLinkWithChannel (copy), UrlBuilder (copy), Localization (copy), LocalizationService (copy), WebViewServiceWrapper (copy), default (copy)
			if not p1 or (not p1.notificationData or not p1.notificationData.notificationType or not p1.notificationData.clientEventsPayload or not p1.notificationData.clientEventsPayload.payload or not p1.notificationData.clientEventsPayload.username) then
				return
			end

			local payload = p1.notificationData.clientEventsPayload.payload
			local username = p1.notificationData.clientEventsPayload.username
			local v17 = if not GetFFlagGenerateLinkWithChannel() then UrlBuilder.static.securityAlert({
				payload = payload,
				username = username
			}) else UrlBuilder.static.securityAlertWithChannel({
				channel = "toast",
				payload = payload,
				username = username
			})
			local v18 = Localization.new(LocalizationService.RobloxLocaleId):Format("Feature.SecurityFeedback.Header.NewLogin")

			WebViewServiceWrapper.new({
				title = v18,
				url = v17
			}):open()
			default:dismissNotification(p1.notificationData.id)
		end)

		return function() -- line: 65
			-- upvalues: v13 (copy)
			v13()
		end
	end, {})
end

return SecurityEventReceiver
