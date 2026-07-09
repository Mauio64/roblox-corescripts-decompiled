local InAppIntervention = script:FindFirstAncestor("InAppIntervention")
local InAppInterventionParent = InAppIntervention.Parent
local React = require(InAppInterventionParent.React)
local RealtimeDelivery = require(InAppInterventionParent.RealtimeDelivery)
local SetCentralOverlay = require(InAppInterventionParent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(InAppInterventionParent.RobloxAppEnums).CentralOverlayType
local useDispatch = require(InAppInterventionParent.RoactUtils).Hooks.RoactRodux.useDispatch
local InterventionAnalytics = require(InAppInterventionParent.InterventionShared).InterventionAnalytics
local InterventionTreatmentConfigList = require(InAppIntervention.InterventionTreatmentConfigs.InterventionTreatmentConfigList)
local chatInputBoxDisabledPressedSignal = require(InAppInterventionParent.InterventionShared).Signals.chatInputBoxDisabledPressedSignal
local featureRestrictionDisplaySignal = require(InAppInterventionParent.UniversalFeatureRestrictions.featureRestrictionDisplaySignal)
local featureRestrictionDisplayDirectSignal = require(InAppInterventionParent.UniversalFeatureRestrictions.featureRestrictionDisplayDirectSignal)
local GetModerationDetail = require(InAppInterventionParent.InterventionShared).Http.GetModerationDetail
local Constants = require(InAppInterventionParent.InterventionShared).Utils.Constants
local useIsUserInExperience = require(InAppInterventionParent.RobloxAppHooks).useIsUserInExperience
local FFlagUniversalFeatureRestrictionReceivers = require(InAppInterventionParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers

function InAppInterventionEventReceiver() -- line: 22
	-- upvalues: useDispatch (copy), React (copy), SetCentralOverlay (copy), CentralOverlayType (copy), useIsUserInExperience (copy), InterventionTreatmentConfigList (copy), RealtimeDelivery (copy), chatInputBoxDisabledPressedSignal (copy), Constants (copy), FFlagUniversalFeatureRestrictionReceivers (copy), featureRestrictionDisplaySignal (copy), GetModerationDetail (copy), InterventionAnalytics (copy), featureRestrictionDisplayDirectSignal (copy)
	local v17 = useDispatch()
	local v18 = React.useCallback(function(p1) -- line: 25
		-- upvalues: v17 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
		v17(SetCentralOverlay(CentralOverlayType.InAppIntervention, {
			uiState = p1
		}))
	end, { v17 })
	local v19 = useIsUserInExperience()
	local v20 = React.useMemo(function() -- line: 30
		-- upvalues: v19 (copy)
		return {
			isUserInExperience = v19
		}
	end, { v19 })
	local v21 = React.useCallback(function(p2) -- line: 36
		-- upvalues: InterventionTreatmentConfigList (copy), v20 (copy), v17 (copy), v18 (copy)
		for _, v25 in InterventionTreatmentConfigList do
			if v25.shouldTriggerEventReceived(p2, v20) then
				v25.onTriggerEventReceived(p2)
			end

			if v25.shouldTriggerVisualTreatment(p2, v20) then
				v25.onTriggerVisualTreatment(v17, v18, p2)
			end

			if v25.shouldTriggerBehavioralTreatment(p2, v20) then
				v25.onTriggerBehavioralTreatment(p2)
			end
		end
	end, {
		InterventionTreatmentConfigList,
		v18,
		v20
	})

	RealtimeDelivery.useRealtimeNamespace("FeatureIntervention", function(p3) -- line: 50
		-- upvalues: v21 (copy)
		v21(p3)
	end, { v21 })
	React.useEffect(function() -- line: 54
		-- upvalues: chatInputBoxDisabledPressedSignal (copy), v18 (copy), Constants (copy), FFlagUniversalFeatureRestrictionReceivers (copy), featureRestrictionDisplaySignal (copy), GetModerationDetail (copy), InterventionAnalytics (copy), featureRestrictionDisplayDirectSignal (copy)
		local v27 = chatInputBoxDisabledPressedSignal:connect(function(p4) -- line: 55
			-- upvalues: v18 (copy), Constants (copy)
			v18({
				isShown = true,
				interventionDetail = {
					decisionEventId = p4.decisionEventId,
					timeoutDurationSeconds = p4.duration
				},
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
				endTime = p4.endTimestamp
			})
		end)
		local u28 = nil

		if FFlagUniversalFeatureRestrictionReceivers then
			u28 = featureRestrictionDisplaySignal:connect(function(p5) -- line: 71
				-- upvalues: GetModerationDetail (copy), InterventionAnalytics (copy), Constants (copy), v18 (copy)
				local abuseVector = p5.abuseVector
				local options = p5.options
				local u34 = nil

				GetModerationDetail({
					abuseVector = abuseVector
				}):andThen(function(p6) -- line: 77
					-- upvalues: u34 (ref)
					u34 = p6
				end):catch(function(p7) -- line: 80
					-- upvalues: InterventionAnalytics (copy), Constants (copy), abuseVector (copy)
					InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.GetModerationDetailFailed, {
						eventType = InterventionAnalytics.Constants.EventTypes.GetModerationDetailFailed,
						placement = Constants.InterventionPlacementType.InApp,
						renderedTimestamp = DateTime.now().UnixTimestampMillis,
						error = p7.error,
						abuseVector = abuseVector
					})
				end):await()

				if not u34 then
					return
				end

				if not u34.acknowledgeable then
					return
				end

				v18({
					isShown = true,
					interventionDetail = {
						moderationDetail = u34,
						options = options,
						abuseVector = abuseVector
					},
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.UniversalFeatureRestriction
				})
			end)
		end

		local u29 = nil

		if FFlagUniversalFeatureRestrictionReceivers then
			u29 = featureRestrictionDisplayDirectSignal:connect(function(p8) -- line: 122
				-- upvalues: v18 (copy), Constants (copy)
				local abuseVector = p8.abuseVector
				local moderationDetail = p8.moderationDetail
				local options = p8.options

				if not moderationDetail then
					return
				end

				v18({
					isShown = true,
					interventionDetail = {
						moderationDetail = moderationDetail,
						options = options,
						abuseVector = abuseVector
					},
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.UniversalFeatureRestriction
				})
			end)
		end

		return function() -- line: 146
			-- upvalues: v27 (copy), FFlagUniversalFeatureRestrictionReceivers (copy), u28 (ref), u29 (ref)
			if v27 then
				v27:disconnect()
			end

			if FFlagUniversalFeatureRestrictionReceivers and u28 then
				u28:disconnect()
			end

			if FFlagUniversalFeatureRestrictionReceivers and u29 then
				u29:disconnect()
			end
		end
	end, {})

	return nil
end

return InAppInterventionEventReceiver
