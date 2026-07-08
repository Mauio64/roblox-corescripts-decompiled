local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local InExperienceInterventionParent = InExperienceIntervention.Parent
local NotificationService = game:GetService("NotificationService")
local HttpService = game:GetService("HttpService")
local Chat = game:GetService("Chat")
local React = require(InExperienceInterventionParent.React)
local chatInputBoxDisabledPressedSignal = require(InExperienceInterventionParent.InterventionShared).Signals.chatInputBoxDisabledPressedSignal
local Constants = require(InExperienceInterventionParent.InterventionShared).Utils.Constants
local featureRestrictionDisplaySignal = require(InExperienceInterventionParent.UniversalFeatureRestrictions.featureRestrictionDisplaySignal)
local featureRestrictionDisplayDirectSignal = require(InExperienceInterventionParent.UniversalFeatureRestrictions.featureRestrictionDisplayDirectSignal)
local GetModerationDetail = require(InExperienceInterventionParent.InterventionShared).Http.GetModerationDetail
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local InterventionAnalytics = require(InExperienceInterventionParent.InterventionShared).InterventionAnalytics
local InterventionTreatmentConfigList = require(InExperienceIntervention.InterventionTreatmentConfigs.InterventionTreatmentConfigList)
local GetFFlagGameJoinTimeoutChatAttemptEnabled = require(InExperienceInterventionParent.SharedFlags).GetFFlagGameJoinTimeoutChatAttemptEnabled
local FFlagUniversalFeatureRestrictionReceivers = require(InExperienceInterventionParent.SharedFlags).FFlagUniversalFeatureRestrictionReceivers
local FFlagTemporaryAvatarKickWarningDialog = require(InExperienceInterventionParent.InterventionShared.FFlagTemporaryAvatarKickWarningDialog)
local FeatureRestrictionManager = game:GetService("FeatureRestrictionManager")

