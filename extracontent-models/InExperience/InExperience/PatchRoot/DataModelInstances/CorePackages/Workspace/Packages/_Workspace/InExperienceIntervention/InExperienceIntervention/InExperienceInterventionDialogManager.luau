local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local React = require(InExperienceInterventionParent.React)
local ChatNudgeCustomDialog = require(InExperienceIntervention.Components.ChatNudgeCustomDialog)
local ChatNudgeCustomDialogV2 = require(InExperienceIntervention.Components.ChatNudgeCustomDialogV2)
local ChatTimeoutCustomDialog = require(InExperienceIntervention.Components.ChatTimeoutCustomDialog)
local ChatNudgeToast = require(InExperienceIntervention.Components.ChatNudgeToast)
local ChatTimeoutToast = require(InExperienceIntervention.Components.ChatTimeoutToast)
local ChatTimeoutCustomDialogV2 = require(InExperienceIntervention.Components.ChatTimeoutCustomDialogV2)
local PartyChatNudgeCustomDialog = require(InExperienceInterventionParent.InterventionShared).Components.PartyChatNudgeCustomDialog
local PartyChatTimeoutCustomDialog = require(InExperienceInterventionParent.InterventionShared).Components.PartyChatTimeoutCustomDialog
local TemporaryAvatarKickWarningDialog = require(InExperienceInterventionParent.InterventionShared.TemporaryAvatarKickWarningDialog)
local UniversalFeatureRestrictionDialog = require(InExperienceInterventionParent.InterventionShared).Components.UniversalFeatureRestrictionDialog
local CursorProvider = require(InExperienceInterventionParent.UIBlox).App.SelectionCursor.CursorProvider
local ReactFocusNavigation = require(InExperienceInterventionParent.ReactFocusNavigation)
local v16 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local Provider = require(InExperienceInterventionParent.FocusNavigationUtils).FocusNavigableSurfaceRegistry.Provider
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants

require(InExperienceIntervention.Utils.Types)

local GetFFlagGameJoinTimeoutChatAttemptEnabled = require(InExperienceInterventionParent.SharedFlags).GetFFlagGameJoinTimeoutChatAttemptEnabled
local FFlagTemporaryAvatarKickWarningDialog = require(InExperienceInterventionParent.InterventionShared.FFlagTemporaryAvatarKickWarningDialog)
local FFlagUniversalFeatureRestrictionReceivers = require(InExperienceInterventionParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local EngineFeature = game:GetEngineFeature("SSUIMetaLua")
local v23 = React.memo(function(p1) -- line: 39
	-- upvalues: React (copy), ReactFocusNavigation (copy), v16 (copy), Provider (copy), CursorProvider (copy)
	return React.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
		value = v16
	}, {
		RegistryProvider = React.createElement(Provider, nil, {
			CursorProvider = React.createElement(CursorProvider, {}, p1.children)
		})
	})
end)

