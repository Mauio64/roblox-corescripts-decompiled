local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
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
local Cryo = require(SquadsCoreParent.Cryo)
local ExperienceService = require(SquadsCoreParent.ExperienceService)
local LocalStorageKey = require(SquadsCoreParent.LocalStorage).Enums.LocalStorageKey
local React = require(SquadsCoreParent.React)
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local SoundManager = require(SquadsCoreParent.SoundManager)
local SquadCoordinationExperienceJoinExperimentation = require(SquadsCoreParent.SocialExperiments).SquadCoordinationExperienceJoinExperimentation
local ToastNotification = require(SquadsCoreParent.ToastNotification)
local ToastNotificationsProtocol = require(SquadsCoreParent.ToastNotificationsProtocol)
local LuauPolyfill = require(SquadsCoreParent.LuauPolyfill)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local useSelector = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useSelector
local GameParams = ExperienceService.GameParams
local ExperienceService2 = ExperienceService.ExperienceService
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local ExperienceInviteState = RoduxSquads.Enums.ExperienceInviteState
local ExperienceInviteVoteType = RoduxSquads.Enums.ExperienceInviteVoteType
local ExperienceInviteType = RoduxSquads.Enums.ExperienceInviteType
local Sounds = SoundManager.Sounds
local SoundManager2 = SoundManager.SoundManager
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local EventNames = require(SquadsCore.Analytics.EventNames)
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local v41 = game:DefineFastInt("SquadExperienceInvitePollingIntervalSeconds", 4)
local v42 = game:DefineFastInt("SquadExperienceInviteTimeoutSeconds", 30)
local FFlagDebugSquadLogsEnabled = SharedFlags.FFlagDebugSquadLogsEnabled
local FFlagSquadLaunchExperienceMobileFix = SharedFlags.FFlagSquadLaunchExperienceMobileFix
local FFlagEnablePrivatePartyAcceptInvite = SharedFlags.FFlagEnablePrivatePartyAcceptInvite
local MessageId = MessageBusService:GetMessageId("ToastNotifications", "userActionOnToastNotification")

