local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ExperienceService").ExperienceService

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadAppChatEventReceiver")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadExperienceInviteEventReceiver")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadLifecycleEventReceiver")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadRccEventReceiver")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadParentChannelEventReceiver")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/ScheduledSquadEventReceiver")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadStorageEventReceiver")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadNudgeEventReceiver")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadMemberStatusEventReceiver")
local SquadNudgeEventReceiver_NudgeV1Exp = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadNudgeEventReceiver_NudgeV1Exp")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadEventReceiver/SquadRegroupPromptEventReceiver")

local currentSquadUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/RoduxSquads").Actions.CurrentSquadUpdated
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/EventNames")

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local SquadCoplayJoin = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadCoplayJoin")
local SquadLocationEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLocationEnum")
local SquadRootViewType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadRootViewType")
local SquadToastActionsAndStates = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastActionsAndStates")
local SquadToastType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadToastType")
local joinSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/joinSquad")
local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Thunks/leaveSquad")
local logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Analytics/logInExpCoplayTelemetry")
local useOnSquadEnded = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useOnSquadEnded")
local useCrossExperienceVoiceConnector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCrossExperienceVoiceConnector")
local RegroupPromptNotificationState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/RegroupPromptNotificationState")

local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperienceVoice")
local crossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SharedFlags")
local SoundManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SoundManager")
local ToastNotification = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotification")
local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/ToastNotificationsProtocol")
local useCrossExperienceVoice = CrossExperienceVoice.Hooks.useCrossExperienceVoice
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.useEffectOnce
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector

local sounds = SoundManager.Sounds
local soundManager = SoundManager.SoundManager

local getFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local fFlagPartyVoiceBlockSync = SharedFlags.FFlagPartyVoiceBlockSync
local fFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local fIntPartyVoiceJoinRequestPulseCheckTimeout = SharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local fFlagReadAppChatFetchingVariable = SharedFlags.FFlagReadAppChatFetchingVariable
local fFlagEnablePartyNudgeV1_DEV = SharedFlags.FFlagEnablePartyNudgeV1_DEV
local fFlagAppChatNavigateBackIfOSAUnacknowledged = SharedFlags.FFlagAppChatNavigateBackIfOSAUnacknowledged
local fFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local fFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local fFlagEnableSquadRegroupServerCapacityCheck = SharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local lifecycleEvents = ToastNotification.LifecycleEvents
local notificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default2 = ToastNotification.ToastNotificationSnoozeManager.default
local squadUnifyCoplayExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SocialExperiments").SquadUnifyCoplayExperimentation

local defineFastFlag = game:DefineFastFlag("LeaveSquadIfChatDisabled", false)

