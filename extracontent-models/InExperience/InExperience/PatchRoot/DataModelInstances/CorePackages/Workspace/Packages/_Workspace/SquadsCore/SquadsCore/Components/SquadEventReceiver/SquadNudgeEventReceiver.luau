local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)
local createConversation = require(SquadsCore.Thunks.createConversation)
local React = require(SquadsCoreParent.React)
local ToastNotification = require(SquadsCoreParent.ToastNotification)
local ToastNotificationsProtocol = require(SquadsCoreParent.ToastNotificationsProtocol)
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local RealtimeDelivery = require(SquadsCoreParent.RealtimeDelivery)
local useLocalization = require(SquadsCoreParent.Localization).Hooks.useLocalization
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local UserProfiles = require(SquadsCoreParent.UserProfiles)
local getStandardSizeAvatarHeadShotRbxthumb = require(SquadsCoreParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local ShowNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local NotificationGroups = ToastNotification.NotificationGroups
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local UserProfileStore = UserProfiles.Stores.UserProfileStore

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), useLocalUserId (copy), useLocalization (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), UserProfileStore (copy), GuiService (copy), RealtimeDelivery (copy), Constants (copy), EventNames (copy), default (copy), SquadToastActionsAndStates (copy), NotificationTypeEnum (copy), actOnPartyNudge (copy), LifecycleEvents (copy), ShowNotificationSnoozeMenuSignal (copy), NotificationGroups (copy), HttpService (copy), createConversation (copy)
	local v27 = useDispatch()
	local v28 = React.useContext(SquadExternalContractContext)
	local v29 = tonumber(useLocalUserId()) or 0
	local v30 = v28.useIsChatEnabled()
	local v31 = v28.useIsLoadingChatSettings()
	local v32 = useLocalization({
		YouJoinedFriendParty = "Feature.Squads.Label.YouJoinedFriendParty",
		FriendJoinedYourParty = "Feature.Squads.Label.FriendJoinedYourParty",
		snoozeTitle = "Feature.Chat.Label.SnoozePartyNotifications",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription"
	})
	local v33 = React.useRef({})
	local v34 = React.useCallback(function(p1, p2) -- line: 56
		-- upvalues: v29 (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), UserProfileStore (copy), GuiService (copy), v32 (copy)
		if p1 == 0 or p2 == 0 then
			return
		end

		local v38 = nil

		if p1 == v29 then
			v38 = p2
		elseif p2 == v29 then
			v38 = p1
		end

		if v38 then
			local v39 = getStandardSizeAvatarHeadShotRbxthumb((tostring(v38)))

			UserProfileStore.get().fetchNamesByUserIds({ (tostring(v38)) }, function(p3) -- line: 70
				-- upvalues: p1 (copy), v29 (copy), GuiService (copy), v32 (copy), v39 (copy)
				if #p3.data > 0 and (p3.data[1] and p3.data[1].names) then
					local v51 = p3.data[1].names.getCombinedName(false)

					if p1 == v29 then
						GuiService:SendNotification({
							Title = v32.FriendJoinedYourParty:gsub("{(.-)}", {
								combinedName = v51
							}),
							Icon = v39
						})

						return
					end

					GuiService:SendNotification({
						Title = v32.YouJoinedFriendParty:gsub("{(.-)}", {
							combinedName = v51
						}),
						Icon = v39
					})
				end
			end)
		end
	end, {
		v29,
		v32.FriendJoinedYourParty,
		v32.YouJoinedFriendParty
	})

	RealtimeDelivery.useRealtimeNamespace(Constants.PARTY_NUDGE_RTN_NAMESPACE, function(p4) -- line: 90
		-- upvalues: Constants (copy), v29 (copy), t1 (copy), v34 (copy)
		if p4.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE and (p4.status == Constants.PARTY_INVITE_ACCEPTED_STATUS and p4.inviterId == v29 and t1.currentSquadId ~= "" and p4.groupUpId == t1.currentSquadId) then
			v34(p4.inviterId, p4.inviteeId)
		end
	end, {
		v29,
		t1.currentSquadId,
		v34
	})

	local v35 = React.useCallback(function(s1: string, s2: string) -- line: 103
		-- upvalues: v28 (copy), EventNames (copy), v33 (copy)
		v28.fireSquadAnalytics(EventNames.SquadToastActions, {
			toastAction = s2,
			toastType = if not v33.current[s1] then nil else v33.current[s1].toastType,
			nudgeId = if not v33.current[s1] then nil else v33.current[s1].nudgeId,
			nudgeType = if not v33.current[s1] then nil else v33.current[s1].nudgeType,
			partyAttemptId = if not v33.current[s1] then nil else v33.current[s1].partyAttemptId,
			squadLocation = v28.squadLocation
		})
	end, {
		v28.fireSquadAnalytics,
		v28.squadLocation
	})

	React.useEffect(function() -- line: 122
		-- upvalues: default (copy), v33 (copy), v35 (copy), SquadToastActionsAndStates (copy), Constants (copy), NotificationTypeEnum (copy), v27 (copy), actOnPartyNudge (copy), v28 (copy), v30 (copy)
		local v43 = default:listenToDismissNotification(function(p5) -- line: 124
			-- upvalues: v33 (copy), v35 (copy), SquadToastActionsAndStates (copy), Constants (copy), NotificationTypeEnum (copy), v27 (copy), actOnPartyNudge (copy), v28 (copy), v30 (copy)
			if p5.notificationId and v33.current[p5.notificationId] then
				v35(p5.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if v33.current[p5.notificationId].shouldActWhenDismiss then
					local v53 = v33.current[p5.notificationId]
					local nudgeType = v53.nudgeType
					local toastType = v53.toastType

					if nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
						local REJECT_PARTY_INVITE_ACTION = nil

						if toastType == NotificationTypeEnum.SquadNudgeInvite then
							REJECT_PARTY_INVITE_ACTION = Constants.REJECT_PARTY_INVITE_ACTION
						elseif toastType == NotificationTypeEnum.SquadStartPartyPrompt then
							REJECT_PARTY_INVITE_ACTION = Constants.REJECT_START_PARTY_REQUEST_ACTION
						end

						if REJECT_PARTY_INVITE_ACTION then
							v27(actOnPartyNudge(REJECT_PARTY_INVITE_ACTION, v53.nudgeId, false, v28.setSquadPrompt, v28.fireSquadAnalytics, v28.squadLocation, v30))
						end
					end
				end
			end

			v33.current[p5.notificationId] = nil
		end)

		return function() -- line: 162
			-- upvalues: v43 (copy)
			if v43 then
				v43:Disconnect()
			end
		end
	end, {
		v35,
		v30,
		v28.setSquadPrompt,
		v28.fireSquadAnalytics,
		v28.squadLocation
	})
	React.useEffect(function() -- line: 175
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), ShowNotificationSnoozeMenuSignal (copy), v32 (copy), NotificationGroups (copy), Constants (copy), v33 (copy), v31 (copy), v30 (copy), default (copy), HttpService (copy), v35 (copy), SquadToastActionsAndStates (copy), v27 (copy), createConversation (copy), v28 (copy), actOnPartyNudge (copy), t1 (copy), v34 (copy)
		local v44 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadStartPartyPrompt, function(p6) -- line: 179
			-- upvalues: ShowNotificationSnoozeMenuSignal (copy), v32 (copy), NotificationGroups (copy), Constants (copy), v33 (copy), v31 (copy), v30 (copy), default (copy), HttpService (copy), v35 (copy), SquadToastActionsAndStates (copy), v27 (copy), createConversation (copy), v28 (copy), actOnPartyNudge (copy), t1 (copy)
			if p6 and (p6.userActionType == "click" and p6.notificationData and p6.visualItem and p6.visualItem.visualItemName == "SnoozeSingleMetaAction") then
				ShowNotificationSnoozeMenuSignal:fire({
					context = "Toast",
					description = v32.snoozeDescription,
					notificationType = NotificationGroups.SquadStartPartyPromptGroup,
					title = v32.snoozeTitle
				})
			end

			if p6 and p6.userActionType == "click" and p6.notificationData and p6.visualItem and p6.visualItem.actionEventParams and p6.visualItem.visualItemName and (p6.visualItem.visualItemName == Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE or p6.visualItem.visualItemName == Constants.DISMISS_START_PARTY_PROMPT_BUTTON_TYPE) then
				local id = p6.notificationData.id

				if v33.current[id] then
					v33.current[id].shouldActWhenDismiss = false
				end

				if not v31 and not v30 then
					default:dismissNotification(id)

					return
				end

				local data = HttpService:JSONDecode(p6.visualItem.actionEventParams)

				if data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE and game.JobId ~= "" and data.gameInstanceId == game.JobId then
					if p6.visualItem.visualItemName == Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE then
						default:dismissNotification(id)
						v35(id, SquadToastActionsAndStates.PartyNudgeAccept)
						v27(createConversation({
							conversationType = "one_to_one",
							userIds = { (tostring(data.inviteeUserId)) },
							source = Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE,
							squadContext = v28,
							onSuccessCallback = function(p7) -- line: 229
								-- upvalues: v27 (copy), actOnPartyNudge (copy), Constants (copy), data (copy), t1 (copy), v28 (copy), v30 (copy), v33 (copy), id (copy)
								v27(actOnPartyNudge(Constants.ACCEPT_START_PARTY_REQUEST_ACTION, data.nudgeId, t1.currentParentChannelId ~= "" and p7 ~= t1.currentParentChannelId, v28.setSquadPrompt, v28.fireSquadAnalytics, v28.squadLocation, v30, if not v33.current[id] then nil else v33.current[id].partyAttemptId, p7))
							end,
							onErrorCallback = function() -- line: 247
								-- upvalues: v27 (copy), actOnPartyNudge (copy), Constants (copy), data (copy), v28 (copy), v30 (copy)
								v27(actOnPartyNudge(Constants.REJECT_START_PARTY_REQUEST_ACTION, data.nudgeId, false, v28.setSquadPrompt, v28.fireSquadAnalytics, v28.squadLocation, v30))
							end
						}))

						return
					end

					if p6.visualItem.visualItemName == Constants.DISMISS_START_PARTY_PROMPT_BUTTON_TYPE then
						v35(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
						v27(actOnPartyNudge(Constants.REJECT_START_PARTY_REQUEST_ACTION, data.nudgeId, false, v28.setSquadPrompt, v28.fireSquadAnalytics, v28.squadLocation, v30))
					end
				end
			end
		end)
		local v45 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadNudgeInvite, function(p8) -- line: 286
			-- upvalues: ShowNotificationSnoozeMenuSignal (copy), v32 (copy), NotificationGroups (copy), Constants (copy), v33 (copy), v31 (copy), v30 (copy), default (copy), HttpService (copy), v35 (copy), SquadToastActionsAndStates (copy), t1 (copy), v27 (copy), actOnPartyNudge (copy), v28 (copy), v34 (copy)
			if p8 and (p8.userActionType == "click" and p8.notificationData and p8.visualItem and p8.visualItem.visualItemName == "SnoozeSingleMetaAction") then
				ShowNotificationSnoozeMenuSignal:fire({
					context = "Toast",
					description = v32.snoozeDescription,
					notificationType = NotificationGroups.SquadNudgeInviteGroup,
					title = v32.snoozeTitle
				})
			end

			if p8 and p8.userActionType == "click" and p8.notificationData and p8.visualItem and p8.visualItem.actionEventParams and p8.visualItem.visualItemName and (p8.visualItem.visualItemName == Constants.JOIN_SQUAD_FROM_NUDGE_BUTTON_TYPE or p8.visualItem.visualItemName == Constants.DISMISS_SQUAD_NUDGE_BUTTON_TYPE) then
				local id = p8.notificationData.id

				if v33.current[id] then
					v33.current[id].shouldActWhenDismiss = false
				end

				if not v31 and not v30 then
					default:dismissNotification(id)

					return
				end

				local data = HttpService:JSONDecode(p8.visualItem.actionEventParams)

				if data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
					local ACCEPT_PARTY_INVITE_ACTION = nil
					local v64 = false

					if p8.visualItem.visualItemName == Constants.JOIN_SQUAD_FROM_NUDGE_BUTTON_TYPE then
						ACCEPT_PARTY_INVITE_ACTION = Constants.ACCEPT_PARTY_INVITE_ACTION
						default:dismissNotification(id)
						v35(id, SquadToastActionsAndStates.PartyNudgeAccept)
						v64 = t1.currentSquadId ~= "" and data.squadId ~= t1.currentSquadId
					elseif p8.visualItem.visualItemName == Constants.DISMISS_SQUAD_NUDGE_BUTTON_TYPE then
						ACCEPT_PARTY_INVITE_ACTION = Constants.REJECT_PARTY_INVITE_ACTION
						v35(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
					end

					if ACCEPT_PARTY_INVITE_ACTION then
						v27(actOnPartyNudge(ACCEPT_PARTY_INVITE_ACTION, data.nudgeId, v64, v28.setSquadPrompt, v28.fireSquadAnalytics, v28.squadLocation, v30, (if not v33.current[id] then nil else v33.current[id].partyAttemptId))):andThen(function() -- line: 354
							-- upvalues: ACCEPT_PARTY_INVITE_ACTION (ref), Constants (copy), v34 (copy), data (copy)
							if ACCEPT_PARTY_INVITE_ACTION == Constants.ACCEPT_PARTY_INVITE_ACTION then
								v34(tonumber(data.inviterUserId) or 0, tonumber(data.inviteeUserId) or 0)
							end
						end)
					end
				end
			end
		end)

		return function() -- line: 368
			-- upvalues: v44 (copy), v45 (copy)
			if v44 then
				v44()
			end

			if v45 then
				v45()
			end
		end
	end, {
		v35,
		v30,
		v28,
		v31,
		v28.setSquadPrompt,
		v28.fireSquadAnalytics,
		v28.squadLocation,
		t1.currentSquadId,
		t1.currentParentChannelId,
		v34,
		v32.snoozeTitle,
		v32.snoozeDescription
	})
	React.useEffect(function() -- line: 392
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v31 (copy), v30 (copy), default (copy), HttpService (copy), Constants (copy), t1 (copy), v33 (copy), v35 (copy), SquadToastActionsAndStates (copy)
		local v46 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadStartPartyPrompt, function(p9) -- line: 396
			-- upvalues: v31 (copy), v30 (copy), default (copy), HttpService (copy), Constants (copy), t1 (copy), v33 (copy), v35 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p9.state.visualItems.button[1].actionEventParams
			local id = p9.id

			if not v31 and not v30 then
				default:dismissNotification(id)

				return
			end

			local v68 = false
			local v69 = true
			local v70 = true
			local data = HttpService:JSONDecode(actionEventParams)

			if data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
				if t1.currentSquadId ~= "" then
					v68 = true
				elseif game.JobId == "" or data.gameInstanceId ~= game.JobId then
					v68 = true
					v69 = false
					v70 = false
				end
			end

			if v69 then
				v33.current[id] = {
					toastType = p9.notificationType,
					partyAttemptId = HttpService:GenerateGUID(false),
					shouldActWhenDismiss = v70,
					nudgeId = data.nudgeId,
					nudgeType = data.nudgeType
				}
				v35(id, SquadToastActionsAndStates.PartyNudgeDisplay)
			end

			if v68 then
				default:dismissNotification(id)
			end
		end)
		local v47 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadNudgeInvite, function(p10) -- line: 445
			-- upvalues: v31 (copy), v30 (copy), default (copy), HttpService (copy), Constants (copy), t1 (copy), v33 (copy), v35 (copy), SquadToastActionsAndStates (copy)
			local actionEventParams = p10.state.visualItems.button[1].actionEventParams
			local id = p10.id

			if not v31 and not v30 then
				default:dismissNotification(id)

				return
			end

			local data = HttpService:JSONDecode(actionEventParams)

			if data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE and t1.currentSquadId ~= "" and t1.currentSquadId == data.squadId then
				default:dismissNotification(id)

				return
			end

			v33.current[id] = {
				shouldActWhenDismiss = true,
				toastType = p10.notificationType,
				partyAttemptId = HttpService:GenerateGUID(false),
				nudgeId = data.nudgeId,
				nudgeType = data.nudgeType
			}
			v35(id, SquadToastActionsAndStates.PartyNudgeDisplay)
		end)

		return function() -- line: 473
			-- upvalues: v46 (copy), v47 (copy)
			if v46 then
				v46()
			end

			if v47 then
				v47()
			end
		end
	end, {
		v30,
		v35,
		v31,
		t1.currentSquadId
	})
	React.useEffect(function() -- line: 484
		-- upvalues: t1 (copy), v33 (copy), Constants (copy), NotificationTypeEnum (copy), default (copy)
		if t1.currentSquadId ~= "" then
			for v48, v49 in v33.current do
				if v49 and v49.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE and v49.toastType == NotificationTypeEnum.SquadStartPartyPrompt then
					default:dismissNotification(v48)
				end
			end
		end
	end, { t1.currentSquadId })

	return nil
end
