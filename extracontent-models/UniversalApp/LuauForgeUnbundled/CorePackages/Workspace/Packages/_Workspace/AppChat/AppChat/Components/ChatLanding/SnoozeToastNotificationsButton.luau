local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ToastNotification")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local notificationSnoozedSignal = ToastNotification.Signals.NotificationSnoozedSignal
local showNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local default = ToastNotification.ToastNotificationSnoozeManager.default
local toastNotificationTypeModule = ToastNotification.ToastNotificationTypeModule
local notificationGroups = ToastNotification.NotificationGroups

local iconButton = UIBlox.App.Button.IconButton
local images = UIBlox.App.ImageSet.Images

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")
local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab

local fFlagAppChatToastChatTerminologyFixEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatToastChatTerminologyFixEnabled

local function SnoozeToastNotificationsButton(p2)
	local v6 = {
		chat = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = 0,
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback"
	}

	local v7 = if fFlagAppChatToastChatTerminologyFixEnabled and fFlagExpChatEnableFriendsTab then UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.MuteInGameChatToastNotifications" or "Feature.Chat.Label.MuteInGamePartyToastNotifications" else fFlagExpChatEnableFriendsTab and "Feature.Chat.Label.MuteInGameChatToastNotifications" or UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Title.MuteChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications"
	v6.snoozeTitle = v7
	local v8 = useLocalization(v6)

	local state, setState = React.useState(default:isSnoozedNotificationType(toastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage))

	React.useEffect(function()
		local connection = notificationSnoozedSignal:connect(function(p3)
			if p3.notificationType == toastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage then
				setState(p3.actionType == toastNotificationTypeModule.SnoozeActionEnum.Mute)
			end
		end)

		return function()
			connection:disconnect()
		end
	end, {})

	local v9 = useTelemetry(ChatLandingTelemetryLayer.Context)

	local createElement = React.createElement
	local v11 = { size = p2.size, icon = 0, layoutOrder = 0, onActivated = 0 }

	local v12 = if state then images["icons/common/snoozeNotificationsOn"] else images["icons/common/snoozeNotificationsOff"]
	v11.icon = v12

	v11.layoutOrder = p2.layoutOrder
	function v11.onActivated()
		if state then
			local v13 = v8.unmuteFeedback:gsub("{title}", v8.chat)
			default:unmuteNotification({
				notificationType = notificationGroups.ChatLandingNotificationsGroup,
				modalMessage = v13,
				context = "ChatLandingSnoozeToastNotificationsButton"
			})
		else
			showNotificationSnoozeMenuSignal:fire({
				context = "ChatLandingSnoozeToastNotificationsButton",
				notificationType = notificationGroups.ChatLandingNotificationsGroup,
				title = v8.snoozeTitle,
				description = v8.snoozeDescription
			})
		end

		v9.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
			isChatNotificationsMuted = state
		})
	end

	return createElement(iconButton, v11)
end

return SnoozeToastNotificationsButton
