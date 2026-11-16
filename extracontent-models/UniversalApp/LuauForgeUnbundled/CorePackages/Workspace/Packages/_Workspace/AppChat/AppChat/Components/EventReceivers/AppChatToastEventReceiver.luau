local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ToastNotification")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ToastNotificationsProtocol").ToastNotificationProtocol.default

local notificationGroups = ToastNotification.NotificationGroups

local useIsChatEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsChatEnabled")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local shouldHideFriendsChatToast = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/shouldHideFriendsChatToast")

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local showNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local dismissNotificationSnoozeMenuSignal = ToastNotification.Signals.DismissNotificationSnoozeMenuSignal

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local getFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local getFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local fFlagAppChatToastChatTerminologyFixEnabled = SharedFlags.FFlagAppChatToastChatTerminologyFixEnabled

local v5 = {
	hideAllChatToasts = false,
	isAppChatVisible = false,
	isInExperience = false,
	navigateToChat = function() end
}

return function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v8 = if fFlagAppChatToastChatTerminologyFixEnabled and fFlagExpChatEnableFriendsTab then UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.MuteInGameChatToastNotifications" or "Feature.Chat.Label.MuteInGamePartyToastNotifications" else fFlagExpChatEnableFriendsTab and "Feature.Chat.Label.MuteInGameChatToastNotifications" or getFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozePartyNotifications" or "Feature.Chat.Label.SnoozeChatNotifications"
	local v9 = useLocalization({
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = v8
	})
	local v10

	if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		v10 = joined.isAppChatVisible
	else
		v10 = joined.hideAllChatToasts
	end

	local canSeeChatTab = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab()

	local v11 = useIsChatEnabled()
	local v12 = v10 or not v11

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.ChatNewMessage,
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
					showNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v9.snoozeDescription,
						notificationType = notificationGroups.ChatMessageGroup,
						title = v9.snoozeTitle
					})
				end
			end
		)

		return function()
			callback()
		end
	end, { joined.navigateToChat, v9 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(p3)
			if p3.notificationType == notificationTypeEnum.ChatNewMessage then
				local v13 = fFlagExpChatEnableFriendsTab

				if v13 then
					if joined.visibleFriendsConversationId == nil then
						v13 = false
					else
						v13 = shouldHideFriendsChatToast(p3, joined.visibleFriendsConversationId)
					end
				end

				if v12 or not canSeeChatTab or v13 then
					default:dismissNotification(p3.notificationId)
				end
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v12, canSeeChatTab, joined.visibleFriendsConversationId })

	if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		React.useEffect(function()
			if not joined.isAppChatVisible and dismissNotificationSnoozeMenuSignal then
				dismissNotificationSnoozeMenuSignal:fire()
			end
		end, { joined.isAppChatVisible })
	end
end
