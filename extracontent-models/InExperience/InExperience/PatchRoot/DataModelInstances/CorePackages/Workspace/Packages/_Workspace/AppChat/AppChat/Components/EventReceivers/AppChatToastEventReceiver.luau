local AppChat = script:FindFirstAncestor("AppChat")
local HttpService = game:GetService("HttpService")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local ToastNotification = require(AppChatParent.ToastNotification)
local default = require(AppChatParent.ToastNotificationsProtocol).ToastNotificationProtocol.default
local NotificationGroups = ToastNotification.NotificationGroups
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local ShowNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local DismissNotificationSnoozeMenuSignal = ToastNotification.Signals.DismissNotificationSnoozeMenuSignal
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = require(AppChatParent.SharedFlags).GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local t1 = {
	hideAllChatToasts = false,
	isAppChatVisible = false,
	isInExperience = false,
	navigateToChat = function() -- line: 37
	end
}

return function(t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), useLocalization (copy), GetFFlagIsSquadEnabled (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), UniversalAppPolicy (copy), useIsChatEnabled (copy), React (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), default (copy), ShowNotificationSnoozeMenuSignal (copy), NotificationGroups (copy), DismissNotificationSnoozeMenuSignal (copy)
	local v20 = Cryo.Dictionary.join(t1, t2)
	local v21 = useLocalization({
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozeChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications"
	})
	local n1 = 0
	local v23 = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then v20.hideAllChatToasts else v20.isAppChatVisible
	local v24 = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab()
	local v25 = useIsChatEnabled()
	local u26 = v23 or not v25

	React.useEffect(function() -- line: 60
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), default (copy), v20 (copy), ShowNotificationSnoozeMenuSignal (copy), v21 (copy), NotificationGroups (copy)
		local v27 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.ChatNewMessage, function(p1) -- line: 64
			-- upvalues: HttpService (copy), default (copy), v20 (copy), ShowNotificationSnoozeMenuSignal (copy), v21 (copy), NotificationGroups (copy)
			if p1 and (p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "ChatMessageBody" and p1.visualItem.actionEventParams) then
				local data = HttpService:JSONDecode(p1.visualItem.actionEventParams)

				default:dismissNotification(p1.notificationData.id)
				v20.navigateToChat(data.conversationId)
			end

			if p1 and p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "ChatMessageSnoozeSingleMetaAction" then
				ShowNotificationSnoozeMenuSignal:fire({
					context = "Toast",
					description = v21.snoozeDescription,
					notificationType = NotificationGroups.ChatMessageGroup,
					title = v21.snoozeTitle
				})
			end
		end)

		return function() -- line: 96
			-- upvalues: v27 (copy)
			v27()
		end
	end, {
		v20.navigateToChat,
		v21
	})
	React.useEffect(function() -- line: 101
		-- upvalues: default (copy), NotificationTypeEnum (copy), u26 (ref), v24 (copy), n1 (ref)
		local v28 = default:listenToDisplayNotification(function(p2) -- line: 103
			-- upvalues: NotificationTypeEnum (copy), u26 (ref), v24 (copy), default (copy), n1 (ref)
			if p2.notificationType == NotificationTypeEnum.ChatNewMessage then
				if u26 or not v24 then
					default:dismissNotification(p2.notificationId)

					return
				end

				n1 += 1
			end
		end)

		return function() -- line: 114
			-- upvalues: v28 (copy)
			v28:Disconnect()
		end
	end, {
		u26,
		v24
	})

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		React.useEffect(function() -- line: 120
			-- upvalues: v20 (copy), DismissNotificationSnoozeMenuSignal (copy)
			if not v20.isAppChatVisible and DismissNotificationSnoozeMenuSignal then
				DismissNotificationSnoozeMenuSignal:fire()
			end
		end, { v20.isAppChatVisible })
	end
end
