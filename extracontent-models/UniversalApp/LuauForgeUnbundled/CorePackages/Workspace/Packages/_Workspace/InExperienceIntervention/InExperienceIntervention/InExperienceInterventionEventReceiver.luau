local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/RealtimeDelivery")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/RoactUtils").Hooks.RoactRodux.useDispatch

local chatInputBoxDisabledPressedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Signals.chatInputBoxDisabledPressedSignal

local featureRestrictionDisplayDirectSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/featureRestrictionDisplayDirectSignal")
local featureRestrictionDisplaySignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/featureRestrictionDisplaySignal")
local getModerationDetail = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Http.GetModerationDetail
local interventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").InterventionAnalytics
local module5 = require("@luauforge/bundled/hPj")
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/CentralOverlay").Actions.SetCentralOverlay
local useIsUserInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/RobloxAppHooks").useIsUserInExperience

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared").Utils.Constants
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/RobloxAppEnums").CentralOverlayType

local fFlagAppChatUniversalFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/SharedFlags").FFlagAppChatUniversalFeatureRestriction
local FFlagUFRAppealsAndModNoteFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/InterventionShared/FFlagUFRAppealsAndModNoteFix")

local FFlagUFRRunUnlessFeatureRestricted = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceIntervention/UniversalFeatureRestrictions/FFlagUFRRunUnlessFeatureRestricted")

function LUAUFORGE_MODULE_GLOBALS_hPc_InAppInterventionEventReceiver(): nil
	local v5 = useDispatch()
	local v6 = useIsUserInExperience()

	local v7 = React.useCallback(function(p2)
		v5(setCentralOverlay(centralOverlayType.InAppIntervention, { uiState = p2 }))
	end, { v5 })

	local v8 = React.useMemo(function()
		return { isUserInExperience = v6 }
	end, { v6 })

	local v9 = React.useCallback(function(p2)
		for k, v10 in module5 do
			if v10.shouldTriggerEventReceived(p2, v8) then
				v10.onTriggerEventReceived(p2)
			end

			if v10.shouldTriggerVisualTreatment(p2, v8) then
				v10.onTriggerVisualTreatment(v5, v7, p2)
			end

			if v10.shouldTriggerBehavioralTreatment(p2, v8) then
				v10.onTriggerBehavioralTreatment(p2)
			end
		end
	end, { module5, v5, v7, v8 })

	RealtimeDelivery.useRealtimeNamespace("FeatureIntervention", function(p2)
		v9(p2)
	end, { v9 })

	React.useEffect(function()
		local connection

		if fFlagAppChatUniversalFeatureRestriction then
			connection = nil
		else
			connection = chatInputBoxDisabledPressedSignal:connect(function(data)
				v7({
					interventionDetail = {
						decisionEventId = data.decisionEventId,
						timeoutDurationSeconds = data.duration
					},
					type = constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = constants.TreatmentType.PartyChatTimeoutDialog,
					endTime = data.endTimestamp,
					isShown = true
				})
			end)
		end

		local connection2 = featureRestrictionDisplaySignal:connect(function(p2)
			local abuseVector = p2.abuseVector
			local options = p2.options
			local v10 = nil

			if fFlagAppChatUniversalFeatureRestriction and v6 then
				return
			end

			getModerationDetail({ abuseVector = abuseVector }):andThen(function(p3)
				v10 = p3
			end):catch(function(p3)
				interventionAnalytics.sendAnalyticsEvent(
					interventionAnalytics.TelemetryConfigs.GetModerationDetailFailed,
					{
						eventType = interventionAnalytics.Constants.EventTypes.GetModerationDetailFailed,
						placement = constants.InterventionPlacementType.InApp,
						renderedTimestamp = DateTime.now().UnixTimestampMillis,
						error = p3.error,
						abuseVector = abuseVector
					}
				)
			end):await()

			if not v10 or FFlagUFRAppealsAndModNoteFix and next(v10) == nil then
				return
			end

			v7({
				interventionDetail = {
					moderationDetail = v10,
					options = options,
					abuseVector = abuseVector
				},
				type = constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = constants.TreatmentType.UniversalFeatureRestriction,
				isShown = true
			})
		end)

		local connection3 = featureRestrictionDisplayDirectSignal:connect(function(data)
			local abuseVector = data.abuseVector
			local moderationDetail = data.moderationDetail
			local options = data.options

			if fFlagAppChatUniversalFeatureRestriction and v6 or not moderationDetail then
				return
			end

			v7({
				interventionDetail = {
					moderationDetail = moderationDetail,
					options = options,
					abuseVector = abuseVector,
					onClosed = data.onClosed
				},
				type = constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = constants.TreatmentType.UniversalFeatureRestriction,
				isShown = true
			})

			if FFlagUFRRunUnlessFeatureRestricted and data.onHandled then
				data.onHandled()
			end
		end)

		return function()
			if connection then
				connection:disconnect()
			end

			connection2:disconnect()
			connection3:disconnect()
		end
	end, fFlagAppChatUniversalFeatureRestriction and { v6 } or {})

	return nil
end

return LUAUFORGE_MODULE_GLOBALS_hPc_InAppInterventionEventReceiver
