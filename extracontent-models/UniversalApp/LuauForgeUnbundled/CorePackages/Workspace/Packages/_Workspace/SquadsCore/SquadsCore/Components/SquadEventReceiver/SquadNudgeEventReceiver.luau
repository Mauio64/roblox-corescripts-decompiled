local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Common/Constants")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local actOnPartyNudge = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/actOnPartyNudge")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/createConversation")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotificationsProtocol")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RealtimeDelivery")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Localization").Hooks.useLocalization
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserProfiles")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local showNotificationSnoozeMenuSignal = ToastNotification.Signals.ShowNotificationSnoozeMenuSignal
local notificationGroups = ToastNotification.NotificationGroups

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local userProfileStore = UserProfiles.Stores.UserProfileStore

return function(p2): nil
	local v5 = useDispatch()
	local v6 = React.useContext(SquadExternalContractContext)
	local v7 = tonumber(useLocalUserId()) or 0

	local v8 = v6.useIsChatEnabled()
	local v9 = v6.useIsLoadingChatSettings()

	local v10 = useLocalization({
		YouJoinedFriendParty = "Feature.Squads.Label.YouJoinedFriendParty",
		FriendJoinedYourParty = "Feature.Squads.Label.FriendJoinedYourParty",
		snoozeTitle = "Feature.Chat.Label.SnoozePartyNotifications",
		snoozeDescription = "Feature.Chat.Description.SnoozeDescription"
	})

	local ref = React.useRef({})

	local v11 = React.useCallback(function(p3, p4)
		if p3 == 0 or p4 == 0 then
			return
		end

		local v12 = if p3 == v7 then p4 elseif p4 == v7 then p3 else nil

		if v12 then
			local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(v12)))
			userProfileStore.get().fetchNamesByUserIds({ (tostring(v12)) }, function(p5)
				if #p5.data > 0 and p5.data[1] and p5.data[1].names then
					local combinedName = p5.data[1].names.getCombinedName(false)

					if p3 == v7 then
						GuiService:SendNotification({
							Title = v10.FriendJoinedYourParty:gsub("{(.-)}", {
								combinedName = combinedName
							}),
							Icon = standardSizeAvatarHeadShotRbxthumb
						})
					else
						GuiService:SendNotification({
							Title = v10.YouJoinedFriendParty:gsub("{(.-)}", {
								combinedName = combinedName
							}),
							Icon = standardSizeAvatarHeadShotRbxthumb
						})
					end
				end
			end)
		end
	end, { v7, v10.FriendJoinedYourParty, v10.YouJoinedFriendParty })

	RealtimeDelivery.useRealtimeNamespace(Constants.PARTY_NUDGE_RTN_NAMESPACE, function(data)
		if
			data.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
			and data.status == Constants.PARTY_INVITE_ACCEPTED_STATUS
			and data.inviterId == v7
			and p2.currentSquadId ~= ""
			and data.groupUpId == p2.currentSquadId
		then
			v11(data.inviterId, data.inviteeId)
		end
	end, { v7, p2.currentSquadId, v11 })

	local v12 = React.useCallback(function(p3, p4)
		local fireSquadAnalytics = v6.fireSquadAnalytics
		local squadToastActions = EventNames.SquadToastActions

		local v14 = if ref.current[p3] then ref.current[p3].toastType else nil

		local v15 = if ref.current[p3] then ref.current[p3].nudgeId else nil

		local v16 = if ref.current[p3] then ref.current[p3].nudgeType else nil

		local v17 = if ref.current[p3] then ref.current[p3].partyAttemptId else nil
		fireSquadAnalytics(squadToastActions, {
			toastAction = p4,
			toastType = v14,
			nudgeId = v15,
			nudgeType = v16,
			partyAttemptId = v17,
			squadLocation = v6.squadLocation
		})
	end, { v6.fireSquadAnalytics, v6.squadLocation })

	React.useEffect(function()
		local connection = default:listenToDismissNotification(function(p3)
			if p3.notificationId and ref.current[p3.notificationId] then
				v12(p3.notificationId, SquadToastActionsAndStates.PartyNudgeGeneralDismiss)

				if ref.current[p3.notificationId].shouldActWhenDismiss then
					local v13 = ref.current[p3.notificationId]
					local nudgeType = v13.nudgeType
					local toastType = v13.toastType

					if nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
						local v14 = nil

						if toastType == notificationTypeEnum.SquadNudgeInvite then
							v14 = Constants.REJECT_PARTY_INVITE_ACTION
						elseif toastType == notificationTypeEnum.SquadStartPartyPrompt then
							v14 = Constants.REJECT_START_PARTY_REQUEST_ACTION
						end

						if v14 then
							v5(actOnPartyNudge(
								v14,
								v13.nudgeId,
								false,
								v6.setSquadPrompt,
								v6.fireSquadAnalytics,
								v6.squadLocation,
								v8
							))
						end
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
	end, { v12, v8, v6.setSquadPrompt, v6.fireSquadAnalytics, v6.squadLocation })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadStartPartyPrompt,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.visualItemName == "SnoozeSingleMetaAction"
				then
					showNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v10.snoozeDescription,
						notificationType = notificationGroups.SquadStartPartyPromptGroup,
						title = v10.snoozeTitle
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

					if not (v9 or v8) then
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
							v12(id, SquadToastActionsAndStates.PartyNudgeAccept)
							v5(createConversation({
								conversationType = "one_to_one",
								userIds = { (tostring(jsonDecode.inviteeUserId)) },
								source = Constants.START_PARTY_FROM_PROMPT_BUTTON_TYPE,
								squadContext = v6,
								onSuccessCallback = function(p3)
									local ACCEPT_START_PARTY_REQUEST_ACTION = Constants.ACCEPT_START_PARTY_REQUEST_ACTION
									local nudgeId = jsonDecode.nudgeId
									local v15 = not (p2.currentParentChannelId == "")
										and p2.currentParentChannelId ~= p3
									local setSquadPrompt = v6.setSquadPrompt
									local fireSquadAnalytics = v6.fireSquadAnalytics
									local squadLocation = v6.squadLocation

									local v17 = if ref.current[id] then ref.current[id].partyAttemptId else nil
									v5(actOnPartyNudge(
										ACCEPT_START_PARTY_REQUEST_ACTION,
										nudgeId,
										v15,
										setSquadPrompt,
										fireSquadAnalytics,
										squadLocation,
										v8,
										v17,
										p3
									))
								end,
								onErrorCallback = function()
									v5(actOnPartyNudge(
										Constants.REJECT_START_PARTY_REQUEST_ACTION,
										jsonDecode.nudgeId,
										false,
										v6.setSquadPrompt,
										v6.fireSquadAnalytics,
										v6.squadLocation,
										v8
									))
								end
							}))
						elseif data.visualItem.visualItemName == Constants.DISMISS_START_PARTY_PROMPT_BUTTON_TYPE then
							v12(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
							v5(actOnPartyNudge(
								Constants.REJECT_START_PARTY_REQUEST_ACTION,
								jsonDecode.nudgeId,
								false,
								v6.setSquadPrompt,
								v6.fireSquadAnalytics,
								v6.squadLocation,
								v8
							))
						end
					end
				end
			end
		)

		local callback2 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadNudgeInvite,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.visualItemName == "SnoozeSingleMetaAction"
				then
					showNotificationSnoozeMenuSignal:fire({
						context = "Toast",
						description = v10.snoozeDescription,
						notificationType = notificationGroups.SquadNudgeInviteGroup,
						title = v10.snoozeTitle
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

					if not (v9 or v8) then
						default:dismissNotification(id)
						return
					end

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
						local v13 = nil
						local v14 = false

						if data.visualItem.visualItemName == Constants.JOIN_SQUAD_FROM_NUDGE_BUTTON_TYPE then
							v13 = Constants.ACCEPT_PARTY_INVITE_ACTION
							default:dismissNotification(id)
							v12(id, SquadToastActionsAndStates.PartyNudgeAccept)
							v14 = not (p2.currentSquadId == "") and jsonDecode.squadId ~= p2.currentSquadId
						elseif data.visualItem.visualItemName == Constants.DISMISS_SQUAD_NUDGE_BUTTON_TYPE then
							v13 = Constants.REJECT_PARTY_INVITE_ACTION
							v12(id, SquadToastActionsAndStates.PartyNudgeButtonDismiss)
						end

						if v13 then
							local nudgeId = jsonDecode.nudgeId

							local setSquadPrompt = v6.setSquadPrompt
							local fireSquadAnalytics = v6.fireSquadAnalytics
							local squadLocation = v6.squadLocation

							local v19 = if ref.current[id] then ref.current[id].partyAttemptId else nil
							v5(actOnPartyNudge(
								v13,
								nudgeId,
								v14,
								setSquadPrompt,
								fireSquadAnalytics,
								squadLocation,
								v8,
								v19
							)):andThen(function()
								if v13 == Constants.ACCEPT_PARTY_INVITE_ACTION then
									v11(
										tonumber(jsonDecode.inviterUserId) or 0,
										tonumber(jsonDecode.inviteeUserId) or 0
									)
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
		v12,
		v8,
		v6,
		v9,
		v6.setSquadPrompt,
		v6.fireSquadAnalytics,
		v6.squadLocation,
		p2.currentSquadId,
		p2.currentParentChannelId,
		v11,
		v10.snoozeTitle,
		v10.snoozeDescription
	})

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadStartPartyPrompt,
			function(data)
				local actionEventParams = data.state.visualItems.button[1].actionEventParams
				local id = data.id

				if not (v9 or v8) then
					default:dismissNotification(id)
					return
				end

				local flag = false
				local flag2 = true
				local v13 = true
				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE then
					if p2.currentSquadId == "" then
						if game.JobId == "" or jsonDecode.gameInstanceId ~= game.JobId then
							flag2 = false
							v13 = false
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
						shouldActWhenDismiss = v13,
						nudgeId = jsonDecode.nudgeId,
						nudgeType = jsonDecode.nudgeType
					}

					v12(id, SquadToastActionsAndStates.PartyNudgeDisplay)
				end

				if flag then
					default:dismissNotification(id)
				end
			end
		)

		local callback2 = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadNudgeInvite,
			function(data)
				local actionEventParams = data.state.visualItems.button[1].actionEventParams
				local id = data.id

				if not (v9 or v8) then
					default:dismissNotification(id)
					return
				end

				local jsonDecode = HttpService:JSONDecode(actionEventParams)

				if
					jsonDecode.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
					and p2.currentSquadId ~= ""
					and p2.currentSquadId == jsonDecode.squadId
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

				v12(id, SquadToastActionsAndStates.PartyNudgeDisplay)
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
	end, { v8, v12, v9, p2.currentSquadId })

	React.useEffect(function()
		if p2.currentSquadId ~= "" then
			for k, v13 in ref.current do
				if
					v13
					and v13.nudgeType == Constants.ONE_TO_ONE_NUDGE_IN_EXPERIENCE_TYPE
					and v13.toastType == notificationTypeEnum.SquadStartPartyPrompt
				then
					default:dismissNotification(k)
				end
			end
		end
	end, { p2.currentSquadId })

	return nil
end
