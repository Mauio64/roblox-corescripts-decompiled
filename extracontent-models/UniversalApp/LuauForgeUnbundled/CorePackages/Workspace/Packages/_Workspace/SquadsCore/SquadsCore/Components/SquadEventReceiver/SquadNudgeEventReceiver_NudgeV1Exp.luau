local HttpService = game:GetService("HttpService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
local SquadGameJoinOrigin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadGameJoinOrigin")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local actOnPartyNudge = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/actOnPartyNudge")

local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ExperienceService")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotificationsProtocol")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch

local experienceService = ExperienceService.ExperienceService
local gameParams = ExperienceService.GameParams

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

return function(p2): nil
	local v5 = useDispatch()
	local v6 = React.useContext(SquadExternalContractContext)

	local v7 = v6.useIsChatEnabled()
	local v8 = v6.useIsLoadingChatSettings()

	local ref = React.useRef({})

	local v9 = React.useCallback(function(p3): boolean
		if v8 or v7 then
			return false
		end

		default:dismissNotification(p3)
		return true
	end, { v8, v7 })

	local v10 = React.useCallback(function(p3, p4, p5)
		ref.current[p3] = {
			toastType = p4.notificationType,
			partyAttemptId = HttpService:GenerateGUID(false),
			shouldActWhenDismiss = true,
			nudgeId = p5.nudgeId,
			nudgeType = p5.nudgeType
		}
	end, {})

	local v11 = React.useCallback(function(p3, p4)
		local fireSquadAnalytics = v6.fireSquadAnalytics
		local squadToastActions = EventNames.SquadToastActions

		local v13 = if ref.current[p3] then ref.current[p3].toastType else nil

		local v14 = if ref.current[p3] then ref.current[p3].nudgeId else nil

		local v15 = if ref.current[p3] then ref.current[p3].nudgeType else nil

		local v16 = if ref.current[p3] then ref.current[p3].partyAttemptId else nil
		fireSquadAnalytics(squadToastActions, {
			toastAction = p4,
			toastType = v13,
			nudgeId = v14,
			nudgeType = v15,
			partyAttemptId = v16,
			squadLocation = v6.squadLocation
		})
	end, { v6.fireSquadAnalytics, v6.squadLocation })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p3)
			if p3.notificationId and ref.current[p3.notificationId] then
				v11(p3.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if ref.current[p3.notificationId].shouldActWhenDismiss then
					local v12 = ref.current[p3.notificationId]
					local nudgeType = v12.nudgeType
					local toastType = v12.toastType

					if
						(nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE)
						and toastType == notificationTypeEnum.SquadNudgeInvite
					then
						v5(actOnPartyNudge(
							Constants.REJECT_PARTY_INVITE_ACTION,
							v12.nudgeId,
							false,
							v6.setSquadPrompt,
							v6.fireSquadAnalytics,
							v6.squadLocation,
							v7
						))
					end
				end
			end

			ref.current[p3.notificationId] = nil
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v11, v7, v6.setSquadPrompt, v6.fireSquadAnalytics, v6.squadLocation })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadNudgeInvite,
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

					if v9(id) then
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if jsonDecode.nudgeType ~= Constants.PARTY_TO_ONE_NUDGE_TYPE then
						local v12 = jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE
					end
				end
			end
		)

		local callback2 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.NudgeForInviterSquad,
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

					if v9(id) then
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if
						jsonDecode.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE
						or jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE
					then
						if data.visualItem.visualItemName == Constants.JOIN_EXPERIENCE_FROM_NUDGE_BUTTON_TYPE then
							default:dismissNotification(id)
							v11(id, SquadToastActionsAndStates.PartyNudgeAccept)

							experienceService:LaunchExperience(
								gameParams.fromPlaceId(jsonDecode.placeId),
								SquadGameJoinOrigin.NudgeForInviterSquad,
								nil
							)
						elseif data.visualItem.visualItemName == Constants.DISMISS_INVITER_SQUAD_NUDGE_BUTTON_TYPE then
							v11(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
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
		v9,
		v11,
		v6,
		v6.setSquadPrompt,
		v6.fireSquadAnalytics,
		v6.squadLocation,
		p2.currentSquadId
	})

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadNudgeInvite,
			function(p3)
				local actionEventParams = p3.state.visualItems.button[1].actionEventParams
				local id = p3.id

				if v9(id) then
					return
				end

				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if
					(jsonDecode.nudgeType == Constants.PARTY_TO_ONE_NUDGE_TYPE or jsonDecode.nudgeType == Constants.PARTY_TO_PARTY_NUDGE_TYPE)
					and p2.currentSquadId ~= ""
					and p2.currentSquadId == jsonDecode.squadId
				then
					default:dismissNotification(id)
					return
				end

				v10(id, p3, jsonDecode)
				v11(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback2 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.NudgeForInviterSquad,
			function(p3)
				local actionEventParams = p3.state.visualItems.button[1].actionEventParams
				local id = p3.id

				if v9(id) then
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

					if p2.currentSquadId == "" or p2.currentSquadId ~= jsonDecode.squadId then
						default:dismissNotification(id)
						return
					end
				end

				v10(id, p3, jsonDecode)
				v11(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback3 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadJoinRequestPrompt,
			function(p3)
				local actionEventParams = p3.state.visualItems.button[1].actionEventParams
				local id = p3.id

				if v9(id) then
					return
				end

				v10(id, p3, (HttpService:JSONDecode(actionEventParams)))
				v11(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end
		)

		local callback4 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadAcceptJoinRequest,
			function(p3)
				local actionEventParams = p3.state.visualItems.button[1].actionEventParams
				local id = p3.id

				if v9(id) then
					return
				end

				v10(id, p3, (HttpService:JSONDecode(actionEventParams)))
				v11(id, SquadToastActionsAndStates.PartyNudgeDisplay)
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
	end, { v9, v10, v11, p2.currentSquadId })

	return nil
end