function InExperienceInterventionDialogManager(t1: {[any]: any}) -- line: 49
	-- upvalues: React (copy), Constants (copy), FFlagUniversalFeatureRestrictionReceivers (copy), FFlagTemporaryAvatarKickWarningDialog (copy), EngineFeature (copy), ChatNudgeCustomDialog (copy), ChatTimeoutCustomDialog (copy), ChatNudgeToast (copy), ChatTimeoutToast (copy), GetFFlagGameJoinTimeoutChatAttemptEnabled (copy), v23 (copy), PartyChatNudgeCustomDialog (copy), PartyChatTimeoutCustomDialog (copy), ChatTimeoutCustomDialogV2 (copy), ChatNudgeCustomDialogV2 (copy), UniversalFeatureRestrictionDialog (copy), TemporaryAvatarKickWarningDialog (copy)
	local v26 = React.useCallback(function() -- line: 50
		-- upvalues: t1 (copy), Constants (copy)
		t1.uiStateDispatch({
			isShown = false,
			type = Constants.UIStateActions.ToggleNotificationDialog,
			treatmentType = Constants.TreatmentType.None
		})
	end, { t1.uiStateDispatch })
	local uiState = t1.uiState
	local treatmentType = uiState.treatmentType
	local detail = uiState.detail
	local v30 = if not FFlagUniversalFeatureRestrictionReceivers or not detail then nil else detail.options
	local v31 = if not FFlagTemporaryAvatarKickWarningDialog or not detail then nil else detail.extras

	React.useEffect(function() -- line: 65
		-- upvalues: EngineFeature (copy), uiState (copy)
		if EngineFeature then
			pcall(function() -- line: 67
				-- upvalues: uiState (copy)
				local SafetyService = game:GetService("SafetyService")

				if uiState.isShown then
					SafetyService:ReportChatSuspensionDialogOpen()

					return
				end

				SafetyService:ReportChatSuspensionDialogClose()
			end)
		end
	end, { uiState.isShown })

	if uiState.isShown then
		if treatmentType == Constants.TreatmentType.ChatNudgeDialog then
			return React.createElement(ChatNudgeCustomDialog, {
				violatingChatLine = detail.evidence,
				onDismiss = v26,
				eventId = detail.decisionEventId
			})
		end

		if treatmentType == Constants.TreatmentType.ChatTimeoutDialog and (detail.timeoutDurationSeconds or 0) > 0 then
			return React.createElement(ChatTimeoutCustomDialog, {
				duration = detail.timeoutDurationSeconds,
				onDismiss = v26,
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
			return React.createElement(v23, {}, {
				dialog = React.createElement(PartyChatNudgeCustomDialog, {
					evidence = detail.evidence,
					eventId = detail.decisionEventId,
					onDismiss = v26
				})
			})
		end

		if treatmentType == Constants.TreatmentType.PartyChatTimeoutDialog then
			return React.createElement(v23, {}, { React.createElement(PartyChatTimeoutCustomDialog, {
				endTimestamp = uiState.endTime,
				evidence = detail.evidence,
				eventId = detail.decisionEventId,
				durationForAnalytics = detail.timeoutDurationSeconds,
				onDismiss = v26
			}) })
		end

		if treatmentType == Constants.TreatmentType.ChatTimeoutDialogV2 and detail.moderationDetail then
			return React.createElement(v23, {}, { React.createElement(ChatTimeoutCustomDialogV2, {
				onDismiss = v26,
				moderationDetail = detail.moderationDetail
			}) })
		end

		if treatmentType == Constants.TreatmentType.ChatNudgeDialogV2 and detail.moderationDetail then
			return React.createElement(v23, {}, { React.createElement(ChatNudgeCustomDialogV2, {
				onDismiss = v26,
				moderationDetail = detail.moderationDetail
			}) })
		end

		if FFlagUniversalFeatureRestrictionReceivers and treatmentType == Constants.TreatmentType.UniversalFeatureRestriction and detail.moderationDetail then
			return React.createElement(v23, {}, { React.createElement(UniversalFeatureRestrictionDialog, {
				onDismiss = v26,
				moderationDetail = detail.moderationDetail,
				abuseVector = detail.abuseVector,
				onDismissCallback = v30 and v30.onDismiss,
				titleOverride = v30 and v30.titleOverride,
				bodyOverride = v30 and v30.bodyOverride,
				onAppeal = v30 and v30.onAppeal
			}) })
		end

		if FFlagTemporaryAvatarKickWarningDialog and treatmentType == Constants.TreatmentType.TemporaryAvatarKickWarning then
			return React.createElement(v23, {}, { React.createElement(TemporaryAvatarKickWarningDialog, {
				avatarEntityId = v31 and v31.avatarEntityId,
				violationType = v31 and v31.violationType,
				placeId = v31 and v31.placeId,
				onDismiss = v26
			}) })
		end
	end

	return nil
end

return InExperienceInterventionDialogManager
