local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local ToastNotification = require(parent.ToastNotification)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local NotificationSnoozedSignal = ToastNotification.Signals.NotificationSnoozedSignal
local ShowNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local default = ToastNotification.ToastNotificationSnoozeManager.default
local ToastNotificationTypeModule = ToastNotification.ToastNotificationTypeModule
local NotificationGroups = ToastNotification.NotificationGroups

local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images

local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local ChatLanding = script:FindFirstAncestor("ChatLanding")
local ChatLandingTelemetryEvents = require(ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatToastChatTerminologyFixEnabled = SharedFlags.FFlagAppChatToastChatTerminologyFixEnabled

local function SnoozeToastNotificationsButton(p)
	local v = useLocalization({
		chat = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = FFlagAppChatToastChatTerminologyFixEnabled and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.MuteInGameChatToastNotifications" or "Feature.Chat.Label.MuteInGamePartyToastNotifications") or "Feature.Chat.Label.MuteInGameChatToastNotifications",
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback"
	})

	local state, setState = React.useState(default:isSnoozedNotificationType(ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage))

	React.useEffect(function()
		local connection = NotificationSnoozedSignal:connect(function(p2)
			if p2.notificationType == ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage then
				setState(p2.actionType == ToastNotificationTypeModule.SnoozeActionEnum.Mute)
			end
		end)

		return function()
			connection:disconnect()
		end
	end, {})

	local v2 = useTelemetry(ChatLandingTelemetryLayer.Context)

	local createElement = React.createElement
	local v3 = { size = p.size, icon = 0, layoutOrder = 0, onActivated = 0 }
	local icon

	if state then
		icon = Images["icons/common/snoozeNotificationsOn"]
	else
		icon = Images["icons/common/snoozeNotificationsOff"]
	end

	v3.icon = icon

	v3.layoutOrder = p.layoutOrder
	function v3.onActivated()
		if state then
			local modalMessage = v.unmuteFeedback:gsub("{title}", v.chat)
			default:unmuteNotification({
				notificationType = NotificationGroups.ChatLandingNotificationsGroup,
				modalMessage = modalMessage,
				context = "ChatLandingSnoozeToastNotificationsButton"
			})
		else
			ShowNotificationSnoozeMenuSignal:fire({
				context = "ChatLandingSnoozeToastNotificationsButton",
				notificationType = NotificationGroups.ChatLandingNotificationsGroup,
				title = v.snoozeTitle,
				description = v.snoozeDescription
			})
		end

		v2.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
			isChatNotificationsMuted = state
		})
	end

	return createElement(IconButton, v3)
end

return SnoozeToastNotificationsButton
