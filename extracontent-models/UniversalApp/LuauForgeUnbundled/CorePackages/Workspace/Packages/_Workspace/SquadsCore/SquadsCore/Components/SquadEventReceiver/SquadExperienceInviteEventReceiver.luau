local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")
local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")
local SquadToastType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastType")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadParentChannelId")
local GetSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetSquadExperienceInviteStore")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local ExperienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ExperienceService")
local localStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LocalStorage").Enums.LocalStorageKey
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")
local SoundManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SoundManager")

local squadCoordinationExperienceJoinExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SocialExperiments").SquadCoordinationExperienceJoinExperimentation
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotificationsProtocol")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/LuauPolyfill")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SignalsReact").useSignalState

local gameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local experienceInviteState = RoduxSquads.Enums.ExperienceInviteState
local experienceInviteVoteType = RoduxSquads.Enums.ExperienceInviteVoteType
local experienceInviteType = RoduxSquads.Enums.ExperienceInviteType

local sounds = SoundManager.Sounds
local soundManager = SoundManager.SoundManager

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local defineFastInt = game:DefineFastInt("SquadExperienceInvitePollingIntervalSeconds", 4)
local defineFastInt2 = game:DefineFastInt("SquadExperienceInviteTimeoutSeconds", 30)

local fFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled
local fFlagSquadLaunchExperienceMobileFix = SharedFlags.FFlagSquadLaunchExperienceMobileFix
local fFlagEnablePrivatePartyAcceptInvite = SharedFlags.FFlagEnablePrivatePartyAcceptInvite
local fFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local messageId = MessageBusService:GetMessageId("ToastNotifications", "userActionOnToastNotification")