function InExperienceInterventionEventReceiver(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), NotificationService (copy), Constants (copy), HttpService (copy), InterventionTreatmentConfigList (copy), FFlagTemporaryAvatarKickWarningDialog (copy), Chat (copy), GetFFlagGameJoinTimeoutChatAttemptEnabled (copy), FeatureRestrictionManager (copy), GetModerationDetail (copy), InExperienceInterventionAnalytics (copy), chatInputBoxDisabledPressedSignal (copy), FFlagUniversalFeatureRestrictionReceivers (copy), featureRestrictionDisplaySignal (copy), InterventionAnalytics (copy), featureRestrictionDisplayDirectSignal (copy)
	React.useEffect(function() -- line: 33
		-- upvalues: NotificationService (copy), Constants (copy), HttpService (copy), InterventionTreatmentConfigList (copy), t1 (copy), FFlagTemporaryAvatarKickWarningDialog (copy), Chat (copy), GetFFlagGameJoinTimeoutChatAttemptEnabled (copy), FeatureRestrictionManager (copy), GetModerationDetail (copy), InExperienceInterventionAnalytics (copy), chatInputBoxDisabledPressedSignal (copy), FFlagUniversalFeatureRestrictionReceivers (copy), featureRestrictionDisplaySignal (copy), InterventionAnalytics (copy), featureRestrictionDisplayDirectSignal (copy)
		local connection = NotificationService.RobloxEventReceived:Connect(function(p1) -- line: 34
			-- upvalues: Constants (copy), HttpService (copy), InterventionTreatmentConfigList (copy), t1 (copy), FFlagTemporaryAvatarKickWarningDialog (copy)
			if p1.namespace == Constants.FEATURE_INTERV_SIGNAL_NAMESPACE then
				local ok, result = pcall(function() -- line: 36
					-- upvalues: HttpService (copy), p1 (copy)
					return HttpService:JSONDecode(p1.detail)
				end)

				if not ok then
					return
				end

				for _, v33 in InterventionTreatmentConfigList do
					if v33.shouldTriggerEventReceived(result) then
						v33.onTriggerEventReceived(result)
					end

					if v33.shouldTriggerVisualTreatment(result) then
						v33.onTriggerVisualTreatment(t1.uiStateDispatch, result)
					end

					if v33.shouldTriggerBehavioralTreatment(result) then
						v33.onTriggerBehavioralTreatment(result)
					end
				end

				return
			end

			if FFlagTemporaryAvatarKickWarningDialog and p1.namespace == Constants.AVATAR_VIOLATION_SIGNAL_NAMESPACE then
				local ok, result = pcall(function() -- line: 60
					-- upvalues: HttpService (copy), p1 (copy)
					return HttpService:JSONDecode(p1.detail)
				end)

				if not ok then
					return
				end

				t1.uiStateDispatch({
					isShown = true,
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.TemporaryAvatarKickWarning,
					detail = {
						extras = {
							avatarEntityId = result.avatarEntityID,
							violationType = result.violationType,
							placeId = result.placeID
						}
					}
				})
			end
		end)
		local connection2 = Chat.TimeoutChatAttempt:Connect(function(_, p3) -- line: 83
			-- upvalues: t1 (copy), Constants (copy)
			t1.uiStateDispatch({
				isShown = true,
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.ChatTimeoutChatAttempt,
				endTime = p3
			})
		end)
		local connection3 = nil

		if GetFFlagGameJoinTimeoutChatAttemptEnabled() then
			connection3 = FeatureRestrictionManager.TimeoutChatAttempt:Connect(function(_, p5) -- line: 95
				-- upvalues: t1 (copy), Constants (copy)
				t1.uiStateDispatch({
					isShown = true,
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.ChatTimeoutGameJoin,
					endTime = p5
				})
			end)
		end

		local connection4 = FeatureRestrictionManager.FeatureTimeoutAttempt:Connect(function(_, p7, p8, p9) -- line: 107
			-- upvalues: t1 (copy), Constants (copy)
			if p9 == Enum.FeatureRestrictionAbuseVector.ExperienceChat then
				t1.uiStateDispatch({
					isShown = true,
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.ChatTimeoutChatAttempt,
					endTime = p7 + p8
				})
			end
		end)
		local connection5 = FeatureRestrictionManager.ShowFeatureInterventionDetails:Connect(function(p10) -- line: 120
			-- upvalues: GetModerationDetail (copy), Constants (copy), InExperienceInterventionAnalytics (copy), t1 (copy)
			if p10 == Enum.FeatureRestrictionAbuseVector.ExperienceChat then
				local u45 = nil

				GetModerationDetail({
					abuseVector = Constants.AbuseVectorType.ExperienceChat
				}):andThen(function(p11) -- line: 125
					-- upvalues: u45 (ref)
					u45 = p11
				end):catch(function(p12) -- line: 128
					-- upvalues: InExperienceInterventionAnalytics (copy)
					InExperienceInterventionAnalytics.sendAnalyticsEvent(InExperienceInterventionAnalytics.Constants.EventTypes.GetModerationDetailFailed, nil, DateTime.now().UnixTimestampMillis, nil, nil, nil, p12.error)
				end):await()

				if not u45 then
					return
				end

				if not u45.acknowledgeable then
					return
				end

				local punishmentTypeDescription = u45.punishmentTypeDescription

				if punishmentTypeDescription == Constants.PunishmentTypeDescription.ChatTimeout then
					t1.uiStateDispatch({
						isShown = true,
						type = Constants.UIStateActions.ToggleNotificationDialog,
						treatmentType = Constants.TreatmentType.ChatTimeoutDialogV2,
						detail = {
							moderationDetail = u45
						}
					})
				elseif punishmentTypeDescription == Constants.PunishmentTypeDescription.ChatNudge then
					t1.uiStateDispatch({
						isShown = true,
						type = Constants.UIStateActions.ToggleNotificationDialog,
						treatmentType = Constants.TreatmentType.ChatNudgeDialogV2,
						detail = {
							moderationDetail = u45
						}
					})
				end
			end
		end)
		local connection6 = FeatureRestrictionManager.FeatureTimeoutRestored:Connect(function(p13) -- line: 177
			print("FeatureTimeoutRestored - Abuse Vector: ", p13)
		end)
		local v26 = chatInputBoxDisabledPressedSignal:connect(function(p14) -- line: 183
			-- upvalues: t1 (copy), Constants (copy)
			t1.uiStateDispatch({
				isShown = true,
				detail = {
					decisionEventId = p14.decisionEventId,
					timeoutDurationSeconds = p14.duration
				},
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
				endTime = p14.endTimestamp
			})
		end)
		local u27 = nil

		if FFlagUniversalFeatureRestrictionReceivers then
			u27 = featureRestrictionDisplaySignal:connect(function(p15) -- line: 199
				-- upvalues: GetModerationDetail (copy), InterventionAnalytics (copy), Constants (copy), t1 (copy)
				local abuseVector = p15.abuseVector
				local options = p15.options
				local u52 = nil

				GetModerationDetail({
					abuseVector = abuseVector
				}):andThen(function(p16) -- line: 205
					-- upvalues: u52 (ref)
					u52 = p16
				end):catch(function(p17) -- line: 208
					-- upvalues: InterventionAnalytics (copy), Constants (copy), abuseVector (copy)
					InterventionAnalytics.sendAnalyticsEvent(InterventionAnalytics.TelemetryConfigs.GetModerationDetailFailed, {
						eventType = InterventionAnalytics.Constants.EventTypes.GetModerationDetailFailed,
						placement = Constants.InterventionPlacementType.InExperience,
						renderedTimestamp = DateTime.now().UnixTimestampMillis,
						error = p17.error,
						abuseVector = abuseVector
					})
				end):await()

				if not u52 then
					return
				end

				if not u52.acknowledgeable then
					return
				end

				t1.uiStateDispatch({
					isShown = true,
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.UniversalFeatureRestriction,
					detail = {
						moderationDetail = u52,
						options = options,
						abuseVector = abuseVector
					}
				})
			end)
		end

		local u28 = nil

		if FFlagUniversalFeatureRestrictionReceivers then
			u28 = featureRestrictionDisplayDirectSignal:connect(function(p18) -- line: 250
				-- upvalues: t1 (copy), Constants (copy)
				local abuseVector = p18.abuseVector
				local moderationDetail = p18.moderationDetail
				local options = p18.options

				if not moderationDetail then
					return
				end

				t1.uiStateDispatch({
					isShown = true,
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.UniversalFeatureRestriction,
					detail = {
						moderationDetail = moderationDetail,
						options = options,
						abuseVector = abuseVector
					}
				})
			end)
		end

		return function() -- line: 273
			-- upvalues: connection (copy), connection2 (copy), GetFFlagGameJoinTimeoutChatAttemptEnabled (copy), connection3 (ref), connection4 (copy), connection5 (copy), connection6 (copy), v26 (copy), FFlagUniversalFeatureRestrictionReceivers (copy), u27 (ref), u28 (ref)
			connection:Disconnect()
			connection2:Disconnect()

			if GetFFlagGameJoinTimeoutChatAttemptEnabled() then
				connection3:Disconnect()
			end

			connection4:Disconnect()
			connection5:Disconnect()
			connection6:Disconnect()

			if v26 then
				v26:disconnect()
			end

			if FFlagUniversalFeatureRestrictionReceivers and u27 then
				u27:disconnect()
			end

			if FFlagUniversalFeatureRestrictionReceivers and u28 then
				u28:disconnect()
			end
		end
	end, {})

	return React.createElement("Frame", {
		BackgroundTransparency = 1
	})
end

return InExperienceInterventionEventReceiver
