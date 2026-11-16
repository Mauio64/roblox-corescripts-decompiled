local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local Chat = game:GetService("Chat")
local FeatureRestrictionManager = game:GetService("FeatureRestrictionManager")
local HttpService = game:GetService("HttpService")
local NotificationService = game:GetService("NotificationService")

local React = require(parent.React)

local InterventionShared = require(parent.InterventionShared)
local chatInputBoxDisabledPressedSignal = InterventionShared.Signals.chatInputBoxDisabledPressedSignal
local InterventionShared2 = require(parent.InterventionShared)
local dictationSafetyReminderSignal = InterventionShared2.Signals.dictationSafetyReminderSignal

local InterventionShared3 = require(parent.InterventionShared)
local experienceChatInterventionShownSignal = InterventionShared3.Signals.experienceChatInterventionShownSignal
local InterventionShared4 = require(parent.InterventionShared)
local Constants = InterventionShared4.Utils.Constants
local InterventionShared5 = require(parent.InterventionShared)
local determineUFRInterventionType = InterventionShared5.Utils.determineUFRInterventionType

local featureRestrictionDisplayDirectSignal = require(parent.UniversalFeatureRestrictions.featureRestrictionDisplayDirectSignal)
local featureRestrictionDisplaySignal = require(parent.UniversalFeatureRestrictions.featureRestrictionDisplaySignal)
local InterventionShared6 = require(parent.InterventionShared)
local GetModerationDetail = InterventionShared6.Http.GetModerationDetail
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local InterventionShared7 = require(parent.InterventionShared)
local InterventionAnalytics = InterventionShared7.InterventionAnalytics
local InterventionTreatmentConfigList = require(InExperienceIntervention.InterventionTreatmentConfigs.InterventionTreatmentConfigList)
local InterventionTypes = InterventionAnalytics.Constants.InterventionTypes

local SharedFlags = require(parent.SharedFlags)
local GetFFlagGameJoinTimeoutChatAttemptEnabled = SharedFlags.GetFFlagGameJoinTimeoutChatAttemptEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppChatUniversalFeatureRestriction = SharedFlags2.FFlagAppChatUniversalFeatureRestriction
local FFlagUFRImprovements = require(parent.InterventionShared.FFlagUFRImprovements)
local FFlagUFRAppealsAndModNoteFix = require(parent.InterventionShared.FFlagUFRAppealsAndModNoteFix)

local FFlagUFRRunUnlessFeatureRestricted = require(parent.UniversalFeatureRestrictions.FFlagUFRRunUnlessFeatureRestricted)

local SharedFlags3 = require(parent.SharedFlags)
local FFlagExpChatDictationContinuousSafetyReminder = SharedFlags3.FFlagExpChatDictationContinuousSafetyReminder

local SharedFlags4 = require(parent.SharedFlags)
local FFlagExpChatDictationStopOnSafetyIntervention = SharedFlags4.FFlagExpChatDictationStopOnSafetyIntervention

