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
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local t1 = {
	hideAllChatToasts = false,
	isAppChatVisible = false,
	isInExperience = false,
	navigateToChat = function() -- line: 38
	end
}

return function(t2: {[any]: any}) -- line: 41
	-- upvalues: Cryo (copy), t1 (copy), useLocalization (copy), FFlagExpChatEnableFriendsTab (copy), GetFFlagIsSquadEnabled (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), UniversalAppPolicy (copy), useIsChatEnabled (copy), React (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), default (copy), ShowNotificationSnoozeMenuSignal (copy), NotificationGroups (copy), DismissNotificationSnoozeMenuSignal (copy)
	local v21 = Cryo.Dictionary.join(t1, t2)
	local v22 = useLocalization({
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = if not FFlagExpChatEnableFriendsTab then not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozeChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications" else "Feature.Chat.Label.MuteInGameChatToastNotifications"
	})
	local n1 = 0
	local v24 = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then v21.hideAllChatToasts else v21.isAppChatVisible
	local v25 = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab()
	local v26 = useIsChatEnabled()
	local u27 = v24 or not v26

	React.useEffect(function() -- line: 62
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), default (copy), v21 (copy), ShowNotificationSnoozeMenuSignal (copy), v22 (copy), NotificationGroups (copy)
		local v28 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.ChatNewMessage, function(p1) -- line: 66
			-- upvalues: HttpService (copy), default (copy), v21 (copy), ShowNotificationSnoozeMenuSignal (copy), v22 (copy), NotificationGroups (copy)
			if p1 and (p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "ChatMessageBody" and p1.visualItem.actionEventParams) then
				local data = HttpService:JSONDecode(p1.visualItem.actionEventParams)

				default:dismissNotification(p1.notificationData.id)
				v21.navigateToChat(data.conversationId)
			end

			if p1 and p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "ChatMessageSnoozeSingleMetaAction" then
				ShowNotificationSnoozeMenuSignal:fire({
					context = "Toast",
					description = v22.snoozeDescription,
					notificationType = NotificationGroups.ChatMessageGroup,
					title = v22.snoozeTitle
				})
			end
		end)

		return function() -- line: 98
			-- upvalues: v28 (copy)
			v28()
		end
	end, {
		v21.navigateToChat,
		v22
	})
	React.useEffect(function() -- line: 103
		-- upvalues: default (copy), NotificationTypeEnum (copy), u27 (ref), v25 (copy), n1 (ref)
		local v29 = default:listenToDisplayNotification(function(p2) -- line: 105
			-- upvalues: NotificationTypeEnum (copy), u27 (ref), v25 (copy), default (copy), n1 (ref)
			if p2.notificationType == NotificationTypeEnum.ChatNewMessage then
				if u27 or not v25 then
					default:dismissNotification(p2.notificationId)

					return
				end

				n1 += 1
			end
		end)

		return function() -- line: 116
			-- upvalues: v29 (copy)
			v29:Disconnect()
		end
	end, {
		u27,
		v25
	})

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		React.useEffect(function() -- line: 122
			-- upvalues: v21 (copy), DismissNotificationSnoozeMenuSignal (copy)
			if not v21.isAppChatVisible and DismissNotificationSnoozeMenuSignal then
				DismissNotificationSnoozeMenuSignal:fire()
			end
		end, { v21.isAppChatVisible })
	end
end
