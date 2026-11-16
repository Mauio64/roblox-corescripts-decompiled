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
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatToastChatTerminologyFixEnabled = SharedFlags2.FFlagAppChatToastChatTerminologyFixEnabled

local function SnoozeToastNotificationsButton(p)
	local v = {
		chat = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = 0,
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback"
	}
	local snoozeTitle

	if FFlagAppChatToastChatTerminologyFixEnabled and FFlagExpChatEnableFriendsTab then
		snoozeTitle = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
			and "Feature.Chat.Label.MuteInGameChatToastNotifications"
			or "Feature.Chat.Label.MuteInGamePartyToastNotifications"
	else
		snoozeTitle = FFlagExpChatEnableFriendsTab and "Feature.Chat.Label.MuteInGameChatToastNotifications"
			or UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
			and "Feature.Chat.Title.MuteChatNotifications"
			or "Feature.Chat.Label.SnoozePartyNotifications"
	end

	v.snoozeTitle = snoozeTitle
	local v2 = useLocalization(v)

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

	local v3 = useTelemetry(ChatLandingTelemetryLayer.Context)

	local createElement = React.createElement
	local v4 = { size = p.size, icon = 0, layoutOrder = 0, onActivated = 0 }
	local icon

	if state then
		icon = Images["icons/common/snoozeNotificationsOn"]
	else
		icon = Images["icons/common/snoozeNotificationsOff"]
	end

	v4.icon = icon

	v4.layoutOrder = p.layoutOrder
	function v4.onActivated()
		if state then
			local modalMessage = v2.unmuteFeedback:gsub("{title}", v2.chat)
			default:unmuteNotification({
				notificationType = NotificationGroups.ChatLandingNotificationsGroup,
				modalMessage = modalMessage,
				context = "ChatLandingSnoozeToastNotificationsButton"
			})
		else
			ShowNotificationSnoozeMenuSignal:fire({
				context = "ChatLandingSnoozeToastNotificationsButton",
				notificationType = NotificationGroups.ChatLandingNotificationsGroup,
				title = v2.snoozeTitle,
				description = v2.snoozeDescription
			})
		end

		v3.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
			isChatNotificationsMuted = state
		})
	end

	return createElement(IconButton, v4)
end

return SnoozeToastNotificationsButton