function InExperienceInterventionEventReceiver(p)
	React.useEffect(function()
		local robloxEventReceivedConnection = NotificationService.RobloxEventReceived:Connect(function(p2)
			if p2.namespace == Constants.FEATURE_INTERV_SIGNAL_NAMESPACE then
				local success, result = pcall(function()
					return HttpService:JSONDecode(p2.detail)
				end)

				if not success then
					return
				end

				for _, interventionTreatmentConfig in InterventionTreatmentConfigList do
					if interventionTreatmentConfig.shouldTriggerEventReceived(result) then
						interventionTreatmentConfig.onTriggerEventReceived(result)
					end

					if interventionTreatmentConfig.shouldTriggerVisualTreatment(result) then
						interventionTreatmentConfig.onTriggerVisualTreatment(p.uiStateDispatch, result)
					end

					if interventionTreatmentConfig.shouldTriggerBehavioralTreatment(result) then
						interventionTreatmentConfig.onTriggerBehavioralTreatment(result)
					end
				end
			end
		end)

		local timeoutChatAttemptConnection = Chat.TimeoutChatAttempt:Connect(function(_, endTime)
			p.uiStateDispatch({
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.ChatTimeoutChatAttempt,
				endTime = endTime,
				isShown = true
			})

			if FFlagExpChatDictationStopOnSafetyIntervention then
				experienceChatInterventionShownSignal:fire()
			end
		end)
		local timeoutChatAttemptConnection2

		if GetFFlagGameJoinTimeoutChatAttemptEnabled() then
			timeoutChatAttemptConnection2 = FeatureRestrictionManager.TimeoutChatAttempt:Connect(function(_, endTime)
				p.uiStateDispatch({
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.ChatTimeoutGameJoin,
					endTime = endTime,
					isShown = true
				})

				if FFlagExpChatDictationStopOnSafetyIntervention then
					experienceChatInterventionShownSignal:fire()
				end
			end)
		else
			timeoutChatAttemptConnection2 = nil
		end

		local featureTimeoutAttemptConnection = FeatureRestrictionManager.FeatureTimeoutAttempt:Connect(function(_, p2: number, p3: number, p4)
			if p4 == Enum.FeatureRestrictionAbuseVector.ExperienceChat then
				p.uiStateDispatch({
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.ChatTimeoutChatAttempt,
					endTime = p2 + p3,
					isShown = true
				})

				if FFlagExpChatDictationStopOnSafetyIntervention then
					experienceChatInterventionShownSignal:fire()
				end
			end
		end)

		local showFeatureInterventionDetailsConnection = FeatureRestrictionManager.ShowFeatureInterventionDetails:Connect(function(p2)
			if p2 == Enum.FeatureRestrictionAbuseVector.ExperienceChat then
				local moderationDetail = nil

				GetModerationDetail({ abuseVector = Constants.AbuseVectorType.ExperienceChat }):andThen(function(p3)
					moderationDetail = p3
				end):catch(function(p3)
					InExperienceInterventionAnalytics.sendAnalyticsEvent(
						InExperienceInterventionAnalytics.Constants.EventTypes.GetModerationDetailFailed,
						nil,
						DateTime.now().UnixTimestampMillis,
						nil,
						nil,
						nil,
						p3.error
					)
				end):await()

				if not (moderationDetail and moderationDetail.acknowledgeable) then
					return
				end

				if FFlagExpChatDictationStopOnSafetyIntervention then
					experienceChatInterventionShownSignal:fire()
				end

				local punishmentTypeDescription = moderationDetail.punishmentTypeDescription

				if FFlagUFRImprovements then
					local v = determineUFRInterventionType(punishmentTypeDescription)

					if v == InterventionTypes.UFRTimeout then
						p.uiStateDispatch({
							type = Constants.UIStateActions.ToggleNotificationDialog,
							treatmentType = Constants.TreatmentType.ChatTimeoutDialogV2,
							detail = { moderationDetail = moderationDetail },
							isShown = true
						})
					elseif v == InterventionTypes.UFRNudge then
						p.uiStateDispatch({
							type = Constants.UIStateActions.ToggleNotificationDialog,
							treatmentType = Constants.TreatmentType.ChatNudgeDialogV2,
							detail = { moderationDetail = moderationDetail },
							isShown = true
						})
					end
				elseif punishmentTypeDescription == Constants.PunishmentTypeDescription.ChatTimeout then
					p.uiStateDispatch({
						type = Constants.UIStateActions.ToggleNotificationDialog,
						treatmentType = Constants.TreatmentType.ChatTimeoutDialogV2,
						detail = { moderationDetail = moderationDetail },
						isShown = true
					})
				elseif punishmentTypeDescription == Constants.PunishmentTypeDescription.ChatNudge then
					p.uiStateDispatch({
						type = Constants.UIStateActions.ToggleNotificationDialog,
						treatmentType = Constants.TreatmentType.ChatNudgeDialogV2,
						detail = { moderationDetail = moderationDetail },
						isShown = true
					})
				end
			end
		end)

		local featureTimeoutRestoredConnection = FeatureRestrictionManager.FeatureTimeoutRestored:Connect(function(p2)
			print("FeatureTimeoutRestored - Abuse Vector: ", p2)
		end)
		local connection

		if FFlagAppChatUniversalFeatureRestriction then
			connection = nil
		else
			connection = chatInputBoxDisabledPressedSignal:connect(function(data)
				p.uiStateDispatch({
					detail = {
						decisionEventId = data.decisionEventId,
						timeoutDurationSeconds = data.duration
					},
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.PartyChatTimeoutDialog,
					endTime = data.endTimestamp,
					isShown = true
				})
			end)
		end

		local connection2

		if FFlagExpChatDictationContinuousSafetyReminder then
			connection2 = dictationSafetyReminderSignal:connect(function()
				p.uiStateDispatch({
					type = Constants.UIStateActions.ToggleNotificationDialog,
					treatmentType = Constants.TreatmentType.DictationSafetyReminderToast,
					isShown = true
				})
			end)
		else
			connection2 = nil
		end

		local connection3 = featureRestrictionDisplaySignal:connect(function(p2)
			local abuseVector = p2.abuseVector
			local options = p2.options
			local moderationDetail = nil

			GetModerationDetail({ abuseVector = abuseVector }):andThen(function(p3)
				moderationDetail = p3
			end):catch(function(p3)
				InterventionAnalytics.sendAnalyticsEvent(
					InterventionAnalytics.TelemetryConfigs.GetModerationDetailFailed,
					{
						eventType = InterventionAnalytics.Constants.EventTypes.GetModerationDetailFailed,
						placement = Constants.InterventionPlacementType.InExperience,
						renderedTimestamp = DateTime.now().UnixTimestampMillis,
						error = p3.error,
						abuseVector = abuseVector
					}
				)
			end):await()

			if not moderationDetail or FFlagUFRAppealsAndModNoteFix and next(moderationDetail) == nil then
				return
			end

			p.uiStateDispatch({
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.UniversalFeatureRestriction,
				detail = {
					moderationDetail = moderationDetail,
					options = options,
					abuseVector = abuseVector
				},
				isShown = true
			})
		end)

		local connection4 = featureRestrictionDisplayDirectSignal:connect(function(data)
			local abuseVector = data.abuseVector
			local moderationDetail = data.moderationDetail
			local options = data.options

			if not moderationDetail then
				return
			end

			p.uiStateDispatch({
				type = Constants.UIStateActions.ToggleNotificationDialog,
				treatmentType = Constants.TreatmentType.UniversalFeatureRestriction,
				detail = {
					moderationDetail = moderationDetail,
					options = options,
					abuseVector = abuseVector,
					onClosed = data.onClosed
				},
				isShown = true
			})

			if FFlagUFRRunUnlessFeatureRestricted and data.onHandled then
				data.onHandled()
			end
		end)

		return function()
			robloxEventReceivedConnection:Disconnect()
			timeoutChatAttemptConnection:Disconnect()

			if GetFFlagGameJoinTimeoutChatAttemptEnabled() then
				timeoutChatAttemptConnection2:Disconnect()
			end

			featureTimeoutAttemptConnection:Disconnect()
			showFeatureInterventionDetailsConnection:Disconnect()
			featureTimeoutRestoredConnection:Disconnect()

			if connection then
				connection:disconnect()
			end

			if connection2 then
				connection2:disconnect()
			end

			connection3:disconnect()
			connection4:disconnect()
		end
	end, {})

	return React.createElement("Frame", { BackgroundTransparency = 1 })
end

return InExperienceInterventionEventReceiver
