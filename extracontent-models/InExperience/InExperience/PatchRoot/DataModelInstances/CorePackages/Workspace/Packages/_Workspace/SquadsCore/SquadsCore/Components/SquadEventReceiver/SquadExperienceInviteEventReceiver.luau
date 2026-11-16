local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local MessageBusService = game:GetService("MessageBusService")
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadToastType = require(SquadsCore.Enums.SquadToastType)
local Logger = require(SquadsCore.Logger)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local RoduxSquads = require(SquadsCore.RoduxSquads)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local useCurrentSquadParentChannelId = require(SquadsCore.Hooks.useCurrentSquadParentChannelId)
local GetSquadExperienceInviteStore = require(SquadsCore.Stores.GetSquadExperienceInviteStore)

local Cryo = require(parent.Cryo)
local ExperienceService = require(parent.ExperienceService)
local LocalStorage = require(parent.LocalStorage)
local LocalStorageKey = LocalStorage.Enums.LocalStorageKey
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local SharedFlags = require(parent.SharedFlags)
local SoundManager = require(parent.SoundManager)

local SocialExperiments = require(parent.SocialExperiments)
local SquadCoordinationExperienceJoinExperimentation = SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local LuauPolyfill = require(parent.LuauPolyfill)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local GameParams = ExperienceService.GameParams
local experienceService = ExperienceService.ExperienceService

local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval

local ExperienceInviteState = RoduxSquads.Enums.ExperienceInviteState
local ExperienceInviteVoteType = RoduxSquads.Enums.ExperienceInviteVoteType
local ExperienceInviteType = RoduxSquads.Enums.ExperienceInviteType

local Sounds = SoundManager.Sounds
local soundManager = SoundManager.SoundManager

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local EventNames = require(SquadsCore.Analytics.EventNames)

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum

local defineFastInt = game:DefineFastInt("SquadExperienceInvitePollingIntervalSeconds", 4)
local defineFastInt2 = game:DefineFastInt("SquadExperienceInviteTimeoutSeconds", 30)

local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled
local FFlagSquadLaunchExperienceMobileFix = SharedFlags.FFlagSquadLaunchExperienceMobileFix
local FFlagEnablePrivatePartyAcceptInvite = SharedFlags.FFlagEnablePrivatePartyAcceptInvite
local FFlagUseSignalsForSquadExperienceInvite = SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local messageId = MessageBusService:GetMessageId("ToastNotifications", "userActionOnToastNotification")

local function fn(p) -- 2 equivalent calls inferred from this helper
	if FFlagDebugSquadLogsEnabled then
		return HttpService:JSONEncode(p)
	end

	return if p.StatusCode then p.StatusCode else -1
end

