local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local Constants = require(SquadsCore.Common.Constants)
local EventNames = require(SquadsCore.Analytics.EventNames)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local actOnPartyNudge = require(SquadsCore.Thunks.actOnPartyNudge)
local createConversation = require(SquadsCore.Thunks.createConversation)

local React = require(parent.React)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RealtimeDelivery = require(parent.RealtimeDelivery)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local UserProfiles = require(parent.UserProfiles)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local ShowNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local NotificationGroups = ToastNotification.NotificationGroups

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local UserProfileStore = UserProfiles.Stores.UserProfileStore

return function(p): nil
	local v = useDispatch()
	local squadContext = React.useContext(SquadExternalContractContext)
	local v2 = tonumber(useLocalUserId()) or 0

	local v3 = squadContext.useIsChatEnabled()
	local v4 = squadContext.useIsLoadingChatSettings()

	local v5 = useLocalization({
		YouJoinedFriendParty = "Feature.Squads.Label.YouJoinedFriendParty",
		FriendJoinedYourParty = "Feature.Squads.Label.FriendJoinedYourParty",
		snoozeTitle = "Feature.Chat.Label.SnoozePartyNotifications",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription"
	})

	local ref = React.useRef({})

	local v6 = React.useCallback(function(p2, p3)
		if p2 == 0 or p3 == 0 then
			return
		end

		local v6 = nil

		if p2 == v2 then
			v6 = p3
		elseif p3 == v2 then
			v6 = p2
		end

		if v6 then
			local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(v6)))
			UserProfileStore.get().fetchNamesByUserIds({ (tostring(v6)) }, function(p4)
				if #p4.data > 0 and p4.data[1] and p4.data[1].names then
					local combinedName = p4.data[1].names.getCombinedName(false)

					if p2 == v2 then
						GuiService:SendNotification({
							Title = v5.FriendJoinedYourParty:gsub("{(.-)}", {
								combinedName = combinedName
							}),
							Icon = standardSizeAvatarHeadShotRbxthumb
						})
					else
						GuiService:SendNotification({
							Title = v5.YouJoinedFriendParty:gsub("{(.-)}", {
								combinedName = combinedName
							}),
							Icon = standardSizeAvatarHeadShotRbxthumb
						})
					end
				end
			end)
		end
	end, { v2, v5.FriendJoinedYourParty, v5.YouJoinedFriendParty })

	RealtimeDelivery.useRealtimeNamespace(Constants.PARTY_NUDGE_RTN_NAMESPACE, function(data)
		if
			data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
			and data.status == Constants.PARTY_INVITE_ACCEPTED_STATUS
			and data.inviterId == v2
			and p.currentSquadId ~= ""
			and data.groupUpId == p.currentSquadId
		then
			v6(data.inviterId, data.inviteeId)
		end
	end, { v2, p.currentSquadId, v6 })

	local v7 = React.useCallback(function(p2: string, toastAction: string)
		local fireSquadAnalytics = squadContext.fireSquadAnalytics
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
			squadLocation = squadContext.squadLocation
		})
	end, { squadContext.fireSquadAnalytics, squadContext.squadLocation })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p2)
			if p2.notificationId and ref.current[p2.notificationId] then
				v7(p2.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if ref.current[p2.notificationId].shouldActWhenDismiss then
					local v8 = ref.current[p2.notificationId]
					local nudgeType = v8.nudgeType
					local toastType = v8.toastType

					if nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
						local v9 = nil

						if toastType == NotificationTypeEnum.SquadNudgeInvite then
							v9 = Constants.REJECT_PARTY_INVITE_ACTION
						elseif toastType == NotificationTypeEnum.SquadStartPartyPrompt then
							v9 = Constants.REJECT_START_PARTY_REQUEST_ACTION
						end

						if v9 then
							v(actOnPartyNudge(
								v9,
								v8.nudgeId,
								false,
								squadContext.setSquadPrompt,
								squadContext.fireSquadAnalytics,
								squadContext.squadLocation,
								v3
							))
						end
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
	end, {
		v7,
		v3,
		squadContext.setSquadPrompt,
		squadContext.fireSquadAnalytics,
		squadContext.squadLocation
	})

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadStartPartyPrompt,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.visualItemName == "SnoozeSingleMetaAction"
				then
					ShowNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v5.snoozeDescription,
						notificationType = NotificationGroups.SquadStartPartyPromptGroup,
						title = v5.snoozeTitle
					})
				end

				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
					and data.visualItem.visualItemName
					and (data.visualItem.visualItemName == Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE or data.visualItem.visualItemName == Constants.DISMISS_START_PARTY_PROMPT_BUTTON_TYPE)
				then
					local id = data.notificationData.id

					if ref.current[id] then
						ref.current[id].shouldActWhenDismiss = false
					end

					if not (v4 or v3) then
						default:dismissNotification(id)
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if
						jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
						and game.JobId ~= ""
						and jsonDecode.gameInstanceId == game.JobId
					then
						if data.visualItem.visualItemName == Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE then
							default:dismissNotification(id)
							v7(id, SquadToastActionsAndStates.PartyNudgeAccept)
							v(createConversation({
								conversationType = "one_to_one",
								userIds = { (tostring(jsonDecode.inviteeUserId)) },
								source = Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE,
								squadContext = squadContext,
								onSuccessCallback = function(p2)
									local ACCEPT_START_PARTY_REQUEST_ACTION = Constants.ACCEPT_START_PARTY_REQUEST_ACTION
									local nudgeId = jsonDecode.nudgeId
									local v8

									if p.currentParentChannelId == "" then
										v8 = false
									else
										v8 = p.currentParentChannelId ~= p2
									end

									local setSquadPrompt = squadContext.setSquadPrompt
									local fireSquadAnalytics = squadContext.fireSquadAnalytics
									local squadLocation = squadContext.squadLocation
									local v9

									if ref.current[id] then
										v9 = ref.current[id].partyAttemptId
									end

									v(actOnPartyNudge(
										ACCEPT_START_PARTY_REQUEST_ACTION,
										nudgeId,
										v8,
										setSquadPrompt,
										fireSquadAnalytics,
										squadLocation,
										v3,
										v9,
										p2
									))
								end,
								onErrorCallback = function()
									v(actOnPartyNudge(
										Constants.REJECT_START_PARTY_REQUEST_ACTION,
										jsonDecode.nudgeId,
										false,
										squadContext.setSquadPrompt,
										squadContext.fireSquadAnalytics,
										squadContext.squadLocation,
										v3
									))
								end
							}))
						elseif data.visualItem.visualItemName == Constants.DISMISS_START_PARTY_PROMPT_BUTTON_TYPE then
							v7(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
							v(actOnPartyNudge(
								Constants.REJECT_START_PARTY_REQUEST_ACTION,
								jsonDecode.nudgeId,
								false,
								squadContext.setSquadPrompt,
								squadContext.fireSquadAnalytics,
								squadContext.squadLocation,
								v3
							))
						end
					end
				end
			end
		)

		local callback2 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadNudgeInvite,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.visualItemName == "SnoozeSingleMetaAction"
				then
					ShowNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v5.snoozeDescription,
						notificationType = NotificationGroups.SquadNudgeInviteGroup,
						title = v5.snoozeTitle
					})
				end

				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
					and data.visualItem.visualItemName
					and (data.visualItem.visualItemName == Constants.JOIN_SQUAD_FROM_NUDGE_BUTTON_TYPE or data.visualItem.visualItemName == Constants.DISMISS_SQUAD_NUDGE_BUTTON_TYPE)
				then
					local id = data.notificationData.id

					if ref.current[id] then
						ref.current[id].shouldActWhenDismiss = false
					end

					if not (v4 or v3) then
						default:dismissNotification(id)
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
						local v8 = nil
						local v9 = false

						if data.visualItem.visualItemName == Constants.JOIN_SQUAD_FROM_NUDGE_BUTTON_TYPE then
							v8 = Constants.ACCEPT_PARTY_INVITE_ACTION
							default:dismissNotification(id)
							v7(id, SquadToastActionsAndStates.PartyNudgeAccept)

							if p.currentSquadId == "" then
								v9 = false
							else
								v9 = jsonDecode.squadId ~= p.currentSquadId
							end
						elseif data.visualItem.visualItemName == Constants.DISMISS_SQUAD_NUDGE_BUTTON_TYPE then
							v8 = Constants.REJECT_PARTY_INVITE_ACTION
							v7(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
						end

						if v8 then
							local nudgeId = jsonDecode.nudgeId

							local setSquadPrompt = squadContext.setSquadPrompt
							local fireSquadAnalytics = squadContext.fireSquadAnalytics
							local squadLocation = squadContext.squadLocation
							local v10

							if ref.current[id] then
								v10 = ref.current[id].partyAttemptId
							end

							v(actOnPartyNudge(
								v8,
								nudgeId,
								v9,
								setSquadPrompt,
								fireSquadAnalytics,
								squadLocation,
								v3,
								v10
							)):andThen(function()
								if v8 == Constants.ACCEPT_PARTY_INVITE_ACTION then
									v6(tonumber(jsonDecode.inviterUserId) or 0, tonumber(jsonDecode.inviteeUserId) or 0)
								end
							end)
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
		v7,
		v3,
		squadContext,
		v4,
		squadContext.setSquadPrompt,
		squadContext.fireSquadAnalytics,
		squadContext.squadLocation,
		p.currentSquadId,
		p.currentParentChannelId,
		v6,
		v5.snoozeTitle,
		v5.snoozeDescription
	})

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadStartPartyPrompt,
			function(data)
				local actionEventParams = data.state.visualItems.button[1].actionEventParams
				local id = data.id

				if not (v4 or v3) then
					default:dismissNotification(id)
					return
				end

				local flag = false
				local flag2 = true
				local shouldActWhenDismiss = true
				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
					if p.currentSquadId == "" then
						if game.JobId == "" or jsonDecode.gameInstanceId ~= game.JobId then
							flag2 = false
							shouldActWhenDismiss = false
							flag = true
						end
					else
						flag = true
					end
				end

				if flag2 then
					ref.current[id] = {
						toastType = data.notificationType,
						partyAttemptId = HttpService:GenerateGUID(false),
						shouldActWhenDismiss = shouldActWhenDismiss,
						nudgeId = jsonDecode.nudgeId,
						nudgeType = jsonDecode.nudgeType
					}

					v7(id, SquadToastActionsAndStates.PartyNudgeDisplay)
				end

				if flag then
					default:dismissNotification(id)
				end
			end
		)

		local callback2 = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadNudgeInvite,
			function(data)
				local actionEventParams = data.state.visualItems.button[1].actionEventParams
				local id = data.id

				if not (v4 or v3) then
					default:dismissNotification(id)
					return
				end

				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if
					jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
					and p.currentSquadId ~= ""
					and p.currentSquadId == jsonDecode.squadId
				then
					default:dismissNotification(id)
					return
				end

				ref.current[id] = {
					toastType = data.notificationType,
					partyAttemptId = HttpService:GenerateGUID(false),
					shouldActWhenDismiss = true,
					nudgeId = jsonDecode.nudgeId,
					nudgeType = jsonDecode.nudgeType
				}

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
		end
	end, { v3, v7, v4, p.currentSquadId })

	React.useEffect(function()
		if p.currentSquadId ~= "" then
			for k, v8 in ref.current do
				if
					v8
					and v8.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
					and v8.toastType == NotificationTypeEnum.SquadStartPartyPrompt
				then
					default:dismissNotification(k)
				end
			end
		end
	end, { p.currentSquadId })

	return nil
end