return function(p2): nil
	local v5 = useDispatch()
	local v6 = tonumber(useLocalUserId()) or 0

	local v7 = React.useContext(SquadExternalContractContext)

	local state, setState = React.useState("")
	React.useEffect(function()
		local success, result = pcall(function()
			return AppStorageService:GetItem(localStorageKey.BrowserTrackerId)
		end)

		if success then
			setState(result)
		end

		local itemWasSetConnection = AppStorageService.ItemWasSet:Connect(function(p3, p4)
			if p3 == localStorageKey.BrowserTrackerId then
				setState(p4)
			end
		end)
		return function()
			itemWasSetConnection:Disconnect()
		end
	end, { setState })

	local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
	local ref = React.useRef(false)
	local v8 = React.useCallback(function(p3)
		if p3.Squad and p3.Squad.Squad then
			return p3.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v9

	if fFlagUseSignalsForSquadExperienceInvite then
		v9 = useSignalState(GetSquadExperienceInviteStore(false).getCurrentExperienceInvite)
	else
		v9 = useSelector(v8)
	end

	local v10 = useCurrentSquadParentChannelId()

	local model = v9 and v9.model
	local experienceInviteId = model and model.experienceInviteId or ""

	local state2 = model and model.state or ""

	local gameInstanceId = model and model.experienceDetail.gameInstanceId or ""

	local placeId = model and model.experienceDetail.placeId or 0

	local inviterId = model and model.inviterId or 0

	local v11, v12 = React.useMemo(function()
		if v9 and v9.model then
			for i, vote in ipairs(v9.model.votes) do
				if vote.userId == v6 then
					local v13 = if vote.voteIdentifier and vote.voteIdentifier ~= "" then vote.voteIdentifier ~= state else false

					return vote.voteType, v13
				end
			end

			return experienceInviteVoteType.NoVote, false
		elseif v9 and v9.notification.isInviter then
			return experienceInviteVoteType.Accept, false
		else
			return experienceInviteVoteType.Invalid, false
		end
	end, { v9, v6, state })

	local v13 = React.useCallback(function(p3, p4)
		if p4 then
			default:dismissNotification(p3)
		end

		if fFlagUseSignalsForSquadExperienceInvite then
			GetSquadExperienceInviteStore(false).currentExperienceInviteDismissed(p3)
		else
			v5(RoduxSquads.Actions.CurrentExperienceInviteDismissed(p3))
		end

		ref.current = false
	end, { v5 })

	local v14 = React.useCallback(function(p3, p4)
		return v5(NetworkingSquads.GetExperienceInvite.API({
			experienceInviteId = p3,
			membershipEntityId = p4
		})):catch(function(p5)
			local v17 = if fFlagDebugSquadLogsEnabled then HttpService:JSONEncode(p5) else not p5.StatusCode and -1 or p5.StatusCode

			Logger:warning(
				"Error getting experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}",
				v17,
				p3,
				p4
			)
		end)
	end, { v5 })
	local v15 = React.useCallback(function(p3, p4, p5)
		local v16 = { parentChannelId = v10, experienceInviteId = p3, voteType = p4 }

		return v5(NetworkingSquads.VoteForExperienceInvite.API({
			experienceInviteId = p3,
			membershipEntityId = p5,
			voteIdentifier = state,
			voteType = p4
		})):andThen(function()
			v7.fireSquadAnalytics(
				EventNames.SquadVoteApiCall,
				Cryo.Dictionary.union(v16, { isSuccess = true })
			)
		end):catch(function(p6)
			local body = p6.Body
			local success, result = pcall(function()
				return HttpService:JSONDecode(body)
			end)

			local errorType = if success then result.errorType else nil

			local fireSquadAnalytics = v7.fireSquadAnalytics
			local squadVoteApiCall = EventNames.SquadVoteApiCall
			local union = Cryo.Dictionary.union

			local v19 = if p6.StatusCode then tostring(p6.StatusCode) else nil
			fireSquadAnalytics(
				squadVoteApiCall,
				union(v16, {
					isSuccess = false,
					errorMessage = errorType,
					errorType = v19
				})
			)
			local v22 = if fFlagDebugSquadLogsEnabled then HttpService:JSONEncode(p6) else not p6.StatusCode and -1 or p6.StatusCode

			Logger:warning(
				"Error voting for experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}, VoteType: {}",
				v22,
				p3,
				p5,
				p4
			)
		end)
	end, { v5, state })

	local useCallback = React.useCallback
	local function fn(p3)
		v7.fireSquadAnalytics(EventNames.SquadExperienceInviteStateChange, {
			experienceInviteId = experienceInviteId,
			invitationGameInstanceId = gameInstanceId,
			invitationPlaceId = placeId,
			inviterId = inviterId,
			inviteState = state2,
			parentChannelId = v10,
			joinAttemptId = p3
		})
	end

	local v17 = if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then v7.fireSquadAnalytics else nil
	local v18 = useCallback(fn, {
		gameInstanceId,
		experienceInviteId,
		inviterId,
		placeId,
		state2,
		v10,
		v17
	})

	React.useEffect(function()
		local thread

		if v9 then
			thread = task.delay(defineFastInt2, function()
				v13(v9.notification.notificationId, true)
			end)
		else
			thread = nil
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v13, v9 })

	local useEffect = React.useEffect
	local function fn2()
		if not v9 or v11 ~= experienceInviteVoteType.Accept or ref.current then
			return
		end

		local model2 = v9.model
		local notification = v9.notification

		if not model2 or model2.state ~= experienceInviteState.ReservationSuccessful then
			return
		end

		local gameInstanceId2 = model2.experienceDetail.gameInstanceId
		local placeId2 = model2.experienceDetail.placeId

		if
			not fFlagEnablePrivatePartyAcceptInvite
			or v9.model.inviteType ~= experienceInviteType.PlayWithPartyInPrivatePartyServer
		then
			assert(gameInstanceId2, "Game instance id should exist.")
		end

		ref.current = true
		Logger:debug("Launching experience. GameInstanceId: {}, PlaceId: {}", gameInstanceId2, placeId2)

		local thread = task.delay(1, function()
			v13(notification.notificationId, true)

			if v7.squadLocation == SquadLocationEnum.InExperience and fFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			local v19 = v7.squadLocation == SquadLocationEnum.UniversalApp and "SquadExperienceInviteFromUA"
				or v7.squadLocation == SquadLocationEnum.InExperience and "SquadExperienceInviteFromInExp"
				or "SquadExperienceInvite"
			local v20

			if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				v20 = HttpService:GenerateGUID(false)
				v18(v20)
			end

			local v21 = gameParams.fromPlaceInstance(placeId2, gameInstanceId2)

			if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				v21.joinAttemptId = v20
			end

			if
				fFlagEnablePrivatePartyAcceptInvite
				and v9.model.inviteType == experienceInviteType.PlayWithPartyInPrivatePartyServer
			then
				v21.isPrivateParty = true
			end

			experienceService:LaunchExperience(v21, v19, nil)
		end)
		return function()
			task.cancel(thread)
		end
	end
	local squadLocation = v7.squadLocation

	local v20 = if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then v18 else nil
	useEffect(fn2, { squadLocation, v9, v13, v11, v20 })

	React.useEffect(function()
		local v21 = defineFastInt
		local v22

		if
			v9
			and (not v9.model or v9.model.state == experienceInviteState.Active or v9.model.state == experienceInviteState.Reserving)
		then
			v22 = setInterval(function()
				v14(v9.notification.experienceInviteId, v9.notification.membershipEntityId)
			end, v21 * 1000)
		else
			v22 = nil
		end

		return function()
			if v22 then
				clearInterval(v22)
			end
		end
	end, { v9, v14 })

	React.useEffect(function()
		if v9 and (p2.currentSquadId ~= v9.notification.membershipEntityId or v12) then
			v13(v9.notification.notificationId, true)
		end
	end, { v9, v13, p2.currentSquadId, v12 })
	React.useEffect(function()
		if experienceInviteState[state2] then
			if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				if experienceInviteState[state2] ~= experienceInviteState.ReservationSuccessful then
					v18()
				end
			else
				v18()
			end
		end
	end, { state2, v18 })

	React.useEffect(function()
		if not (v9 and v9.model) then
			return
		end

		Logger:debug("Current experience invite updated: {}", serializeTable(v9.model))

		local notificationId = v9.notification.notificationId
		local state3 = v9.model.state

		if v9.model.inviterId == v6 then
			if state3 == experienceInviteState.Active then
				if v9.model.spotsTaken > 1 then
					default:updateNotification(notificationId, v9.model.spotsTaken .. "SpotsFilled")
				end
			else
				if
					state3 == experienceInviteState.Reserving
					or state3 == experienceInviteState.ReservationSuccessful
				then
					default:updateNotification(notificationId, "launching")
					return
				end

				v13(notificationId, true)

				if
					state3 ~= experienceInviteState.Cancelled
					and state3 ~= experienceInviteState.ReservationFailed
				then
					Logger:warning("Invitee unexpected squad experience invite state: {}", state3)
				end
			end
		elseif state3 == experienceInviteState.Active then
			if v11 == experienceInviteVoteType.Invalid or v11 == experienceInviteVoteType.NoVote then
				if v9.model.spotsTaken >= v9.model.totalSpots then
					v7.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v10,
						experienceInviteId = v9.model.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvSlotsFull,
						toastType = SquadToastType.ExperienceInvite
					})

					default:updateNotification(notificationId, "slotsFull")
				end
			elseif v11 == experienceInviteVoteType.Accept then
				default:updateNotification(notificationId, "waiting")
			elseif v11 == experienceInviteVoteType.Decline or v11 == experienceInviteVoteType.Dismiss then
				v13(notificationId, true)
			end
		elseif
			state3 == experienceInviteState.Reserving
			or state3 == experienceInviteState.ReservationSuccessful
		then
			if v11 == experienceInviteVoteType.Invalid or v11 == experienceInviteVoteType.NoVote then
				v7.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v10,
					experienceInviteId = v9.model.experienceInviteId,
					toastAction = SquadToastActionsAndStates.ExpInvExpired,
					toastType = SquadToastType.ExperienceInvite
				})

				default:updateNotification(notificationId, "expired")
			elseif v11 == experienceInviteVoteType.Accept then
				default:updateNotification(notificationId, "waiting")
			elseif v11 == experienceInviteVoteType.Decline or v11 == experienceInviteVoteType.Dismiss then
				v13(notificationId, true)
			end
		else
			if state3 == experienceInviteState.Cancelled then
				default:updateNotification(notificationId, "cancelled")
				return
			end

			v13(notificationId, true)

			if state3 ~= experienceInviteState.ReservationFailed then
				Logger:warning("Inviter unexpected squad experience invite state: {}", state3)
			end
		end
	end, { v9, v10, v13, v6, v7.fireSquadAnalytics, v11 })

	RealtimeDelivery.useRealtimeNamespace("ExperienceInviteUpdate", function(p3)
		Logger:debug("Experience invite RTN received. Detail: {}", serializeTable(p3))

		if fFlagUseSignalsForSquadExperienceInvite then
			GetSquadExperienceInviteStore(false).currentExperienceInviteUpdated(p3)
		else
			v5(RoduxSquads.Actions.CurrentExperienceInviteUpdated(p3))
		end
	end, { v5 })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p3)
			if v9 and v9.notification.notificationId == p3.notificationId then
				if v11 ~= experienceInviteVoteType.Accept then
					v13(p3.notificationId, false)
				end

				if
					(not v9.model or v9.model.state == experienceInviteState.Active)
					and (v11 == experienceInviteVoteType.Invalid or v11 == experienceInviteVoteType.NoVote)
				then
					v7.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v10,
						experienceInviteId = v9.notification.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvDismiss,
						toastType = SquadToastType.ExperienceInvite
					})

					v15(
						v9.notification.experienceInviteId,
						experienceInviteVoteType.Dismiss,
						v9.notification.membershipEntityId
					)
				end
			end
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v9, v10, v13, v5, v7.fireSquadAnalytics, v11, v15 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if not data or v6 <= 0 then
				return
			end

			if data.notificationType == notificationTypeEnum.SquadExperienceInvitation then
				local jsonDecode = HttpService:JSONDecode(data.lifecycleData)

				if fFlagUseSignalsForSquadExperienceInvite then
					GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
						jsonDecode.experienceInviteId,
						jsonDecode.membershipEntityId,
						data.notificationId,
						jsonDecode.isInviter
					)
				else
					v5(RoduxSquads.Actions.CurrentExperienceInviteReceived(
						jsonDecode.experienceInviteId,
						jsonDecode.membershipEntityId,
						data.notificationId,
						jsonDecode.isInviter
					))
				end
			end
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v6 })

	React.useEffect(function()
		local connection = MessageBusService:Subscribe(messageId, function(data)
			if
				data.notificationType == notificationTypeEnum.SquadExperienceInvitation
				and data.userActionType == "timerElapsed"
			then
				if v9 then
					assert(v9, "Experience invite must exist to perform actions.")

					if
						(not v9.model or v9.model.state == experienceInviteState.Active)
						and (v11 == experienceInviteVoteType.Invalid or v11 == experienceInviteVoteType.NoVote)
					then
						default:updateNotification(data.notificationId, "expired")
					end
				else
					local jsonDecode = HttpService:JSONDecode(data.parameters)

					if fFlagUseSignalsForSquadExperienceInvite then
						GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
							jsonDecode.experienceInviteId,
							jsonDecode.membershipEntityId,
							data.notificationId,
							jsonDecode.isInviter
						)
					else
						v5(RoduxSquads.Actions.CurrentExperienceInviteReceived(
							jsonDecode.experienceInviteId,
							jsonDecode.membershipEntityId,
							data.notificationId,
							jsonDecode.isInviter
						))
					end

					v5(function()
						default:updateNotification(data.notificationId, "expired")
					end)
				end
			end
		end, false, true)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v9, v11, v15 })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadExperienceInvitation,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.visualItem
					and data.visualItem.actionEventParams
				then
					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)
					local v21 = {
						parentChannelId = v10,
						experienceInviteId = jsonDecode.experienceInviteId,
						toastType = SquadToastType.ExperienceInvite
					}

					if not v9 then
						if fFlagUseSignalsForSquadExperienceInvite then
							GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
								jsonDecode.experienceInviteId,
								jsonDecode.membershipEntityId,
								data.notificationData.id,
								jsonDecode.isInviter
							)
						else
							v5(RoduxSquads.Actions.CurrentExperienceInviteReceived(
								jsonDecode.experienceInviteId,
								jsonDecode.membershipEntityId,
								data.notificationData.id,
								jsonDecode.isInviter
							))
						end
					end

					if data.visualItem.eventName == "GroupUpSquadExperience" then
						v7.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v21, {
								toastAction = SquadToastActionsAndStates.ExpInvAccept
							})
						)

						v15(
							jsonDecode.experienceInviteId,
							experienceInviteVoteType.Accept,
							jsonDecode.membershipEntityId
						)
					elseif data.visualItem.eventName == "DismissSquadExperienceInvited" then
						v7.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v21, {
								toastAction = SquadToastActionsAndStates.ExpInvDecline
							})
						)

						v15(
							jsonDecode.experienceInviteId,
							experienceInviteVoteType.Decline,
							jsonDecode.membershipEntityId
						)
					elseif data.visualItem.eventName == "CancelSquadExperienceSpotsFilled" then
						v7.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v21, {
								toastAction = SquadToastActionsAndStates.ExpInvCancel
							})
						)

						v15(
							jsonDecode.experienceInviteId,
							experienceInviteVoteType.Cancel,
							jsonDecode.membershipEntityId
						)
					end
				end
			end
		)

		return function()
			callback()
		end
	end, { v9, v10, v5, v7.fireSquadAnalytics, v15 })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadExperienceInvitation,
			function(p3)
				local actionEventParams = p3
					and p3.state
					and p3.state.visualItems
					and p3.state.visualItems.button
					and p3.state.visualItems.button[1]
					and p3.state.visualItems.button[1].actionEventParams

				if actionEventParams then
					local experienceInviteId2 = HttpService:JSONDecode(actionEventParams).experienceInviteId

					v7.fireSquadAnalytics(EventNames.SquadExperienceInviteImpression, {
						experienceInviteId = experienceInviteId2,
						notificationId = p3.id,
						clientTimestamp = os.time()
					})
				end
			end
		)

		return function()
			callback()
		end
	end, { v7.fireSquadAnalytics })

	React.useEffect(function()
		local function fn3(p3)
			if p3.currentState == "invited" then
				soundManager:PlaySound(sounds.PartyToast.Name)
			end
		end

		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadExperienceInvitation,
			fn3
		)

		local callback2 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Update,
			notificationTypeEnum.SquadExperienceInvitation,
			fn3
		)

		return function()
			callback()
			callback2()
		end
	end, {})

	return nil
end
