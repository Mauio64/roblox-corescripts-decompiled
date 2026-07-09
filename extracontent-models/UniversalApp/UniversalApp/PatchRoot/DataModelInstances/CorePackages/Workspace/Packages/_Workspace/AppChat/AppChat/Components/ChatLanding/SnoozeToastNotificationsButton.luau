local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local ToastNotification = require(AppChatParent.ToastNotification)
local UIBlox = require(AppChatParent.UIBlox)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
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
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation

local function SnoozeToastNotificationsButton(t1: {[any]: any}) -- line: 35
	-- upvalues: useLocalization (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), GetFFlagIsSquadEnabled (copy), React (copy), default (copy), ToastNotificationTypeModule (copy), NotificationSnoozedSignal (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), IconButton (copy), Images (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), ChatLandingTelemetryEvents (copy)
	local v23 = useLocalization({
		party = "Feature.Squads.Label.Party",
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback",
		chat = not ArgoPartyExperimentation.getIsRenameEnabled() and "Feature.Chat.Heading.ChatWithConnections" or (not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "CommonUI.Features.Label.Chat"),
		snoozeTitle = if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozeChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.SnoozePartyNotifications" or "Feature.Chat.Title.MuteChatNotifications"
	})
	local v24, v25 = React.useState(default:isSnoozedNotificationType(ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage))

	React.useEffect(function() -- line: 58
		-- upvalues: NotificationSnoozedSignal (copy), ToastNotificationTypeModule (copy), v25 (copy)
		local v27 = NotificationSnoozedSignal:connect(function(t2: {[any]: any}) -- line: 59
			-- upvalues: ToastNotificationTypeModule (copy), v25 (copy)
			if t2.notificationType == ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage then
				v25(t2.actionType == ToastNotificationTypeModule.SnoozeActionEnum.Mute)
			end
		end)

		return function() -- line: 70
			-- upvalues: v27 (copy)
			v27:disconnect()
		end
	end, {})

	local v26 = useTelemetry(ChatLandingTelemetryLayer.Context)

	return React.createElement(IconButton, {
		size = t1.size,
		icon = if not v24 then Images["icons/common/snoozeNotificationsOff"] else Images["icons/common/snoozeNotificationsOn"],
		layoutOrder = t1.layoutOrder,
		onActivated = function() -- line: 83
			-- upvalues: v24 (copy), v23 (copy), ArgoPartyExperimentation (copy), GetFFlagIsSquadEnabled (copy), default (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), v26 (copy), ChatLandingTelemetryEvents (copy)
			if v24 then
				local v28 = v23.unmuteFeedback:gsub("{title}", if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then v23.chat else v23.party)

				default:unmuteNotification({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					modalMessage = v28
				})
			else
				ShowNotificationSnoozeMenuSignal:fire({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					title = v23.snoozeTitle
				})
			end

			v26.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
				isChatNotificationsMuted = v24
			})
		end
	})
end

return SnoozeToastNotificationsButton
