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
local v19 = game:DefineFastFlag("ChatSnoozeMenuDescriptionFixEnabled", false)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation

local function SnoozeToastNotificationsButton(t1: {[any]: any}) -- line: 36
	-- upvalues: useLocalization (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), v19 (copy), GetFFlagIsSquadEnabled (copy), React (copy), default (copy), ToastNotificationTypeModule (copy), NotificationSnoozedSignal (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), IconButton (copy), Images (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), ChatLandingTelemetryEvents (copy)
	local v24 = useLocalization({
		party = "Feature.Squads.Label.Party",
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback",
		chat = not ArgoPartyExperimentation.getIsRenameEnabled() and "Feature.Chat.Heading.ChatWithConnections" or (not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "CommonUI.Features.Label.Chat"),
		snoozeDescription = if not v19 then nil else "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozeChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.SnoozePartyNotifications" or "Feature.Chat.Title.MuteChatNotifications"
	})
	local v25, v26 = React.useState(default:isSnoozedNotificationType(ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage))

	React.useEffect(function() -- line: 62
		-- upvalues: NotificationSnoozedSignal (copy), ToastNotificationTypeModule (copy), v26 (copy)
		local v28 = NotificationSnoozedSignal:connect(function(t2: {[any]: any}) -- line: 63
			-- upvalues: ToastNotificationTypeModule (copy), v26 (copy)
			if t2.notificationType == ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage then
				v26(t2.actionType == ToastNotificationTypeModule.SnoozeActionEnum.Mute)
			end
		end)

		return function() -- line: 74
			-- upvalues: v28 (copy)
			v28:disconnect()
		end
	end, {})

	local v27 = useTelemetry(ChatLandingTelemetryLayer.Context)

	return React.createElement(IconButton, {
		size = t1.size,
		icon = if not v25 then Images["icons/common/snoozeNotificationsOff"] else Images["icons/common/snoozeNotificationsOn"],
		layoutOrder = t1.layoutOrder,
		onActivated = function() -- line: 87
			-- upvalues: v25 (copy), v24 (copy), ArgoPartyExperimentation (copy), GetFFlagIsSquadEnabled (copy), default (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), v19 (copy), v27 (copy), ChatLandingTelemetryEvents (copy)
			if v25 then
				local v29 = v24.unmuteFeedback:gsub("{title}", if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then v24.chat else v24.party)

				default:unmuteNotification({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					modalMessage = v29
				})
			else
				ShowNotificationSnoozeMenuSignal:fire({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					title = v24.snoozeTitle,
					description = if not v19 then nil else v24.snoozeDescription
				})
			end

			v27.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
				isChatNotificationsMuted = v25
			})
		end
	})
end

return SnoozeToastNotificationsButton
