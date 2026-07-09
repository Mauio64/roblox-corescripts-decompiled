local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local InAppInterventionParent = InAppIntervention.Parent
local React = require(InAppInterventionParent.React)

require(InAppIntervention.Utils.Types)

local useDispatch = require(InAppInterventionParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = require(InAppInterventionParent.InterventionShared).Utils.Constants
local CloseCentralOverlay = require(InAppInterventionParent.CentralOverlay).Thunks.CloseCentralOverlay
local InterventionPlacement = require(InAppInterventionParent.InterventionShared).Contexts.InterventionPlacement
local LayerCollectorProvider = require(InAppInterventionParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local InterventionOverlay = require(InAppInterventionParent.InterventionShared).Components.InterventionOverlay
local PartyChatNudgeCustomDialog = require(InAppInterventionParent.InterventionShared).Components.PartyChatNudgeCustomDialog
local PartyChatTimeoutCustomDialog = require(InAppInterventionParent.InterventionShared).Components.PartyChatTimeoutCustomDialog
local UniversalFeatureRestrictionDialog = require(InAppInterventionParent.InterventionShared).Components.UniversalFeatureRestrictionDialog
local FFlagUniversalFeatureRestrictionReceivers = require(InAppInterventionParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local v14 = React.memo(function(t1: {[any]: any}) -- line: 22
	-- upvalues: useDispatch (copy), React (copy), CloseCentralOverlay (copy), FFlagUniversalFeatureRestrictionReceivers (copy), Constants (copy), InterventionOverlay (copy), PartyChatNudgeCustomDialog (copy), PartyChatTimeoutCustomDialog (copy), UniversalFeatureRestrictionDialog (copy)
	local v17 = useDispatch()
	local v18 = React.useCallback(function() -- line: 24
		-- upvalues: v17 (copy), CloseCentralOverlay (copy)
		v17(CloseCentralOverlay())
	end, { v17 })
	local uiState = t1.uiState

	if uiState.isShown then
		local v20 = uiState.interventionDetail or {}
		local v21 = if not FFlagUniversalFeatureRestrictionReceivers then nil else v20.options

		if uiState.treatmentType == Constants.TreatmentType.PartyChatNudgeDialog then
			return React.createElement(InterventionOverlay, {
				onDismiss = v18
			}, {
				Dialog = React.createElement(PartyChatNudgeCustomDialog, {
					evidence = v20.evidence,
					eventId = v20.decisionEventId,
					onDismiss = v18
				})
			})
		end

		if uiState.treatmentType == Constants.TreatmentType.PartyChatTimeoutDialog then
			return React.createElement(InterventionOverlay, {
				onDismiss = v18
			}, {
				Dialog = React.createElement(PartyChatTimeoutCustomDialog, {
					endTimestamp = uiState.endTime,
					evidence = v20.evidence,
					eventId = v20.decisionEventId,
					durationForAnalytics = v20.timeoutDurationSeconds,
					onDismiss = v18
				})
			})
		end

		if FFlagUniversalFeatureRestrictionReceivers and uiState.treatmentType == Constants.TreatmentType.UniversalFeatureRestriction and v20.moderationDetail then
			return React.createElement(UniversalFeatureRestrictionDialog, {
				onDismiss = v18,
				moderationDetail = v20.moderationDetail,
				abuseVector = v20.abuseVector,
				onDismissCallback = v21 and v21.onDismiss,
				titleOverride = v21 and v21.titleOverride,
				bodyOverride = v21 and v21.bodyOverride,
				onAppeal = v21 and v21.onAppeal
			})
		end
	end

	return nil
end)

local function InAppInterventionContainer(t2: {[any]: any}) -- line: 75
	-- upvalues: React (copy), InterventionPlacement (copy), Constants (copy), LayerCollectorProvider (copy), v14 (copy)
	return React.createElement(InterventionPlacement.Provider, {
		value = Constants.InterventionPlacementType.InApp
	}, {
		LayerCollectorProvider = React.createElement(LayerCollectorProvider, {}, {
			InAppInterventionDialogContainer = React.createElement(v14, t2)
		})
	})
end

return React.memo(InAppInterventionContainer)