return function(t1: {[any]: any}) -- line: 81
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), AppStorageService (copy), LocalStorageKey (copy), ToastNotificationsProtocol (copy), useSelector (copy), useCurrentSquadParentChannelId (copy), ExperienceInviteVoteType (copy), RoduxSquads (copy), NetworkingSquads (copy), Logger (copy), FFlagDebugSquadLogsEnabled (copy), HttpService (copy), EventNames (copy), Cryo (copy), SquadCoordinationExperienceJoinExperimentation (copy), v42 (copy), ExperienceInviteState (copy), FFlagEnablePrivatePartyAcceptInvite (copy), ExperienceInviteType (copy), SquadLocationEnum (copy), FFlagSquadLaunchExperienceMobileFix (copy), GameParams (copy), ExperienceService2 (copy), v41 (copy), setInterval (copy), clearInterval (copy), serializeTable (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), RealtimeDelivery (copy), NotificationTypeEnum (copy), MessageBusService (copy), MessageId (copy), LifecycleEvents (copy), SoundManager2 (copy), Sounds (copy)
	local v49 = useDispatch()
	local v50 = tonumber(useLocalUserId()) or 0
	local v51 = React.useContext(SquadExternalContractContext)
	local v52, v53 = React.useState("")

	React.useEffect(function() -- line: 89
		-- upvalues: AppStorageService (copy), LocalStorageKey (copy), v53 (copy)
		local ok, result = pcall(function() -- line: 91
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
			return AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)
		end)

		if ok then
			v53(result)
		end

		local connection = AppStorageService.ItemWasSet:Connect(function(p1, p2) -- line: 98
			-- upvalues: LocalStorageKey (copy), v53 (copy)
			if p1 == LocalStorageKey.BrowserTrackerId then
				v53(p2)
			end
		end)

		return function() -- line: 103
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v53 })

	local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
	local v55 = React.useRef(false)
	local v56 = React.useCallback(function(p3) -- line: 111
		if p3.Squad and p3.Squad.Squad then
			return p3.Squad.Squad.currentExperienceInvite
		end

		return nil
	end, {})
	local v57 = useSelector(v56)
	local v58 = useCurrentSquadParentChannelId()
	local v59 = v57 and v57.model
	local v60 = v59 and v59.experienceInviteId or ""
	local v61 = v59 and v59.state or ""
	local v62 = v59 and v59.experienceDetail.gameInstanceId or ""
	local v63 = v59 and v59.experienceDetail.placeId or 0
	local v64 = v59 and v59.inviterId or 0
	local v65, v66 = React.useMemo(function() -- line: 131
		-- upvalues: v57 (copy), ExperienceInviteVoteType (copy), v50 (copy), v52 (copy)
		if not v57 or not v57.model then
			if v57 and v57.notification.isInviter then
				return ExperienceInviteVoteType.Accept, false
			end

			return ExperienceInviteVoteType.Invalid, false
		end

		for _, v in ipairs(v57.model.votes) do
			if v.userId == v50 then
				local v77 = false

				if v.voteIdentifier and v.voteIdentifier ~= "" then
					v77 = v.voteIdentifier ~= v52
				end

				return v.voteType, v77
			end
		end

		return ExperienceInviteVoteType.NoVote, false
	end, {
		v57,
		v50,
		v52
	})
	local v67 = React.useCallback(function(s1: string, b1: boolean) -- line: 158
		-- upvalues: default (copy), v49 (copy), RoduxSquads (copy), v55 (copy)
		if b1 then
			default:dismissNotification(s1)
		end

		v49(RoduxSquads.Actions.CurrentExperienceInviteDismissed(s1))
		v55.current = false
	end, { v49 })
	local v68 = React.useCallback(function(p4, p5) -- line: 169
		-- upvalues: v49 (copy), NetworkingSquads (copy), Logger (copy), FFlagDebugSquadLogsEnabled (copy), HttpService (copy)
		return v49(NetworkingSquads.GetExperienceInvite.API({
			experienceInviteId = p4,
			membershipEntityId = p5
		})):catch(function(p6) -- line: 173
			-- upvalues: Logger (copy), FFlagDebugSquadLogsEnabled (copy), HttpService (copy), p4 (copy), p5 (copy)
			Logger:warning("Error getting experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}", if not FFlagDebugSquadLogsEnabled then not p6.StatusCode and -1 or p6.StatusCode else HttpService:JSONEncode(p6), p4, p5)
		end)
	end, { v49 })
	local v69 = React.useCallback(function(p7, p8, p9) -- line: 182
		-- upvalues: v58 (copy), v49 (copy), NetworkingSquads (copy), v52 (copy), v51 (copy), EventNames (copy), Cryo (copy), HttpService (copy), Logger (copy), FFlagDebugSquadLogsEnabled (copy)
		local t2 = {
			parentChannelId = v58,
			experienceInviteId = p7,
			voteType = p8
		}

		return v49(NetworkingSquads.VoteForExperienceInvite.API({
			experienceInviteId = p7,
			membershipEntityId = p9,
			voteIdentifier = v52,
			voteType = p8
		})):andThen(function() -- line: 195
			-- upvalues: v51 (copy), EventNames (copy), Cryo (copy), t2 (copy)
			v51.fireSquadAnalytics(EventNames.SquadVoteApiCall, Cryo.Dictionary.union(t2, {
				isSuccess = true
			}))
		end):catch(function(p10) -- line: 203
			-- upvalues: HttpService (copy), v51 (copy), EventNames (copy), Cryo (copy), t2 (copy), Logger (copy), FFlagDebugSquadLogsEnabled (copy), p7 (copy), p9 (copy), p8 (copy)
			local Body = p10.Body
			local ok, result = pcall(function() -- line: 205
				-- upvalues: HttpService (copy), Body (copy)
				return HttpService:JSONDecode(Body)
			end)
			local v113 = if not ok then nil else result.errorType

			v51.fireSquadAnalytics(EventNames.SquadVoteApiCall, Cryo.Dictionary.union(t2, {
				isSuccess = false,
				errorMessage = v113,
				errorType = if not p10.StatusCode then nil else tostring(p10.StatusCode)
			}))
			Logger:warning("Error voting for experience invite. Error: {}, ExperienceInviteId: {}, MembershipEntityId: {}, VoteType: {}", if not FFlagDebugSquadLogsEnabled then not p10.StatusCode and -1 or p10.StatusCode else HttpService:JSONEncode(p10), p7, p9, p8)
		end)
	end, {
		v49,
		v52
	})
	local v70 = React.useCallback(function(p11) -- line: 230
		-- upvalues: v51 (copy), EventNames (copy), v60 (copy), v62 (copy), v63 (copy), v64 (copy), v61 (copy), v58 (copy)
		v51.fireSquadAnalytics(EventNames.SquadExperienceInviteStateChange, {
			experienceInviteId = v60,
			invitationGameInstanceId = v62,
			invitationPlaceId = v63,
			inviterId = v64,
			inviteState = v61,
			parentChannelId = v58,
			joinAttemptId = p11
		})
	end, {
		v62,
		v60,
		v64,
		v63,
		v61,
		v58,
		if not SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then nil else v51.fireSquadAnalytics
	})

	React.useEffect(function() -- line: 255
		-- upvalues: v57 (copy), v42 (copy), v67 (copy)
		local thread = nil

		if v57 then
			thread = task.delay(v42, function() -- line: 258
				-- upvalues: v67 (copy), v57 (copy)
				v67(v57.notification.notificationId, true)
			end)
		end

		return function() -- line: 262
			-- upvalues: thread (ref)
			if thread then
				task.cancel(thread)
			end
		end
	end, {
		v67,
		v57
	})
	React.useEffect(function() -- line: 270
		-- upvalues: v57 (copy), v65 (copy), ExperienceInviteVoteType (copy), v55 (copy), ExperienceInviteState (copy), FFlagEnablePrivatePartyAcceptInvite (copy), ExperienceInviteType (copy), Logger (copy), v67 (copy), v51 (copy), SquadLocationEnum (copy), FFlagSquadLaunchExperienceMobileFix (copy), SquadCoordinationExperienceJoinExperimentation (copy), HttpService (copy), v70 (copy), GameParams (copy), ExperienceService2 (copy)
		if not v57 or (v65 ~= ExperienceInviteVoteType.Accept or v55.current) then
			return
		end

		local model = v57.model
		local notification = v57.notification

		if model and model.state == ExperienceInviteState.ReservationSuccessful then
			local gameInstanceId = model.experienceDetail.gameInstanceId
			local placeId = model.experienceDetail.placeId

			if not FFlagEnablePrivatePartyAcceptInvite or v57.model.inviteType ~= ExperienceInviteType.PlayWithPartyInPrivatePartyServer then
				assert(gameInstanceId, "Game instance id should exist.")
			end

			v55.current = true
			Logger:debug("Launching experience. GameInstanceId: {}, PlaceId: {}", gameInstanceId, placeId)

			local thread = task.delay(1, function() -- line: 297
				-- upvalues: v67 (copy), notification (copy), v51 (copy), SquadLocationEnum (copy), FFlagSquadLaunchExperienceMobileFix (copy), SquadCoordinationExperienceJoinExperimentation (copy), HttpService (copy), v70 (copy), GameParams (copy), placeId (copy), gameInstanceId (copy), FFlagEnablePrivatePartyAcceptInvite (copy), v57 (copy), ExperienceInviteType (copy), ExperienceService2 (copy)
				v67(notification.notificationId, true)

				if v51.squadLocation == SquadLocationEnum.InExperience and FFlagSquadLaunchExperienceMobileFix then
					game:Shutdown()
				end

				local s2 = "SquadExperienceInvite"

				if v51.squadLocation == SquadLocationEnum.UniversalApp then
					s2 = "SquadExperienceInviteFromUA"
				elseif v51.squadLocation == SquadLocationEnum.InExperience then
					s2 = "SquadExperienceInviteFromInExp"
				end

				local guid = nil

				if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
					guid = HttpService:GenerateGUID(false)
					v70(guid)
				end

				local v116 = GameParams.fromPlaceInstance(placeId, gameInstanceId)

				if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
					v116.joinAttemptId = guid
				end

				if FFlagEnablePrivatePartyAcceptInvite and v57.model.inviteType == ExperienceInviteType.PlayWithPartyInPrivatePartyServer then
					v116.isPrivateParty = true
				end

				ExperienceService2:LaunchExperience(v116, s2, nil)
			end)

			return function() -- line: 332
				-- upvalues: thread (copy)
				task.cancel(thread)
			end
		end
	end, {
		v51.squadLocation,
		v57,
		v67,
		v65,
		if not SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then nil else v70
	})
	React.useEffect(function() -- line: 348
		-- upvalues: v41 (copy), v57 (copy), ExperienceInviteState (copy), setInterval (copy), v68 (copy), clearInterval (copy)
		local v93 = v41
		local u94 = nil

		if v57 and (not v57.model or v57.model.state == ExperienceInviteState.Active or v57.model.state == ExperienceInviteState.Reserving) then
			u94 = setInterval(function() -- line: 359
				-- upvalues: v68 (copy), v57 (copy)
				v68(v57.notification.experienceInviteId, v57.notification.membershipEntityId)
			end, v93 * 1000)
		end

		return function() -- line: 367
			-- upvalues: u94 (ref), clearInterval (copy)
			if u94 then
				clearInterval(u94)
			end
		end
	end, {
		v57,
		v68
	})
	React.useEffect(function() -- line: 376
		-- upvalues: v57 (copy), t1 (copy), v66 (copy), v67 (copy)
		if v57 and (t1.currentSquadId ~= v57.notification.membershipEntityId or v66) then
			v67(v57.notification.notificationId, true)
		end
	end, {
		v57,
		v67,
		t1.currentSquadId,
		v66
	})
	React.useEffect(function() -- line: 386
		-- upvalues: ExperienceInviteState (copy), v61 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v70 (copy)
		if ExperienceInviteState[v61] then
			if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
				if ExperienceInviteState[v61] ~= ExperienceInviteState.ReservationSuccessful then
					v70()

					return
				end
			else
				v70()
			end
		end
	end, {
		v61,
		v70
	})
	React.useEffect(function() -- line: 404
		-- upvalues: v57 (copy), Logger (copy), serializeTable (copy), v50 (copy), ExperienceInviteState (copy), default (copy), v67 (copy), v65 (copy), ExperienceInviteVoteType (copy), v51 (copy), EventNames (copy), v58 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy)
		if not v57 or not v57.model then
			return
		end

		Logger:debug("Current experience invite updated: {}", serializeTable(v57.model))

		local notificationId = v57.notification.notificationId
		local state = v57.model.state

		if v57.model.inviterId == v50 then
			if state == ExperienceInviteState.Active then
				if v57.model.spotsTaken > 1 then
					default:updateNotification(notificationId, v57.model.spotsTaken .. "SpotsFilled")

					return
				end
			else
				if state == ExperienceInviteState.Reserving or state == ExperienceInviteState.ReservationSuccessful then
					default:updateNotification(notificationId, "launching")

					return
				end

				v67(notificationId, true)

				if state ~= ExperienceInviteState.Cancelled and state ~= ExperienceInviteState.ReservationFailed then
					Logger:warning("Invitee unexpected squad experience invite state: {}", state)

					return
				end
			end
		elseif state == ExperienceInviteState.Active then
			if v65 == ExperienceInviteVoteType.Invalid or v65 == ExperienceInviteVoteType.NoVote then
				if v57.model.spotsTaken >= v57.model.totalSpots then
					v51.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v58,
						experienceInviteId = v57.model.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvSlotsFull,
						toastType = SquadToastType.ExperienceInvite
					})
					default:updateNotification(notificationId, "slotsFull")

					return
				end
			else
				if v65 == ExperienceInviteVoteType.Accept then
					default:updateNotification(notificationId, "waiting")

					return
				end

				if v65 == ExperienceInviteVoteType.Decline or v65 == ExperienceInviteVoteType.Dismiss then
					v67(notificationId, true)

					return
				end
			end
		elseif state == ExperienceInviteState.Reserving or state == ExperienceInviteState.ReservationSuccessful then
			if v65 == ExperienceInviteVoteType.Invalid or v65 == ExperienceInviteVoteType.NoVote then
				v51.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v58,
					experienceInviteId = v57.model.experienceInviteId,
					toastAction = SquadToastActionsAndStates.ExpInvExpired,
					toastType = SquadToastType.ExperienceInvite
				})
				default:updateNotification(notificationId, "expired")

				return
			end

			if v65 == ExperienceInviteVoteType.Accept then
				default:updateNotification(notificationId, "waiting")

				return
			end

			if v65 == ExperienceInviteVoteType.Decline or v65 == ExperienceInviteVoteType.Dismiss then
				v67(notificationId, true)

				return
			end
		else
			if state == ExperienceInviteState.Cancelled then
				default:updateNotification(notificationId, "cancelled")

				return
			end

			v67(notificationId, true)

			if state ~= ExperienceInviteState.ReservationFailed then
				Logger:warning("Inviter unexpected squad experience invite state: {}", state)
			end
		end
	end, {
		v57,
		v58,
		v67,
		v50,
		v51.fireSquadAnalytics,
		v65
	})
	RealtimeDelivery.useRealtimeNamespace("ExperienceInviteUpdate", function(p12) -- line: 496
		-- upvalues: Logger (copy), serializeTable (copy), v49 (copy), RoduxSquads (copy)
		Logger:debug("Experience invite RTN received. Detail: {}", serializeTable(p12))
		v49(RoduxSquads.Actions.CurrentExperienceInviteUpdated(p12))
	end, { v49 })
	React.useEffect(function() -- line: 508
		-- upvalues: default (copy), v57 (copy), v65 (copy), ExperienceInviteVoteType (copy), v67 (copy), ExperienceInviteState (copy), v51 (copy), EventNames (copy), v58 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v69 (copy)
		local v98 = default:listenToDismissNotification(function(p13) -- line: 510
			-- upvalues: v57 (copy), v65 (copy), ExperienceInviteVoteType (copy), v67 (copy), ExperienceInviteState (copy), v51 (copy), EventNames (copy), v58 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v69 (copy)
			if v57 and v57.notification.notificationId == p13.notificationId then
				if v65 ~= ExperienceInviteVoteType.Accept then
					v67(p13.notificationId, false)
				end

				if (not v57.model or v57.model.state == ExperienceInviteState.Active) and (v65 == ExperienceInviteVoteType.Invalid or v65 == ExperienceInviteVoteType.NoVote) then
					v51.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v58,
						experienceInviteId = v57.notification.experienceInviteId,
						toastAction = SquadToastActionsAndStates.ExpInvDismiss,
						toastType = SquadToastType.ExperienceInvite
					})
					v69(v57.notification.experienceInviteId, ExperienceInviteVoteType.Dismiss, v57.notification.membershipEntityId)
				end
			end
		end)

		return function() -- line: 551
			-- upvalues: v98 (copy)
			if v98 then
				v98:Disconnect()
			end
		end
	end, {
		v57,
		v58,
		v67,
		v49,
		v51.fireSquadAnalytics,
		v65,
		v69
	})
	React.useEffect(function() -- line: 567
		-- upvalues: default (copy), v50 (copy), NotificationTypeEnum (copy), HttpService (copy), v49 (copy), RoduxSquads (copy)
		local v99 = default:listenToDisplayNotification(function(p14) -- line: 569
			-- upvalues: v50 (copy), NotificationTypeEnum (copy), HttpService (copy), v49 (copy), RoduxSquads (copy)
			if not p14 then
				return
			end

			if v50 <= 0 then
				return
			end

			if p14.notificationType == NotificationTypeEnum.SquadExperienceInvitation then
				local data = HttpService:JSONDecode(p14.lifecycleData)

				v49(RoduxSquads.Actions.CurrentExperienceInviteReceived(data.experienceInviteId, data.membershipEntityId, p14.notificationId, data.isInviter))
			end
		end)

		return function() -- line: 590
			-- upvalues: v99 (copy)
			if v99 then
				v99:Disconnect()
			end
		end
	end, { v50 })
	React.useEffect(function() -- line: 599
		-- upvalues: MessageBusService (copy), MessageId (copy), NotificationTypeEnum (copy), v57 (copy), HttpService (copy), v49 (copy), RoduxSquads (copy), default (copy), ExperienceInviteState (copy), v65 (copy), ExperienceInviteVoteType (copy)
		local v100 = MessageBusService:Subscribe(MessageId, function(p15) -- line: 602
			-- upvalues: NotificationTypeEnum (copy), v57 (copy), HttpService (copy), v49 (copy), RoduxSquads (copy), default (copy), ExperienceInviteState (copy), v65 (copy), ExperienceInviteVoteType (copy)
			if p15.notificationType == NotificationTypeEnum.SquadExperienceInvitation and p15.userActionType == "timerElapsed" then
				if not v57 then
					local data = HttpService:JSONDecode(p15.parameters)

					v49(RoduxSquads.Actions.CurrentExperienceInviteReceived(data.experienceInviteId, data.membershipEntityId, p15.notificationId, data.isInviter))
					v49(function() -- line: 617
						-- upvalues: default (copy), p15 (copy)
						default:updateNotification(p15.notificationId, "expired")
					end)

					return
				end

				assert(v57, "Experience invite must exist to perform actions.")

				if (not v57.model or v57.model.state == ExperienceInviteState.Active) and (v65 == ExperienceInviteVoteType.Invalid or v65 == ExperienceInviteVoteType.NoVote) then
					default:updateNotification(p15.notificationId, "expired")
				end
			end
		end, false, true)

		return function() -- line: 647
			-- upvalues: v100 (copy)
			if v100 then
				v100:Disconnect()
			end
		end
	end, {
		v57,
		v65,
		v69
	})
	React.useEffect(function() -- line: 655
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), v58 (copy), SquadToastType (copy), v57 (copy), v49 (copy), RoduxSquads (copy), v51 (copy), EventNames (copy), Cryo (copy), SquadToastActionsAndStates (copy), v69 (copy), ExperienceInviteVoteType (copy)
		local v101 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadExperienceInvitation, function(p16) -- line: 659
			-- upvalues: HttpService (copy), v58 (copy), SquadToastType (copy), v57 (copy), v49 (copy), RoduxSquads (copy), v51 (copy), EventNames (copy), Cryo (copy), SquadToastActionsAndStates (copy), v69 (copy), ExperienceInviteVoteType (copy)
			if p16 and (p16.userActionType == "click" and p16.visualItem and p16.visualItem.actionEventParams) then
				local data = HttpService:JSONDecode(p16.visualItem.actionEventParams)
				local t3 = {
					parentChannelId = v58,
					experienceInviteId = data.experienceInviteId,
					toastType = SquadToastType.ExperienceInvite
				}

				if not v57 then
					v49(RoduxSquads.Actions.CurrentExperienceInviteReceived(data.experienceInviteId, data.membershipEntityId, p16.notificationData.id, data.isInviter))
				end

				if p16.visualItem.eventName == "GroupUpSquadExperience" then
					v51.fireSquadAnalytics(EventNames.SquadToastActions, Cryo.Dictionary.union(t3, {
						toastAction = SquadToastActionsAndStates.ExpInvAccept
					}))
					v69(data.experienceInviteId, ExperienceInviteVoteType.Accept, data.membershipEntityId)

					return
				end

				if p16.visualItem.eventName == "DismissSquadExperienceInvited" then
					v51.fireSquadAnalytics(EventNames.SquadToastActions, Cryo.Dictionary.union(t3, {
						toastAction = SquadToastActionsAndStates.ExpInvDecline
					}))
					v69(data.experienceInviteId, ExperienceInviteVoteType.Decline, data.membershipEntityId)

					return
				end

				if p16.visualItem.eventName == "CancelSquadExperienceSpotsFilled" then
					v51.fireSquadAnalytics(EventNames.SquadToastActions, Cryo.Dictionary.union(t3, {
						toastAction = SquadToastActionsAndStates.ExpInvCancel
					}))
					v69(data.experienceInviteId, ExperienceInviteVoteType.Cancel, data.membershipEntityId)
				end
			end
		end)

		return function() -- line: 727
			-- upvalues: v101 (copy)
			v101()
		end
	end, {
		v57,
		v58,
		v49,
		v51.fireSquadAnalytics,
		v69
	})
	React.useEffect(function() -- line: 739
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), v51 (copy), EventNames (copy)
		local v102 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadExperienceInvitation, function(p17) -- line: 743
			-- upvalues: HttpService (copy), v51 (copy), EventNames (copy)
			local v126 = p17 and (p17.state and (p17.state.visualItems and (p17.state.visualItems.button and (p17.state.visualItems.button[1] and p17.state.visualItems.button[1].actionEventParams))))

			if v126 then
				local experienceInviteId = HttpService:JSONDecode(v126).experienceInviteId

				v51.fireSquadAnalytics(EventNames.SquadExperienceInviteImpression, {
					experienceInviteId = experienceInviteId,
					notificationId = p17.id,
					clientTimestamp = os.time()
				})
			end
		end)

		return function() -- line: 763
			-- upvalues: v102 (copy)
			v102()
		end
	end, { v51.fireSquadAnalytics })
	React.useEffect(function() -- line: 769
		-- upvalues: SoundManager2 (copy), Sounds (copy), LifecycleEvents (copy), NotificationTypeEnum (copy)
		local function v103(p18) -- line: 770
			-- upvalues: SoundManager2 (copy), Sounds (copy)
			if p18.currentState == "invited" then
				SoundManager2:PlaySound(Sounds.PartyToast.Name)
			end
		end

		local v104 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadExperienceInvitation, v103)
		local v105 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Update, NotificationTypeEnum.SquadExperienceInvitation, v103)

		return function() -- line: 788
			-- upvalues: v104 (copy), v105 (copy)
			v104()
			v105()
		end
	end, {})

	return nil
end
