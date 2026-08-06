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
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local ArgoPartyExperimentation = require(AppChatParent.SocialExperiments).ArgoPartyExperimentation

local function SnoozeToastNotificationsButton(t1: {[any]: any}) -- line: 37
	-- upvalues: useLocalization (copy), ArgoPartyExperimentation (copy), UniversalAppPolicy (copy), v19 (copy), FFlagExpChatEnableFriendsTab (copy), GetFFlagIsSquadEnabled (copy), React (copy), default (copy), ToastNotificationTypeModule (copy), NotificationSnoozedSignal (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), IconButton (copy), Images (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), ChatLandingTelemetryEvents (copy)
	local v25 = useLocalization({
		party = "Feature.Squads.Label.Party",
		unmuteFeedback = "Feature.Notifications.Heading.RemoveSnoozeFeedback",
		chat = not ArgoPartyExperimentation.getIsRenameEnabled() and "Feature.Chat.Heading.ChatWithConnections" or (not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "CommonUI.Features.Label.Chat"),
		snoozeDescription = if not v19 then nil else "Feature.Chat.Description.SnoozeDescription",
		snoozeTitle = if not FFlagExpChatEnableFriendsTab then if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "Feature.Chat.Label.SnoozeChatNotifications" or "Feature.Chat.Label.SnoozePartyNotifications" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Label.SnoozePartyNotifications" or "Feature.Chat.Title.MuteChatNotifications" else "Feature.Chat.Label.MuteInGameChatToastNotifications"
	})
	local v26, v27 = React.useState(default:isSnoozedNotificationType(ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage))

	React.useEffect(function() -- line: 65
		-- upvalues: NotificationSnoozedSignal (copy), ToastNotificationTypeModule (copy), v27 (copy)
		local v29 = NotificationSnoozedSignal:connect(function(t2: {[any]: any}) -- line: 66
			-- upvalues: ToastNotificationTypeModule (copy), v27 (copy)
			if t2.notificationType == ToastNotificationTypeModule.NotificationTypeEnum.ChatNewMessage then
				v27(t2.actionType == ToastNotificationTypeModule.SnoozeActionEnum.Mute)
			end
		end)

		return function() -- line: 77
			-- upvalues: v29 (copy)
			v29:disconnect()
		end
	end, {})

	local v28 = useTelemetry(ChatLandingTelemetryLayer.Context)

	return React.createElement(IconButton, {
		size = t1.size,
		icon = if not v26 then Images["icons/common/snoozeNotificationsOff"] else Images["icons/common/snoozeNotificationsOn"],
		layoutOrder = t1.layoutOrder,
		onActivated = function() -- line: 90
			-- upvalues: v26 (copy), v25 (copy), ArgoPartyExperimentation (copy), GetFFlagIsSquadEnabled (copy), default (copy), NotificationGroups (copy), ShowNotificationSnoozeMenuSignal (copy), v19 (copy), v28 (copy), ChatLandingTelemetryEvents (copy)
			if v26 then
				local v30 = v25.unmuteFeedback:gsub("{title}", if ArgoPartyExperimentation.getIsRenameEnabled() or not GetFFlagIsSquadEnabled() then v25.chat else v25.party)

				default:unmuteNotification({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					modalMessage = v30
				})
			else
				ShowNotificationSnoozeMenuSignal:fire({
					context = "ChatLandingSnoozeToastNotificationsButton",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup,
					title = v25.snoozeTitle,
					description = if not v19 then nil else v25.snoozeDescription
				})
			end

			v28.emit(ChatLandingTelemetryEvents.ChatLandingSnoozeBtnClicked, {
				isChatNotificationsMuted = v26
			})
		end
	})
end

return SnoozeToastNotificationsButton
