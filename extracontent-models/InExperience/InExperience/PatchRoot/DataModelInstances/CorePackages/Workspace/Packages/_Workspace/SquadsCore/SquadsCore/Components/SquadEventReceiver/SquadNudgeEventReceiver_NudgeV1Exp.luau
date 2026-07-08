local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local HttpService = game:GetService("HttpService")
local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadGameJoinOrigin = require(SquadsCore.Enums.SquadGameJoinOrigin)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)
local ExperienceService = require(SquadsCoreParent.ExperienceService)
local React = require(SquadsCoreParent.React)
local ToastNotification = require(SquadsCoreParent.ToastNotification)
local ToastNotificationsProtocol = require(SquadsCoreParent.ToastNotificationsProtocol)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local ExperienceService2 = ExperienceService.ExperienceService
local GameParams = ExperienceService.GameParams
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), default (copy), HttpService (copy), EventNames (copy), SquadToastActionsAndStates (copy), Constants (copy), NotificationTypeEnum (copy), actOnPartyNudge (copy), LifecycleEvents (copy), GameParams (copy), ExperienceService2 (copy), SquadGameJoinOrigin (copy)
	local v21 = useDispatch()
	local v22 = React.useContext(SquadExternalContractContext)
	local v23 = v22.useIsChatEnabled()
	local v24 = v22.useIsLoadingChatSettings()
	local v25 = React.useRef({})
	local v26 = React.useCallback(function(s1: string) -- line: 43
		-- upvalues: v24 (copy), v23 (copy), default (copy)
		if not v24 and not v23 then
			default:dismissNotification(s1)

			return true
		end

		return false
	end, {
		v24,
		v23
	})
	local v27 = React.useCallback(function(s2: string, p1, p2) -- line: 52
		-- upvalues: v25 (copy), HttpService (copy)
		v25.current[s2] = {
			shouldActWhenDismiss = true,
			toastType = p1.notificationType,
			partyAttemptId = HttpService:GenerateGUID(false),
			nudgeId = p2.nudgeId,
			nudgeType = p2.nudgeType
		}
	end, {})
	local v28 = React.useCallback(function(s3: string, s4: string) -- line: 64
		-- upvalues: v22 (copy), EventNames (copy), v25 (copy)
		v22.fireSquadAnalytics(EventNames.SquadToastActions, {
			toastAction = s4,
			toastType = if not v25.current[s3] then nil else v25.current[s3].toastType,
			nudgeId = if not v25.current[s3] then nil else v25.current[s3].nudgeId,
			nudgeType = if not v25.current[s3] then nil else v25.current[s3].nudgeType,
			partyAttemptId = if not v25.current[s3] then nil else v25.current[s3].partyAttemptId,
			squadLocation = v22.squadLocation
		})
	end, {
		v22.fireSquadAnalytics,
		v22.squadLocation
	})

	React.useEffect(function() -- line: 83
		-- upvalues: default (copy), v25 (copy), v28 (copy), SquadToastActionsAndStates (copy), Constants (copy), NotificationTypeEnum (copy), v21 (copy), actOnPartyNudge (copy), v22 (copy), v23 (copy)
		local v35 = default:listenToDismissNotification(function(p3) -- line: 85
			-- upvalues: v25 (copy), v28 (copy), SquadToastActionsAndStates (copy), Constants (copy), NotificationTypeEnum (copy), v21 (copy), actOnPartyNudge (copy), v22 (copy), v23 (copy)
			if p3.notificationId and v25.current[p3.notificationId] then
				v28(p3.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if v25.current[p3.notificationId].shouldActWhenDismiss then
					local v43 = v25.current[p3.notificationId]
					local nudgeType = v43.nudgeType
					local toastType = v43.toastType

					if (nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE) and toastType == NotificationTypeEnum.SquadNudgeInvite then
						local REJECT_PARTY_INVITE_ACTION = Constants.REJECT_PARTY_INVITE_ACTION

						v21(actOnPartyNudge(REJECT_PARTY_INVITE_ACTION, v43.nudgeId, false, v22.setSquadPrompt, v22.fireSquadAnalytics, v22.squadLocation, v23))
					end
				end
			end

			v25.current[p3.notificationId] = nil
		end)

		return function() -- line: 121
			-- upvalues: v35 (copy)
			if v35 then
				v35:Disconnect()
			end
		end
	end, {
		v28,
		v23,
		v22.setSquadPrompt,
		v22.fireSquadAnalytics,
		v22.squadLocation
	})
	React.useEffect(function() -- line: 134
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v25 (copy), v26 (copy), HttpService (copy), Constants (copy), default (copy), v28 (copy), SquadToastActionsAndStates (copy), GameParams (copy), ExperienceService2 (copy), SquadGameJoinOrigin (copy)
		local v36 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadNudgeInvite, function(p4) -- line: 138
			-- upvalues: v25 (copy), v26 (copy), HttpService (copy), Constants (copy)
			if p4 and (p4.userActionType == "click" and p4.notificationData and p4.visualItem and p4.visualItem.actionEventParams and p4.visualItem.visualItemName) then
				local id = p4.notificationData.id

				if v25.current[id] then
					v25.current[id].shouldActWhenDismiss = false
				end

				if v26(id) then
					return
				end

				local data = HttpService:JSONDecode(p4.visualItem.actionEventParams)

				if data.nudgeType ~= Constants.PARTY_TO_ONE_NUDGE_TYPE then
					if data.nudgeType ~= Constants.PARTY_TO_PARTY_NUDGE_TYPE then
					end
				end
			end
		end)
		local v37 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.NudgeForInviterSquad, function(p5) -- line: 171
			-- upvalues: v25 (copy), v26 (copy), HttpService (copy), Constants (copy), default (copy), v28 (copy), SquadToastActionsAndStates (copy), GameParams (copy), ExperienceService2 (copy), SquadGameJoinOrigin (copy)
			if p5 and (p5.userActionType == "click" and p5.notificationData and p5.visualItem and p5.visualItem.actionEventParams and p5.visualItem.visualItemName) then
				local id = p5.notificationData.id

				if v25.current[id] then
					v25.current[id].shouldActWhenDismiss = false
				end

				if v26(id) then
					return
				end

				local data = HttpService:JSONDecode(p5.visualItem.actionEventParams)

				if data.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or data.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE then
					if p5.visualItem.visualItemName == Constants.JOIN_EXPERIENCE_FROM_NUDGE_BUTTON_TYPE then
						default:dismissNotification(id)
						v28(id, SquadToastActionsAndStates.PartyNudgeAccept)

						local v53 = GameParams.fromPlaceId(data.placeId)

						ExperienceService2:LaunchExperience(v53, SquadGameJoinOrigin.NudgeForInviterSquad, nil)

						return
					end

					if p5.visualItem.visualItemName == Constants.DISMISS_INVITER_SQUAD_NUDGE_BUTTON_TYPE then
						v28(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
					end
				end
			end
		end)

		return function() -- line: 217
			-- upvalues: v36 (copy), v37 (copy)
			if v36 then
				v36()
			end

			if v37 then
				v37()
			end
		end
	end, {
		v26,
		v28,
		v22,
		v22.setSquadPrompt,
		v22.fireSquadAnalytics,
		v22.squadLocation,
		t1.currentSquadId
	})
	React.useEffect(function() -- line: 236
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v26 (copy), HttpService (copy), Constants (copy), t1 (copy), default (copy), v27 (copy), v28 (copy), SquadToastActionsAndStates (copy)
		local v38 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadNudgeInvite, function(p6) -- line: 240
			-- upvalues: v26 (copy), HttpService (copy), Constants (copy), t1 (copy), default (copy), v27 (copy), v28 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p6.state.visualItems.button[1].actionEventParams
			local id = p6.id

			if v26(id) then
				return
			end

			local data = HttpService:JSONDecode(actionEventParams)

			if (data.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or data.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE) and t1.currentSquadId ~= "" and t1.currentSquadId == data.squadId then
				default:dismissNotification(id)

				return
			end

			v27(id, p6, data)
			v28(id, SquadToastActionsAndStates.PartyNudgeDisplay)
		end)
		local v39 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.NudgeForInviterSquad, function(p7) -- line: 269
			-- upvalues: v26 (copy), HttpService (copy), Constants (copy), default (copy), t1 (copy), v27 (copy), v28 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p7.state.visualItems.button[1].actionEventParams
			local id = p7.id

			if v26(id) then
				return
			end

			local data = HttpService:JSONDecode(actionEventParams)

			if data.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or data.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE then
				if data.gameInstanceId == game.JobId then
					default:dismissNotification(id)

					return
				end

				if t1.currentSquadId == "" or t1.currentSquadId ~= data.squadId then
					default:dismissNotification(id)

					return
				end
			end

			v27(id, p7, data)
			v28(id, SquadToastActionsAndStates.PartyNudgeDisplay)
		end)
		local v40 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadJoinRequestPrompt, function(p8) -- line: 301
			-- upvalues: v26 (copy), HttpService (copy), v27 (copy), v28 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p8.state.visualItems.button[1].actionEventParams
			local id = p8.id

			if v26(id) then
				return
			end

			local data = HttpService:JSONDecode(actionEventParams)

			v27(id, p8, data)
			v28(id, SquadToastActionsAndStates.PartyNudgeDisplay)
		end)
		local v41 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadAcceptJoinRequest, function(p9) -- line: 318
			-- upvalues: v26 (copy), HttpService (copy), v27 (copy), v28 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p9.state.visualItems.button[1].actionEventParams
			local id = p9.id

			if v26(id) then
				return
			end

			local data = HttpService:JSONDecode(actionEventParams)

			v27(id, p9, data)
			v28(id, SquadToastActionsAndStates.PartyNudgeDisplay)
		end)

		return function() -- line: 332
			-- upvalues: v38 (copy), v39 (copy), v40 (copy), v41 (copy)
			if v38 then
				v38()
			end

			if v39 then
				v39()
			end

			if v40 then
				v40()
			end

			if v41 then
				v41()
			end
		end
	end, {
		v26,
		v27,
		v28,
		t1.currentSquadId
	})

	return nil
end