return function(p): nil
	local v = useDispatch()
	local v2 = tonumber(useLocalUserId()) or 0

	local v3 = React.useContext(SquadExternalContractContext)

	local state, setState = React.useState("")
	React.useEffect(function()
		local success, result = pcall(function()
			return AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)
		end)

		if success then
			setState(result)
		end

		local itemWasSetConnection = AppStorageService.ItemWasSet:Connect(function(p2, p3)
			if p2 == LocalStorageKey.BrowserTrackerId then
				setState(p3)
			end
		end)
		return function()
			itemWasSetConnection:Disconnect()
		end
	end, { setState })

	local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
	local ref = React.useRef(false)
	local v4 = React.useCallback(function(p2)
		if p2.Squad and p2.Squad.Squad then
			return p2.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v5

	if FFlagUseSignalsForSquadExperienceInvite then
		v5 = useSignalState(GetSquadExperienceInviteStore(false).getCurrentExperienceInvite)
	else
		v5 = useSelector(v4)
	end

	local parentChannelId = useCurrentSquadParentChannelId()

	local model = v5 and v5.model
	local experienceInviteId = model and model.experienceInviteId or ""

	local state2 = model and model.state or ""

	local gameInstanceId = model and model.experienceDetail.gameInstanceId or ""

	local placeId = model and model.experienceDetail.placeId or 0

	local inviterId = model and model.inviterId or 0

	local v6, v7 = React.useMemo(function()
		if v5 and v5.model then
			for _, vote in ipairs(v5.model.votes) do
				if vote.userId == v2 then
					local v6

					if vote.voteIdentifier and vote.voteIdentifier ~= "" then
						v6 = vote.voteIdentifier ~= state
					else
						v6 = false
					end

					return vote.voteType, v6
				end
			end

			return ExperienceInviteVoteType.NoVote, false
		elseif v5 and v5.notification.isInviter then
			return ExperienceInviteVoteType.Accept, false
		else
			return ExperienceInviteVoteType.Invalid, false
		end
	end, { v5, v2, state })

	local v8 = React.useCallback(function(p2: string, flag: boolean)
		if flag then
			default:dismissNotification(p2)
		end

		if FFlagUseSignalsForSquadExperienceInvite then
			GetSquadExperienceInviteStore(false).currentExperienceInviteDismissed(p2)
		else
			v(RoduxSquads.Actions.CurrentExperienceInviteDismissed(p2))
		end

		ref.current = false
	end, { v })

	local v9 = React.useCallback(function(experienceInviteId2, membershipEntityId)
		return v(NetworkingSquads.GetExperienceInvite.API({
			experienceInviteId = experienceInviteId2,
			membershipEntityId = membershipEntityId
		})):catch(function(p2)
			Logger:warning(
				"Error getting experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}",
				fn(p2), -- inferred equivalent call
				experienceInviteId2,
				membershipEntityId
			)
		end)
	end, { v })
	local v10 = React.useCallback(function(experienceInviteId2, voteType, membershipEntityId)
		local v10 = {
			parentChannelId = parentChannelId,
			experienceInviteId = experienceInviteId2,
			voteType = voteType
		}

		return v(NetworkingSquads.VoteForExperienceInvite.API({
			experienceInviteId = experienceInviteId2,
			membershipEntityId = membershipEntityId,
			voteIdentifier = state,
			voteType = voteType
		})):andThen(function()
			v3.fireSquadAnalytics(EventNames.SquadVoteApiCall, Cryo.Dictionary.union(v10, {
				isSuccess = true
			}))
		end):catch(function(p2)
			local body = p2.Body
			local success, result = pcall(function()
				return HttpService:JSONDecode(body)
			end)
			local errorType

			if success then
				errorType = result.errorType
			end

			local fireSquadAnalytics = v3.fireSquadAnalytics
			local squadVoteApiCall = EventNames.SquadVoteApiCall
			local union = Cryo.Dictionary.union
			local errorType2

			if p2.StatusCode then
				errorType2 = tostring(p2.StatusCode)
			end

			fireSquadAnalytics(
				squadVoteApiCall,
				union(v10, { isSuccess = false, errorMessage = errorType, errorType = errorType2 })
			)

			Logger:warning(
				"Error voting for experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}, VoteType: {}",
				fn(p2), -- inferred equivalent call
				experienceInviteId2,
				membershipEntityId,
				voteType
			)
		end)
	end, { v, state })

	local useCallback = React.useCallback
	local function fn2(joinAttemptId)
		v3.fireSquadAnalytics(EventNames.SquadExperienceInviteStateChange, {
			experienceInviteId = experienceInviteId,
			invitationGameInstanceId = gameInstanceId,
			invitationPlaceId = placeId,
			inviterId = inviterId,
			inviteState = state2,
			parentChannelId = parentChannelId,
			joinAttemptId = joinAttemptId
		})
	end

	local v11

	if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v11 = v3.fireSquadAnalytics
	end

	local v12 = useCallback(fn2, {
		gameInstanceId,
		experienceInviteId,
		inviterId,
		placeId,
		state2,
		parentChannelId,
		v11
	})

	React.useEffect(function()
		local thread

		if v5 then
			thread = task.delay(defineFastInt2, function()
				v8(v5.notification.notificationId, true)
			end)
		else
			thread = nil
		end

		return function()
			if thread then
				task.cancel(thread)
			end
		end
	end, { v8, v5 })

	local useEffect = React.useEffect
	local function fn3()
		if not v5 or v6 ~= ExperienceInviteVoteType.Accept or ref.current then
			return
		end

		local model2 = v5.model
		local notification = v5.notification

		if not model2 or model2.state ~= ExperienceInviteState.ReservationSuccessful then
			return
		end

		local gameInstanceId2 = model2.experienceDetail.gameInstanceId
		local placeId2 = model2.experienceDetail.placeId

		if
			not FFlagEnablePrivatePartyAcceptInvite
			or v5.model.inviteType ~= ExperienceInviteType.PlayWithPartyInPrivatePartyServer
		then
			assert(gameInstanceId2, "Game instance id should exist.")
		end

		ref.current = true
		Logger:debug("Launching experience. GameInstanceId: {}, PlaceId: {}", gameInstanceId2, placeId2)

		local thread = task.delay(1, function()
			v8(notification.notificationId, true)

			if v3.squadLocation == SquadLocationEnum.InExperience and FFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			local v13 = v3.squadLocation == SquadLocationEnum.UniversalApp and "SquadExperienceInviteFromUA"
				or v3.squadLocation == SquadLocationEnum.InExperience and "SquadExperienceInviteFromInExp"
				or "SquadExperienceInvite"
			local joinAttemptId

			if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				joinAttemptId = HttpService:GenerateGUID(false)
				v12(joinAttemptId)
			end

			local v14 = GameParams.fromPlaceInstance(placeId2, gameInstanceId2)

			if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				v14.joinAttemptId = joinAttemptId
			end

			if
				FFlagEnablePrivatePartyAcceptInvite
				and v5.model.inviteType == ExperienceInviteType.PlayWithPartyInPrivatePartyServer
			then
				v14.isPrivateParty = true
			end

			experienceService:LaunchExperience(v14, v13, nil)
		end)
		return function()
			task.cancel(thread)
		end
	end
	local squadLocation = v3.squadLocation
	local v13

	if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v13 = v12
	end

	useEffect(fn3, { squadLocation, v5, v8, v6, v13 })

	React.useEffect(function()
		local v14

		if
			v5
			and (not v5.model or v5.model.state == ExperienceInviteState.Active or v5.model.state == ExperienceInviteState.Reserving)
		then
			v14 = setInterval(function()
				v9(v5.notification.experienceInviteId, v5.notification.membershipEntityId)
			end, defineFastInt * 1000)
		else
			v14 = nil
		end

		return function()
			if v14 then
				clearInterval(v14)
			end
		end
	end, { v5, v9 })

	React.useEffect(function()
		if v5 and (p.currentSquadId ~= v5.notification.membershipEntityId or v7) then
			v8(v5.notification.notificationId, true)
		end
	end, { v5, v8, p.currentSquadId, v7 })
	React.useEffect(function()
		if ExperienceInviteState[state2] then
			if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				if ExperienceInviteState[state2] ~= ExperienceInviteState.ReservationSuccessful then
					v12()
				end
			else
				v12()
			end
		end
	end, { state2, v12 })

	React.useEffect(function()
		if not (v5 and v5.model) then
			return
		end

		Logger:debug("Current experience invite updated: {}", serializeTable(v5.model))

		local notificationId = v5.notification.notificationId
		local state3 = v5.model.state

		if v5.model.inviterId == v2 then
			if state3 == ExperienceInviteState.Active then
				if v5.model.spotsTaken > 1 then
					default:updateNotification(notificationId, v5.model.spotsTaken .. "SpotsFilled")
				end
			else
				if
					state3 == ExperienceInviteState.Reserving
					or state3 == ExperienceInviteState.ReservationSuccessful
				then
					default:updateNotification(notificationId, "launching")
					return
				end

				v8(notificationId, true)

				if state3 ~= ExperienceInviteState.Cancelled and state3 ~= ExperienceInviteState.ReservationFailed then
					Logger:warning("Invitee unexpected squad experience invite state: {}", state3)
				end
			end
		elseif state3 == ExperienceInviteState.Active then
			if v6 == ExperienceInviteVoteType.Invalid or v6 == ExperienceInviteVoteType.NoVote then
				if v5.model.spotsTaken >= v5.model.totalSpots then
					v3.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = parentChannelId,
						experienceInviteId = v5.model.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvSlotsFull,
						toastType = SquadToastType.ExperienceInvite
					})

					default:updateNotification(notificationId, "slotsFull")
				end
			elseif v6 == ExperienceInviteVoteType.Accept then
				default:updateNotification(notificationId, "waiting")
			elseif v6 == ExperienceInviteVoteType.Decline or v6 == ExperienceInviteVoteType.Dismiss then
				v8(notificationId, true)
			end
		elseif state3 == ExperienceInviteState.Reserving or state3 == ExperienceInviteState.ReservationSuccessful then
			if v6 == ExperienceInviteVoteType.Invalid or v6 == ExperienceInviteVoteType.NoVote then
				v3.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = parentChannelId,
					experienceInviteId = v5.model.experienceInviteId,
					toastAction = SquadToastActionsAndStates.ExpInvExpired,
					toastType = SquadToastType.ExperienceInvite
				})

				default:updateNotification(notificationId, "expired")
			elseif v6 == ExperienceInviteVoteType.Accept then
				default:updateNotification(notificationId, "waiting")
			elseif v6 == ExperienceInviteVoteType.Decline or v6 == ExperienceInviteVoteType.Dismiss then
				v8(notificationId, true)
			end
		else
			if state3 == ExperienceInviteState.Cancelled then
				default:updateNotification(notificationId, "cancelled")
				return
			end

			v8(notificationId, true)

			if state3 ~= ExperienceInviteState.ReservationFailed then
				Logger:warning("Inviter unexpected squad experience invite state: {}", state3)
			end
		end
	end, { v5, parentChannelId, v8, v2, v3.fireSquadAnalytics, v6 })

	RealtimeDelivery.useRealtimeNamespace("ExperienceInviteUpdate", function(p2)
		Logger:debug("Experience invite RTN received. Detail: {}", serializeTable(p2))

		if FFlagUseSignalsForSquadExperienceInvite then
			GetSquadExperienceInviteStore(false).currentExperienceInviteUpdated(p2)
		else
			v(RoduxSquads.Actions.CurrentExperienceInviteUpdated(p2))
		end
	end, { v })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p2)
			if v5 and v5.notification.notificationId == p2.notificationId then
				if v6 ~= ExperienceInviteVoteType.Accept then
					v8(p2.notificationId, false)
				end

				if
					(not v5.model or v5.model.state == ExperienceInviteState.Active)
					and (v6 == ExperienceInviteVoteType.Invalid or v6 == ExperienceInviteVoteType.NoVote)
				then
					v3.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = parentChannelId,
						experienceInviteId = v5.notification.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvDismiss,
						toastType = SquadToastType.ExperienceInvite
					})

					v10(
						v5.notification.experienceInviteId,
						ExperienceInviteVoteType.Dismiss,
						v5.notification.membershipEntityId
					)
				end
			end
		end)

		return function()
			if connection then
				connection:Disconnect()
			end
		end
	end, { v5, parentChannelId, v8, v, v3.fireSquadAnalytics, v6, v10 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if not data or v2 <= 0 then
				return
			end

			if data.notificationType == NotificationTypeEnum.SquadExperienceInvitation then
				local jsonDecode = HttpService:JSONDecode(data.lifecycleData)

				if FFlagUseSignalsForSquadExperienceInvite then
					GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
						jsonDecode.experienceInviteId,
						jsonDecode.membershipEntityId,
						data.notificationId,
						jsonDecode.isInviter
					)
				else
					v(RoduxSquads.Actions.CurrentExperienceInviteReceived(
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
	end, { v2 })

	React.useEffect(function()
		local connection = MessageBusService:Subscribe(messageId, function(data)
			if
				data.notificationType == NotificationTypeEnum.SquadExperienceInvitation
				and data.userActionType == "timerElapsed"
			then
				if v5 then
					assert(v5, "Experience invite must exist to perform actions.")

					if
						(not v5.model or v5.model.state == ExperienceInviteState.Active)
						and (v6 == ExperienceInviteVoteType.Invalid or v6 == ExperienceInviteVoteType.NoVote)
					then
						default:updateNotification(data.notificationId, "expired")
					end
				else
					local jsonDecode = HttpService:JSONDecode(data.parameters)

					if FFlagUseSignalsForSquadExperienceInvite then
						GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
							jsonDecode.experienceInviteId,
							jsonDecode.membershipEntityId,
							data.notificationId,
							jsonDecode.isInviter
						)
					else
						v(RoduxSquads.Actions.CurrentExperienceInviteReceived(
							jsonDecode.experienceInviteId,
							jsonDecode.membershipEntityId,
							data.notificationId,
							jsonDecode.isInviter
						))
					end

					v(function()
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
	end, { v5, v6, v10 })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadExperienceInvitation,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.visualItem
					and data.visualItem.actionEventParams
				then
					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)
					local v14 = {
						parentChannelId = parentChannelId,
						experienceInviteId = jsonDecode.experienceInviteId,
						toastType = SquadToastType.ExperienceInvite
					}

					if not v5 then
						if FFlagUseSignalsForSquadExperienceInvite then
							GetSquadExperienceInviteStore(false).currentExperienceInviteReceived(
								jsonDecode.experienceInviteId,
								jsonDecode.membershipEntityId,
								data.notificationData.id,
								jsonDecode.isInviter
							)
						else
							v(RoduxSquads.Actions.CurrentExperienceInviteReceived(
								jsonDecode.experienceInviteId,
								jsonDecode.membershipEntityId,
								data.notificationData.id,
								jsonDecode.isInviter
							))
						end
					end

					if data.visualItem.eventName == "GroupUpSquadExperience" then
						v3.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v14, {
								toastAction = SquadToastActionsAndStates.ExpInvAccept
							})
						)

						v10(
							jsonDecode.experienceInviteId,
							ExperienceInviteVoteType.Accept,
							jsonDecode.membershipEntityId
						)
					elseif data.visualItem.eventName == "DismissSquadExperienceInvited" then
						v3.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v14, {
								toastAction = SquadToastActionsAndStates.ExpInvDecline
							})
						)

						v10(
							jsonDecode.experienceInviteId,
							ExperienceInviteVoteType.Decline,
							jsonDecode.membershipEntityId
						)
					elseif data.visualItem.eventName == "CancelSquadExperienceSpotsFilled" then
						v3.fireSquadAnalytics(
							EventNames.SquadToastActions,
							Cryo.Dictionary.union(v14, {
								toastAction = SquadToastActionsAndStates.ExpInvCancel
							})
						)

						v10(
							jsonDecode.experienceInviteId,
							ExperienceInviteVoteType.Cancel,
							jsonDecode.membershipEntityId
						)
					end
				end
			end
		)

		return function()
			callback()
		end
	end, { v5, parentChannelId, v, v3.fireSquadAnalytics, v10 })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadExperienceInvitation,
			function(p2)
				local actionEventParams = p2
					and p2.state
					and p2.state.visualItems
					and p2.state.visualItems.button
					and p2.state.visualItems.button[1]
					and p2.state.visualItems.button[1].actionEventParams

				if actionEventParams then
					local experienceInviteId2 = HttpService:JSONDecode(actionEventParams).experienceInviteId

					v3.fireSquadAnalytics(EventNames.SquadExperienceInviteImpression, {
						experienceInviteId = experienceInviteId2,
						notificationId = p2.id,
						clientTimestamp = os.time()
					})
				end
			end
		)

		return function()
			callback()
		end
	end, { v3.fireSquadAnalytics })

	React.useEffect(function()
		local function fn4(p2)
			if p2.currentState == "invited" then
				soundManager:PlaySound(Sounds.PartyToast.Name)
			end
		end

		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadExperienceInvitation,
			fn4
		)

		local callback2 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Update,
			NotificationTypeEnum.SquadExperienceInvitation,
			fn4
		)

		return function()
			callback()
			callback2()
		end
	end, {})

	return nil
end
