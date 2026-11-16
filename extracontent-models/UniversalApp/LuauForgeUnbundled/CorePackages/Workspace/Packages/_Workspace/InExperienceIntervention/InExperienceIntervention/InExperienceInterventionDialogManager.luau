local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InExperienceIntervention/Utils/Types")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/RoactUtils").Hooks.RoactRodux.useDispatch
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Utils.Constants
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/CentralOverlay").Thunks.CloseCentralOverlay
local interventionPlacement = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Contexts.InterventionPlacement
local layerCollectorProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UIBlox").Core.Layout.LayerCollector.LayerCollectorProvider

local interventionOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Components.InterventionOverlay
local partyChatNudgeCustomDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Components.PartyChatNudgeCustomDialog
local partyChatTimeoutCustomDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Components.PartyChatTimeoutCustomDialog

local universalFeatureRestrictionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Components.UniversalFeatureRestrictionDialog

local memo = React.memo(function(p2)
	local v5 = useDispatch()
	local v6 = React.useCallback(function()
		v5(closeCentralOverlay())
	end, { v5 })

	local uiState = p2.uiState

	if not uiState.isShown then
		return nil
	end

	local interventionDetail = uiState.interventionDetail or {}
	local options = interventionDetail.options

	if uiState.treatmentType == constants.TreatmentType.PartyChatNudgeDialog then
		return React.createElement(interventionOverlay, { onDismiss = v6 }, {
			Dialog = React.createElement(partyChatNudgeCustomDialog, {
				evidence = interventionDetail.evidence,
				eventId = interventionDetail.decisionEventId,
				onDismiss = v6
			})
		})
	end

	if uiState.treatmentType == constants.TreatmentType.PartyChatTimeoutDialog then
		return React.createElement(interventionOverlay, { onDismiss = v6 }, {
			Dialog = React.createElement(partyChatTimeoutCustomDialog, {
				endTimestamp = uiState.endTime,
				evidence = interventionDetail.evidence,
				eventId = interventionDetail.decisionEventId,
				durationForAnalytics = interventionDetail.timeoutDurationSeconds,
				onDismiss = v6
			})
		})
	end

	if
		uiState.treatmentType == constants.TreatmentType.UniversalFeatureRestriction
		and interventionDetail.moderationDetail
	then
		return React.createElement(universalFeatureRestrictionDialog, {
			onDismiss = v6,
			moderationDetail = interventionDetail.moderationDetail,
			abuseVector = interventionDetail.abuseVector,
			onDismissCallback = options and options.onDismiss,
			titleOverride = options and options.titleOverride,
			bodyOverride = options and options.bodyOverride,
			onAppeal = options and options.onAppeal,
			onShownCallback = options and options.onShown,
			onAcknowledgementSuccess = options and options.onAcknowledgementSuccess,
			onAcknowledgementFailure = options and options.onAcknowledgementFailure,
			onClosedCallback = interventionDetail.onClosed,
			analyticsEventId = options and options.analyticsEventId
		})
	end

	return nil
end)

local function InAppInterventionContainer(p2)
	return React.createElement(
		interventionPlacement.Provider,
		{ value = constants.InterventionPlacementType.InApp },
		{
			LayerCollectorProvider = React.createElement(layerCollectorProvider, {}, {
				InAppInterventionDialogContainer = React.createElement(memo, p2)
			})
		}
	)
end

return React.memo(InAppInterventionContainer)
