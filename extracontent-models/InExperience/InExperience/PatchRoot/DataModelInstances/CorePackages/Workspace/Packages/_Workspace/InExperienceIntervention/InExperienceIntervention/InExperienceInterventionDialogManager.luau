local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local React = require(parent.React)

local ChatNudgeCustomDialog = require(InExperienceIntervention.Components.ChatNudgeCustomDialog)
local ChatNudgeCustomDialogV2 = require(InExperienceIntervention.Components.ChatNudgeCustomDialogV2)
local ChatTimeoutCustomDialog = require(InExperienceIntervention.Components.ChatTimeoutCustomDialog)
local ChatNudgeToast = require(InExperienceIntervention.Components.ChatNudgeToast)
local ChatTimeoutToast = require(InExperienceIntervention.Components.ChatTimeoutToast)
local ChatTimeoutCustomDialogV2 = require(InExperienceIntervention.Components.ChatTimeoutCustomDialogV2)
local DictationSafetyReminderToast = require(InExperienceIntervention.Components.DictationSafetyReminderToast)
local InterventionShared = require(parent.InterventionShared)
local PartyChatNudgeCustomDialog = InterventionShared.Components.PartyChatNudgeCustomDialog
local InterventionShared2 = require(parent.InterventionShared)
local PartyChatTimeoutCustomDialog = InterventionShared2.Components.PartyChatTimeoutCustomDialog

local InterventionShared3 = require(parent.InterventionShared)
local UniversalFeatureRestrictionDialog = InterventionShared3.Components.UniversalFeatureRestrictionDialog

local UIBlox = require(parent.UIBlox)
local CursorProvider = UIBlox.App.SelectionCursor.CursorProvider
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider

local InterventionShared4 = require(parent.InterventionShared)
local Constants = InterventionShared4.Utils.Constants
require(InExperienceIntervention.Utils.Types)
local reportChatSuspensionDialogVisibility = require(InExperienceIntervention.Utils.reportChatSuspensionDialogVisibility)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagGameJoinTimeoutChatAttemptEnabled = SharedFlags.GetFFlagGameJoinTimeoutChatAttemptEnabled

local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatDictationContinuousSafetyReminder = SharedFlags2.FFlagExpChatDictationContinuousSafetyReminder

local memo = React.memo(function(p)
	return React.createElement(
		ReactFocusNavigation.FocusNavigationContext.Provider,
		{ value = focusNavigationService },
		{
			RegistryProvider = React.createElement(Provider, nil, {
				CursorProvider = React.createElement(CursorProvider, {}, p.children)
			})
		}
	)
end)

function InExperienceInterventionDialogManager(p)
	local onDismiss = React.useCallback(function()
		p.uiStateDispatch({
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.None,
			isShown = false
		})
	end, { p.uiStateDispatch })

	local uiState = p.uiState
	local treatmentType = uiState.treatmentType
	local detail = uiState.detail
	local options

	if detail then
		options = detail.options
	end

	local v = uiState.isShown

	if
		FFlagExpChatDictationContinuousSafetyReminder
		and treatmentType == Constants.TreatmentType.DictationSafetyReminderToast
	then
		v = false
	end

	React.useEffect(function()
		reportChatSuspensionDialogVisibility(v)
	end, { v })

	if not uiState.isShown then
		return nil
	end

	if treatmentType == Constants.TreatmentType.ChatNudgeDialog then
		return React.createElement(ChatNudgeCustomDialog, {
			violatingChatLine = detail.evidence,
			onDismiss = onDismiss,
			eventId = detail.decisionEventId
		})
	end

	if treatmentType == Constants.TreatmentType.ChatTimeoutDialog and (detail.timeoutDurationSeconds or 0) > 0 then
		return React.createElement(ChatTimeoutCustomDialog, {
			duration = detail.timeoutDurationSeconds,
			onDismiss = onDismiss,
			eventId = detail.decisionEventId,
			violatingChatLine = detail.evidence
		})
	end

	if treatmentType == Constants.TreatmentType.ChatNudgeToast then
		return React.createElement(ChatNudgeToast, {
			violatingChatLine = detail.evidence,
			eventId = detail.decisionEventId
		})
	end

	if treatmentType == Constants.TreatmentType.ChatTimeoutChatAttempt then
		return React.createElement(ChatTimeoutToast, {
			endTime = uiState.endTime,
			treatmentType = Constants.TreatmentType.ChatTimeoutChatAttempt,
			dispatchTimestamp = uiState.dispatchTimestamp
		})
	end

	if GetFFlagGameJoinTimeoutChatAttemptEnabled() and treatmentType == Constants.TreatmentType.ChatTimeoutGameJoin then
		return React.createElement(ChatTimeoutToast, {
			endTime = uiState.endTime,
			treatmentType = Constants.TreatmentType.ChatTimeoutGameJoin,
			dispatchTimestamp = uiState.dispatchTimestamp
		})
	end

	if treatmentType == Constants.TreatmentType.PartyChatNudgeDialog then
		return React.createElement(memo, {}, {
			dialog = React.createElement(PartyChatNudgeCustomDialog, {
				evidence = detail.evidence,
				eventId = detail.decisionEventId,
				onDismiss = onDismiss
			})
		})
	end

	if treatmentType == Constants.TreatmentType.PartyChatTimeoutDialog then
		return React.createElement(memo, {}, { React.createElement(PartyChatTimeoutCustomDialog, {
				endTimestamp = uiState.endTime,
				evidence = detail.evidence,
				eventId = detail.decisionEventId,
				durationForAnalytics = detail.timeoutDurationSeconds,
				onDismiss = onDismiss
			}) })
	end

	if treatmentType == Constants.TreatmentType.ChatTimeoutDialogV2 and detail.moderationDetail then
		return React.createElement(memo, {}, {
			React.createElement(ChatTimeoutCustomDialogV2, {
				onDismiss = onDismiss,
				moderationDetail = detail.moderationDetail
			})
		})
	end

	if treatmentType == Constants.TreatmentType.ChatNudgeDialogV2 and detail.moderationDetail then
		return React.createElement(memo, {}, {
			React.createElement(ChatNudgeCustomDialogV2, {
				onDismiss = onDismiss,
				moderationDetail = detail.moderationDetail
			})
		})
	end

	if treatmentType == Constants.TreatmentType.UniversalFeatureRestriction and detail.moderationDetail then
		return React.createElement(memo, {}, {
			UniversalFeatureRestrictionDialog = React.createElement(UniversalFeatureRestrictionDialog, {
				onDismiss = onDismiss,
				moderationDetail = detail.moderationDetail,
				abuseVector = detail.abuseVector,
				onDismissCallback = options and options.onDismiss,
				titleOverride = options and options.titleOverride,
				bodyOverride = options and options.bodyOverride,
				onAppeal = options and options.onAppeal,
				onShownCallback = options and options.onShown,
				onAcknowledgementSuccess = options and options.onAcknowledgementSuccess,
				onAcknowledgementFailure = options and options.onAcknowledgementFailure,
				onClosedCallback = detail.onClosed,
				analyticsEventId = options and options.analyticsEventId
			})
		})
	end

	if
		FFlagExpChatDictationContinuousSafetyReminder
		and treatmentType == Constants.TreatmentType.DictationSafetyReminderToast
	then
		return React.createElement(DictationSafetyReminderToast)
	end

	return nil
end

return InExperienceInterventionDialogManager
