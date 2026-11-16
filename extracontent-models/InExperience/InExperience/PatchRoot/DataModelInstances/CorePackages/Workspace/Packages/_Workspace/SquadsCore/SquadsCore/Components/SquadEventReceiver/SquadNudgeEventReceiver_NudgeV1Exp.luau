local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local HttpService = game:GetService("HttpService")

local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadGameJoinOrigin = require(SquadsCore.Enums.SquadGameJoinOrigin)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)

local ExperienceService = require(parent.ExperienceService)
local React = require(parent.React)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local experienceService = ExperienceService.ExperienceService
local GameParams = ExperienceService.GameParams

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

return function(p): nil
	local v = useDispatch()
	local v2 = React.useContext(SquadExternalContractContext)

	local v3 = v2.useIsChatEnabled()
	local v4 = v2.useIsLoadingChatSettings()

	local ref = React.useRef({})

	local v5 = React.useCallback(function(p2: string): boolean
		if v4 or v3 then
			return false
		end

		default:dismissNotification(p2)
		return true
	end, { v4, v3 })

	local v6 = React.useCallback(function(p2: string, p3, p4)
		ref.current[p2] = {
			toastType = p3.notificationType,
			partyAttemptId = HttpService:GenerateGUID(false),
			shouldActWhenDismiss = true,
			nudgeId = p4.nudgeId,
			nudgeType = p4.nudgeType
		}
	end, {})

	local v7 = React.useCallback(function(p2: string, toastAction: string)
		local fireSquadAnalytics = v2.fireSquadAnalytics
		local squadToastActions = EventNames.SquadToastActions
		local toastType

		if ref.current[p2] then
			toastType = ref.current[p2].toastType
		end

		local nudgeId

		if ref.current[p2] then
			nudgeId = ref.current[p2].nudgeId
		end

		local nudgeType

		if ref.current[p2] then
			nudgeType = ref.current[p2].nudgeType
		end

		local partyAttemptId

		if ref.current[p2] then
			partyAttemptId = ref.current[p2].partyAttemptId
		end

		fireSquadAnalytics(squadToastActions, {
			toastAction = toastAction,
			toastType = toastType,
			nudgeId = nudgeId,
			nudgeType = nudgeType,
			partyAttemptId = partyAttemptId,
			squadLocation = v2.squadLocation
		})
	end, { v2.fireSquadAnalytics, v2.squadLocation })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p2)
			if p2.notificationId and ref.current[p2.notificationId] then
				v7(p2.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if ref.current[p2.notificationId].shouldActWhenDismiss then
					local v8 = ref.current[p2.notificationId]
					local nudgeType = v8.nudgeType
					local toastType = v8.toastType

					if
						(nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE)
						and toastType == NotificationTypeEnum.SquadNudgeInvite
					then
						v(actOnPartyNudge(
							Constants.REJECT_PARTY_INVITE_ACTION,
							v8.nudgeId,
							false,
							v2.setSquadPrompt,
							v2.fireSquadAnalytics,
							v2.squadLocation,
							v3
						))
					end
				end
			end

			ref.current[p2.notificationId] = nil
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v7, v3, v2.setSquadPrompt, v2.fireSquadAnalytics, v2.squadLocation })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadNudgeInvite,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
					and data.visualItem.visualItemName
				then
					local id = data.notificationData.id

					if ref.current[id] then
						ref.current[id].shouldActWhenDismiss = false
					end

					if v5(id) then
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if jsonDecode.nudgeType ~= Constants.PARTY_TO_ONE_NUDGE_TYPE then
						local _ = jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE
					end
				end
			end
		)

		local callback2 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.NudgeForInviterSquad,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
					and data.visualItem.visualItemName
				then
					local id = data.notificationData.id

					if ref.current[id] then
						ref.current[id].shouldActWhenDismiss = false
					end

					if v5(id) then
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if
						jsonDecode.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE
						or jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE
					then
						if data.visualItem.visualItemName == Constants.JOIN_EXPERIENCE_FROM_NUDGE_BUTTON_TYPE then
							default:dismissNotification(id)
							v7(id, SquadToastActionsAndStates.PartyNudgeAccept)

							experienceService:LaunchExperience(
								GameParams.fromPlaceId(jsonDecode.placeId),
								SquadGameJoinOrigin.NudgeForInviterSquad,
								nil
							)
						elseif data.visualItem.visualItemName == Constants.DISMISS_INVITER_SQUAD_NUDGE_BUTTON_TYPE then
							v7(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
						end
					end
				end
			end
		)

		return function()
			if callback then
				callback()
			end

			if callback2 then
				callback2()
			end
		end
	end, {
		v5,
		v7,
		v2,
		v2.setSquadPrompt,
		v2.fireSquadAnalytics,
		v2.squadLocation,
		p.currentSquadId
	})

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadNudgeInvite,
			function(p2)
				local actionEventParams = p2.state.visualItems.button[1].actionEventParams
				local id = p2.id

				if v5(id) then
					return
				end

				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if
					(jsonDecode.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE)
					and p.currentSquadId ~= ""
					and p.currentSquadId == jsonDecode.squadId
				then
					default:dismissNotification(id)
					return
				end

				v6(id, p2, jsonDecode)
				v7(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback2 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.NudgeForInviterSquad,
			function(p2)
				local actionEventParams = p2.state.visualItems.button[1].actionEventParams
				local id = p2.id

				if v5(id) then
					return
				end

				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if
					jsonDecode.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE
					or jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE
				then
					if jsonDecode.gameInstanceId == game.JobId then
						default:dismissNotification(id)
						return
					end

					if p.currentSquadId == "" or p.currentSquadId ~= jsonDecode.squadId then
						default:dismissNotification(id)
						return
					end
				end

				v6(id, p2, jsonDecode)
				v7(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback3 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadJoinRequestPrompt,
			function(p2)
				local actionEventParams = p2.state.visualItems.button[1].actionEventParams
				local id = p2.id

				if v5(id) then
					return
				end

				v6(id, p2, (HttpService:JSONDecode(actionEventParams)))
				v7(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback4 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadAcceptJoinRequest,
			function(p2)
				local actionEventParams = p2.state.visualItems.button[1].actionEventParams
				local id = p2.id

				if v5(id) then
					return
				end

				v6(id, p2, (HttpService:JSONDecode(actionEventParams)))
				v7(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		return function()
			if callback then
				callback()
			end

			if callback2 then
				callback2()
			end

			if callback3 then
				callback3()
			end

			if callback4 then
				callback4()
			end
		end
	end, { v5, v6, v7, p.currentSquadId })

	return nil
end
