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
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")

local fFlagAppChatToastChatTerminologyFixEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatToastChatTerminologyFixEnabled

local function SnoozeToastNotificationsButton(p2)
	local v5 = useLocalization({
		chat = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = fFlagAppChatToastChatTerminologyFixEnabled and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.MuteInGameChatToastNotifications" or "Feature.Chat.Label.MuteInGamePartyToastNotifications") or "Feature.Chat.Label.MuteInGameChatToastNotifications",
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback"
	})

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

	local v6 = useTelemetry(ChatConversationTelemetryLayer.Context)

	local createElement = React.createElement
	local v8 = { size = p2.size, icon = 0, layoutOrder = 0, onActivated = 0 }

	local v9 = if state then images["icons/common/snoozeNotificationsOn"] else images["icons/common/snoozeNotificationsOff"]
	v8.icon = v9

	v8.layoutOrder = p2.layoutOrder
	function v8.onActivated()
		if state then
			local v10 = v5.unmuteFeedback:gsub("{title}", v5.chat)
			default:unmuteNotification({
				notificationType = notificationGroups.ChatLandingNotificationsGroup,
				modalMessage = v10,
				context = "ChatLandingSnoozeToastNotificationsButton"
			})
		else
			showNotificationSnoozeMenuSignal:fire({
				context = "ChatLandingSnoozeToastNotificationsButton",
				notificationType = notificationGroups.ChatLandingNotificationsGroup,
				title = v5.snoozeTitle,
				description = v5.snoozeDescription
			})
		end

		v6.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
			isChatNotificationsMuted = state
		})
	end

	return createElement(iconButton, v8)
end

return SnoozeToastNotificationsButton
