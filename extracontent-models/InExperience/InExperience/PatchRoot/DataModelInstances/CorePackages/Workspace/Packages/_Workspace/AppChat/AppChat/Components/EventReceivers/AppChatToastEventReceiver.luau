local AppChat = script:FindFirstAncestor("AppChat")
local HttpService = game:GetService("HttpService")

local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local NotificationGroups = ToastNotification.NotificationGroups

local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local shouldHideFriendsChatToast = require(script.Parent.shouldHideFriendsChatToast)

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local ShowNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local DismissNotificationSnoozeMenuSignal = ToastNotification.Signals.DismissNotificationSnoozeMenuSignal

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatToastChatTerminologyFixEnabled = SharedFlags.FFlagAppChatToastChatTerminologyFixEnabled

local v = {
	hideAllChatToasts = false,
	isAppChatVisible = false,
	isInExperience = false,
	navigateToChat = function() end
}

return function(p)
	local joined = Cryo.Dictionary.join(v, p)
	local snoozeTitle

	if FFlagAppChatToastChatTerminologyFixEnabled and FFlagExpChatEnableFriendsTab then
		snoozeTitle = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
			and "Feature.Chat.Label.MuteInGameChatToastNotifications"
			or "Feature.Chat.Label.MuteInGamePartyToastNotifications"
	else
		snoozeTitle = FFlagExpChatEnableFriendsTab and "Feature.Chat.Label.MuteInGameChatToastNotifications"
			or GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozePartyNotifications"
			or "Feature.Chat.Label.SnoozeChatNotifications"
	end

	local v2 = useLocalization({
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = snoozeTitle
	})
	local v3

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		v3 = joined.isAppChatVisible
	else
		v3 = joined.hideAllChatToasts
	end

	local canSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab()

	local v4 = useIsChatEnabled()
	local v5 = v3 or not v4

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.ChatNewMessage,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "ChatMessageBody"
					and data.visualItem.actionEventParams
				then
					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)
					default:dismissNotification(data.notificationData.id)
					joined.navigateToChat(jsonDecode.conversationId)
				end

				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "ChatMessageSnoozeSingleMetaAction"
				then
					ShowNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v2.snoozeDescription,
						notificationType = NotificationGroups.ChatMessageGroup,
						title = v2.snoozeTitle
					})
				end
			end
		)

		return function()
			callback()
		end
	end, { joined.navigateToChat, v2 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(p2)
			if p2.notificationType == NotificationTypeEnum.ChatNewMessage then
				local v6 = FFlagExpChatEnableFriendsTab

				if v6 then
					if joined.visibleFriendsConversationId == nil then
						v6 = false
					else
						v6 = shouldHideFriendsChatToast(p2, joined.visibleFriendsConversationId)
					end
				end

				if v5 or not canSeeChatTab or v6 then
					default:dismissNotification(p2.notificationId)
				end
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v5, canSeeChatTab, joined.visibleFriendsConversationId })

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		React.useEffect(function()
			if not joined.isAppChatVisible and DismissNotificationSnoozeMenuSignal then
				DismissNotificationSnoozeMenuSignal:fire()
			end
		end, { joined.isAppChatVisible })
	end
end