return function()
	local v5 = useDispatch()
	local v6 = tonumber(useLocalUserId()) or 0
	local v7 = React.useContext(SquadExternalContractContext)

	local v8 = v7.useSquadRootView()
	local v9 = v7.useIsChatEnabled()

	local v10 = v7.useIsLoadingChatSettings()

	local v11 = useCurrentSquadSelector()
	local v12 = not (v11 and v11.squadId) and "" or v11.squadId
	local v13 = not (v11 and v11.parentChannelId) and "" or v11.parentChannelId

	useEffectOnce(function()
		if v11 then
			logInExpCoplayTelemetry(v12, v11.members, v7.squadLocation, SquadCoplayJoin.ExperienceJoin, v7.fireSquadAnalytics)
		end
	end, {})

	local function fn()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadInvitation,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "JoinSquad"
					and data.visualItem.actionEventParams
				then
					v7.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v13,
						toastAction = SquadToastActionsAndStates.SquadInviteAccept,
						toastType = SquadToastType.SquadInvite
					})

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)
					default:dismissNotification(data.notificationData.id)

					v5(joinSquad(
						jsonDecode.squadId,
						v7.setSquadPrompt,
						v7.fireSquadAnalytics,
						v7.squadLocation,
						not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v9
					))
				end
			end
		)

		return function()
			callback()
		end
	end

	React.useEffect(fn, {
		v13,
		v5,
		joinSquad,
		v7.fireSquadAnalytics,
		v7.setSquadPrompt,
		v7.squadLocation,
		if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then v9 else nil
	})

	local function fn2()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadInvitationV2,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
				then
					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if data.visualItem.visualItemName == "view" and v7.showGroupOSADialog then
						default:dismissNotification(data.notificationData.id)
						v7.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v13,
							toastAction = SquadToastActionsAndStates.SquadInviteViewOsa,
							toastType = SquadToastType.SquadInviteV2
						})

						v7.showGroupOSADialog(jsonDecode.chatId, function()
							v5(joinSquad(
								jsonDecode.squadId,
								v7.setSquadPrompt,
								v7.fireSquadAnalytics,
								v7.squadLocation,
								not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v9
							))
						end, function() end)
					elseif data.visualItem.visualItemName == "join" then
						default:dismissNotification(data.notificationData.id)
						v7.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v13,
							toastAction = SquadToastActionsAndStates.SquadInviteAccept,
							toastType = SquadToastType.SquadInviteV2
						})

						v5(joinSquad(
							jsonDecode.squadId,
							v7.setSquadPrompt,
							v7.fireSquadAnalytics,
							v7.squadLocation,
							not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v9
						))
					end
				end
			end
		)

		return function()
			callback()
		end
	end

	React.useEffect(fn2, {
		v13,
		v5,
		joinSquad,
		v7.fireSquadAnalytics,
		v7.setSquadPrompt,
		v7.showGroupOSADialog,
		v7.squadLocation,
		if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then v9 else nil
	})

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadInvitation,
			function(p2)
				if v9 and not default2:isSnoozedNotificationType(p2.notificationType) then
					soundManager:PlaySound(sounds.PartyToast.Name)
				end
			end
		)

		return function()
			if callback then
				callback()
			end
		end
	end, { v9 })
	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.Display,
			notificationTypeEnum.SquadInvitationV2,
			function(p2)
				if v9 and not default2:isSnoozedNotificationType(p2.notificationType) then
					soundManager:PlaySound(sounds.PartyToast.Name)
				end
			end
		)

		return function()
			if callback then
				callback()
			end
		end
	end, { v9 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if not data then
				return
			end

			if
				(data.notificationType == notificationTypeEnum.SquadInvitation or data.notificationType == notificationTypeEnum.SquadInvitationV2 or data.notificationType == notificationTypeEnum.SquadExperienceInvitation or data.notificationType == notificationTypeEnum.SquadJoinRequestPrompt or data.notificationType == notificationTypeEnum.SquadAcceptJoinRequest)
				and not v9
			then
				default:dismissNotification(data.notificationId)
			elseif v6 <= 0 then
				if
					data.notificationId
					and (data.notificationType == notificationTypeEnum.SquadInvitation or data.notificationType == notificationTypeEnum.SquadInvitationV2 or data.notificationType == notificationTypeEnum.SquadExperienceInvitation)
				then
					default:dismissNotification(data.notificationId)
				end
			elseif
				(data.notificationType == notificationTypeEnum.SquadInvitation or data.notificationType == notificationTypeEnum.SquadInvitationV2)
				and v12 == HttpService:JSONDecode(data.lifecycleData).squadId
			then
				default:dismissNotification(data.notificationId)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { v12, v6, v9 })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadJoinRequestPrompt,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "RequestToJoinParty"
					and data.visualItem.actionEventParams
				then
					v7.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v13,
						toastAction = SquadToastActionsAndStates.RequestToJoinPartyAccept,
						toastType = SquadToastType.RequestToJoinParty
					})

					default:dismissNotification(data.notificationData.id)
				end
			end
		)

		return function()
			callback()
		end
	end, { v13, v7.fireSquadAnalytics })

	React.useEffect(function()
		local callback = lifecycleEvents:RegisterCallback(
			lifecycleEvents.ToastEvents.UserAction,
			notificationTypeEnum.SquadAcceptJoinRequest,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "AcceptPartyJoinRequest"
					and data.visualItem.actionEventParams
				then
					v7.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v13,
						toastAction = SquadToastActionsAndStates.AcceptPartyJoinRequestAccept,
						toastType = SquadToastType.AcceptPartyJoinRequest
					})

					default:dismissNotification(data.notificationData.id)
				end
			end
		)

		return function()
			callback()
		end
	end, { v13, v7.fireSquadAnalytics })

	if getFFlagEnableCrossExpVoice() and fFlagPartyVoiceBlockSync then
		local v21 = useSelector((React.useCallback(function(p2)
			return p2.Squad.UserBlocking.isBlockedByMe
		end, {})))

		local ref = React.useRef({})
		React.useEffect(function()
			if ref.current == v21 then
				return
			end

			for k, v22 in pairs(v21) do
				local v23 = ref.current[k] or false

				if v22 and not v23 then
					crossExperienceVoiceManager.default:blockVoiceParticipant(k)
				elseif not v22 and v23 then
					crossExperienceVoiceManager.default:unblockVoiceParticipant(k)
				end
			end

			ref.current = v21
		end, { v21 })
	end

	if getFFlagEnableCrossExpVoice() then
		if fIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			useCrossExperienceVoice({ handleRCCConnectionTimeout = true })
		else
			useCrossExperienceVoice()
		end

		local v20 = useCrossExperienceVoiceConnector()
		useOnSquadEnded(function()
			v20()
		end)
	end

	local useEffect3 = React.useEffect
	local function fn3()
		if not (fFlagReadAppChatFetchingVariable and v10) and not v9 and v12 ~= "" then
			if defineFastFlag then
				v5(leaveSquad(
					nil,
					v7.setSquadPrompt,
					nil,
					v7.squadLocation,
					not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v9
				))
			else
				v5(currentSquadUpdated(nil))
			end
		end
	end

	local v21 = if fFlagReadAppChatFetchingVariable then v10 else nil
	local setSquadPrompt3 = if defineFastFlag then v7.setSquadPrompt else nil
	local v22 = if defineFastFlag then v7.squadLocation else nil
	useEffect3(fn3, { v9, v12, v21, setSquadPrompt3, v22 })

	if fFlagAppChatNavigateBackIfOSAUnacknowledged and not fFlagAppChatShowOSAOnPageEntry then
		local v23 = v7.useGetConversationFromId(v13)
		local shouldShowOSAForConversation = v7.shouldShowOSAForConversation(v23)

		React.useEffect(function()
			if shouldShowOSAForConversation and v12 ~= "" then
				v5(leaveSquad(nil, v7.setSquadPrompt, nil, v7.squadLocation, true))
			end
		end, { shouldShowOSAForConversation, v12, v7.setSquadPrompt, v7.squadLocation })
	end

	local v23 = not fFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1

	local v24 = fFlagEnableSquadRegroupExperimentation

	if v24 then
		if v7.squadLocation == SquadLocationEnum.InExperience then
			v24 = v23
				and v11
				and v11.selfPermissions
				and v11.selfPermissions.canSeeRegroupPromptToast
				and #v11.members > 1
		else
			v24 = false
		end
	end

	React.useEffect(function()
		if not fFlagEnableSquadRegroupExperimentation then
			return function() end
		end

		local connection = experienceService:RegisterForExperienceLeave(function()
			local activeNotifId = RegroupPromptNotificationState.getActiveNotifId()
			RegroupPromptNotificationState.dismissNotification(activeNotifId)
		end)

		return function()
			if connection and connection.Disconnect then
				connection:Disconnect()
			end
		end
	end, {})

	React.useEffect(function()
		if fFlagEnableSquadRegroupExperimentation then
			local activeNotifId = RegroupPromptNotificationState.getActiveNotifId()
			local activeSquadId = RegroupPromptNotificationState.getActiveSquadId()

			if activeNotifId ~= nil and v12 ~= activeSquadId then
				RegroupPromptNotificationState.dismissNotification(activeNotifId)
			end
		end
	end, { v12 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		SquadLifecycleEventReceiver = React.createElement(module3, {
			currentSquadId = v12
		}),
		SquadParentChannelEventReceiver = 0,
		SquadMemberStatusEventReceiver = 0,
		SquadAppChatEventReceiver = 0,
		SquadExperienceInviteEventReceiver = 0,
		SquadRccEventReceiver = 0,
		SquadStorageEventReceiver = 0,
		SquadNudgeEventReceiver = 0,
		ScheduledSquadEventReceiver = 0,
		SquadRegroupPromptEventReceiver = 0
	}

	local v26 = if v11 then React.createElement(module5, {
		currentParentChannelId = v11.parentChannelId
	}) else nil
	children.SquadParentChannelEventReceiver = v26

	local v27 = if (squadUnifyCoplayExperimentation.getOneOnOnePartyCreationEnabled() or squadUnifyCoplayExperimentation.getMultiInvitePartyCreationEnabled()) and v7.squadLocation == SquadLocationEnum.InExperience then React.createElement(module9) else nil
	children.SquadMemberStatusEventReceiver = v27
	local v28

	if not (fFlagSquadAppChatRTNFix or v8 == SquadRootViewType.None) then
		local createElement2 = React.createElement
		local v31 = if v11 then v11.parentChannelId else nil
		v28 = createElement2(module, { conversationId = v31 })
	end

	children.SquadAppChatEventReceiver = v28

	children.SquadExperienceInviteEventReceiver = React.createElement(module2, {
		currentSquadId = v12
	})

	local v29 = if v7.squadLocation == SquadLocationEnum.InExperience then React.createElement(module4, {
		currentSquadId = v12
	}) else nil
	children.SquadRccEventReceiver = v29

	children.SquadStorageEventReceiver = React.createElement(module7)
	local createElement2 = React.createElement
	local v30 = if fFlagEnablePartyNudgeV1_DEV then SquadNudgeEventReceiver_NudgeV1Exp else module8
	children.SquadNudgeEventReceiver = createElement2(v30, {
		currentSquadId = v12,
		currentParentChannelId = v13
	})

	children.ScheduledSquadEventReceiver = React.createElement(module6)

	local v31 = if v24 then React.createElement(module11, {
		currentSquadMembers = v11 and v11.members or {},
		currentSquadId = v12
	}) else nil
	children.SquadRegroupPromptEventReceiver = v31
	return createElement(fragment, nil, children)
end
