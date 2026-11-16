local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ExperienceService = require(parent.ExperienceService)
local experienceService = ExperienceService.ExperienceService

local SquadAppChatEventReceiver = require(script.Parent.SquadAppChatEventReceiver)
local SquadExperienceInviteEventReceiver = require(script.Parent.SquadExperienceInviteEventReceiver)
local SquadLifecycleEventReceiver = require(script.Parent.SquadLifecycleEventReceiver)
local SquadRccEventReceiver = require(script.Parent.SquadRccEventReceiver)
local SquadParentChannelEventReceiver = require(script.Parent.SquadParentChannelEventReceiver)
local ScheduledSquadEventReceiver = require(script.Parent.ScheduledSquadEventReceiver)
local SquadStorageEventReceiver = require(script.Parent.SquadStorageEventReceiver)
local SquadNudgeEventReceiver = require(script.Parent.SquadNudgeEventReceiver)
local SquadMemberStatusEventReceiver = require(script.Parent.SquadMemberStatusEventReceiver)
local SquadNudgeEventReceiver_NudgeV1Exp = require(script.Parent.SquadNudgeEventReceiver_NudgeV1Exp)
local SquadRegroupPromptEventReceiver = require(script.Parent.SquadRegroupPromptEventReceiver)

local RoduxSquads = require(SquadsCore.RoduxSquads)
local CurrentSquadUpdated = RoduxSquads.Actions.CurrentSquadUpdated
local EventNames = require(SquadsCore.Analytics.EventNames)

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local SquadCoplayJoin = require(SquadsCore.Enums.SquadCoplayJoin)
local SquadLocationEnum = require(SquadsCore.Enums.SquadLocationEnum)
local SquadRootViewType = require(SquadsCore.Enums.SquadRootViewType)
local SquadToastActionsAndStates = require(SquadsCore.Enums.SquadToastActionsAndStates)
local SquadToastType = require(SquadsCore.Enums.SquadToastType)
local joinSquad = require(SquadsCore.Thunks.joinSquad)
local leaveSquad = require(SquadsCore.Thunks.leaveSquad)
local logInExpCoplayTelemetry = require(SquadsCore.Analytics.logInExpCoplayTelemetry)
local useOnSquadEnded = require(SquadsCore.Hooks.useOnSquadEnded)
local useCrossExperienceVoiceConnector = require(SquadsCore.Hooks.useCrossExperienceVoiceConnector)
local RegroupPromptNotificationState = require(SquadsCore.Utils.RegroupPromptNotificationState)

local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local React = require(parent.React)
local RoduxSquads2 = require(parent.RoduxSquads)
local SharedFlags = require(parent.SharedFlags)
local SoundManager = require(parent.SoundManager)
local ToastNotification = require(parent.ToastNotification)
local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
local useCrossExperienceVoice = CrossExperienceVoice.Hooks.useCrossExperienceVoice
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useEffectOnce = RoactUtils2.Hooks.useEffectOnce
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector

local useCurrentSquadSelector = RoduxSquads2.Hooks.useCurrentSquadSelector

local Sounds = SoundManager.Sounds
local soundManager = SoundManager.SoundManager

local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local FFlagPartyVoiceBlockSync = SharedFlags.FFlagPartyVoiceBlockSync
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FIntPartyVoiceJoinRequestPulseCheckTimeout = SharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local FFlagReadAppChatFetchingVariable = SharedFlags.FFlagReadAppChatFetchingVariable
local FFlagEnablePartyNudgeV1_DEV = SharedFlags.FFlagEnablePartyNudgeV1_DEV
local FFlagAppChatNavigateBackIfOSAUnacknowledged = SharedFlags.FFlagAppChatNavigateBackIfOSAUnacknowledged
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local FFlagEnableSquadRegroupServerCapacityCheck = SharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default2 = ToastNotification.ToastNotificationSnoozeManager.default
local SocialExperiments = require(parent.SocialExperiments)
local SquadUnifyCoplayExperimentation = SocialExperiments.SquadUnifyCoplayExperimentation

local defineFastFlag = game:DefineFastFlag("LeaveSquadIfChatDisabled", false)

return function()
	local v = useDispatch()
	local v2 = tonumber(useLocalUserId()) or 0
	local v3 = React.useContext(SquadExternalContractContext)

	local v4 = v3.useSquadRootView()
	local v5 = v3.useIsChatEnabled()

	local v6 = v3.useIsLoadingChatSettings()

	local v7 = useCurrentSquadSelector()
	local currentSquadId = not (v7 and v7.squadId) and "" or v7.squadId
	local v8 = not (v7 and v7.parentChannelId) and "" or v7.parentChannelId

	useEffectOnce(function()
		if v7 then
			logInExpCoplayTelemetry(
				currentSquadId,
				v7.members,
				v3.squadLocation,
				SquadCoplayJoin.ExperienceJoin,
				v3.fireSquadAnalytics
			)
		end
	end, {})

	local useEffect = React.useEffect
	local function fn()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadInvitation,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "JoinSquad"
					and data.visualItem.actionEventParams
				then
					v3.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v8,
						toastAction = SquadToastActionsAndStates.SquadInviteAccept,
						toastType = SquadToastType.SquadInvite
					})

					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)
					default:dismissNotification(data.notificationData.id)

					v(joinSquad(
						jsonDecode.squadId,
						v3.setSquadPrompt,
						v3.fireSquadAnalytics,
						v3.squadLocation,
						not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v5
					))
				end
			end
		)

		return function()
			callback()
		end
	end

	local fireSquadAnalytics = v3.fireSquadAnalytics
	local setSquadPrompt = v3.setSquadPrompt
	local squadLocation = v3.squadLocation
	local v9

	if FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
		v9 = v5
	end

	useEffect(fn, { v8, v, joinSquad, fireSquadAnalytics, setSquadPrompt, squadLocation, v9 })

	local useEffect2 = React.useEffect
	local function fn2()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadInvitationV2,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.actionEventParams
				then
					local jsonDecode = HttpService:JSONDecode(data.visualItem.actionEventParams)

					if data.visualItem.visualItemName == "view" and v3.showGroupOSADialog then
						default:dismissNotification(data.notificationData.id)
						v3.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v8,
							toastAction = SquadToastActionsAndStates.SquadInviteViewOsa,
							toastType = SquadToastType.SquadInviteV2
						})

						v3.showGroupOSADialog(jsonDecode.chatId, function()
							v(joinSquad(
								jsonDecode.squadId,
								v3.setSquadPrompt,
								v3.fireSquadAnalytics,
								v3.squadLocation,
								not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v5
							))
						end, function() end)
					elseif data.visualItem.visualItemName == "join" then
						default:dismissNotification(data.notificationData.id)
						v3.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v8,
							toastAction = SquadToastActionsAndStates.SquadInviteAccept,
							toastType = SquadToastType.SquadInviteV2
						})

						v(joinSquad(
							jsonDecode.squadId,
							v3.setSquadPrompt,
							v3.fireSquadAnalytics,
							v3.squadLocation,
							not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v5
						))
					end
				end
			end
		)

		return function()
			callback()
		end
	end

	local fireSquadAnalytics2 = v3.fireSquadAnalytics
	local setSquadPrompt2 = v3.setSquadPrompt
	local showGroupOSADialog = v3.showGroupOSADialog
	local squadLocation2 = v3.squadLocation
	local v10

	if FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
		v10 = v5
	end

	useEffect2(fn2, {
		v8,
		v,
		joinSquad,
		fireSquadAnalytics2,
		setSquadPrompt2,
		showGroupOSADialog,
		squadLocation2,
		v10
	})

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadInvitation,
			function(p)
				if v5 and not default2:isSnoozedNotificationType(p.notificationType) then
					soundManager:PlaySound(Sounds.PartyToast.Name)
				end
			end
		)

		return function()
			if callback then
				callback()
			end
		end
	end, { v5 })
	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.Display,
			NotificationTypeEnum.SquadInvitationV2,
			function(p)
				if v5 and not default2:isSnoozedNotificationType(p.notificationType) then
					soundManager:PlaySound(Sounds.PartyToast.Name)
				end
			end
		)

		return function()
			if callback then
				callback()
			end
		end
	end, { v5 })

	React.useEffect(function()
		local connection = default:listenToDisplayNotification(function(data)
			if not data then
				return
			end

			if
				(data.notificationType == NotificationTypeEnum.SquadInvitation or data.notificationType == NotificationTypeEnum.SquadInvitationV2 or data.notificationType == NotificationTypeEnum.SquadExperienceInvitation or data.notificationType == NotificationTypeEnum.SquadJoinRequestPrompt or data.notificationType == NotificationTypeEnum.SquadAcceptJoinRequest)
				and not v5
			then
				default:dismissNotification(data.notificationId)
			elseif v2 <= 0 then
				if
					data.notificationId
					and (data.notificationType == NotificationTypeEnum.SquadInvitation or data.notificationType == NotificationTypeEnum.SquadInvitationV2 or data.notificationType == NotificationTypeEnum.SquadExperienceInvitation)
				then
					default:dismissNotification(data.notificationId)
				end
			elseif
				(data.notificationType == NotificationTypeEnum.SquadInvitation or data.notificationType == NotificationTypeEnum.SquadInvitationV2)
				and currentSquadId == HttpService:JSONDecode(data.lifecycleData).squadId
			then
				default:dismissNotification(data.notificationId)
			end
		end)

		return function()
			connection:Disconnect()
		end
	end, { currentSquadId, v2, v5 })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadJoinRequestPrompt,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "RequestToJoinParty"
					and data.visualItem.actionEventParams
				then
					v3.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v8,
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
	end, { v8, v3.fireSquadAnalytics })

	React.useEffect(function()
		local callback = LifecycleEvents:RegisterCallback(
			LifecycleEvents.ToastEvents.UserAction,
			NotificationTypeEnum.SquadAcceptJoinRequest,
			function(data)
				if
					data
					and data.userActionType == "click"
					and data.notificationData
					and data.visualItem
					and data.visualItem.eventName == "AcceptPartyJoinRequest"
					and data.visualItem.actionEventParams
				then
					v3.fireSquadAnalytics(EventNames.SquadToastActions, {
						parentChannelId = v8,
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
	end, { v8, v3.fireSquadAnalytics })

	if GetFFlagEnableCrossExpVoice() and FFlagPartyVoiceBlockSync then
		local current = useSelector((React.useCallback(function(p)
			return p.Squad.UserBlocking.isBlockedByMe
		end, {})))

		local ref = React.useRef({})
		React.useEffect(function()
			if ref.current == current then
				return
			end

			for k, v11 in pairs(current) do
				local v12 = ref.current[k] or false

				if v11 and not v12 then
					CrossExperienceVoiceManager.default:blockVoiceParticipant(k)
				elseif not v11 and v12 then
					CrossExperienceVoiceManager.default:unblockVoiceParticipant(k)
				end
			end

			ref.current = current
		end, { current })
	end

	if GetFFlagEnableCrossExpVoice() then
		if FIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			useCrossExperienceVoice({ handleRCCConnectionTimeout = true })
		else
			useCrossExperienceVoice()
		end

		local v11 = useCrossExperienceVoiceConnector()
		useOnSquadEnded(function()
			v11()
		end)
	end

	local useEffect3 = React.useEffect
	local function fn3()
		if not (FFlagReadAppChatFetchingVariable and v6) and not v5 and currentSquadId ~= "" then
			if defineFastFlag then
				v(leaveSquad(
					nil,
					v3.setSquadPrompt,
					nil,
					v3.squadLocation,
					not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v5
				))
			else
				v(CurrentSquadUpdated(nil))
			end
		end
	end

	local v11

	if FFlagReadAppChatFetchingVariable then
		v11 = v6
	end

	local setSquadPrompt3

	if defineFastFlag then
		setSquadPrompt3 = v3.setSquadPrompt
	end

	local v12

	if defineFastFlag then
		v12 = v3.squadLocation
	end

	useEffect3(fn3, { v5, currentSquadId, v11, setSquadPrompt3, v12 })

	if FFlagAppChatNavigateBackIfOSAUnacknowledged and not FFlagAppChatShowOSAOnPageEntry then
		local v13 = v3.useGetConversationFromId(v8)
		local shouldShowOSAForConversation = v3.shouldShowOSAForConversation(v13)

		React.useEffect(function()
			if shouldShowOSAForConversation and currentSquadId ~= "" then
				v(leaveSquad(nil, v3.setSquadPrompt, nil, v3.squadLocation, true))
			end
		end, { shouldShowOSAForConversation, currentSquadId, v3.setSquadPrompt, v3.squadLocation })
	end

	local v13 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1

	local v14 = FFlagEnableSquadRegroupExperimentation

	if v14 then
		if v3.squadLocation == SquadLocationEnum.InExperience then
			v14 = v13 and v7 and v7.selfPermissions and v7.selfPermissions.canSeeRegroupPromptToast and #v7.members > 1
		else
			v14 = false
		end
	end

	React.useEffect(function()
		if not FFlagEnableSquadRegroupExperimentation then
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
		if FFlagEnableSquadRegroupExperimentation then
			local activeNotifId = RegroupPromptNotificationState.getActiveNotifId()
			local activeSquadId = RegroupPromptNotificationState.getActiveSquadId()

			if activeNotifId ~= nil and currentSquadId ~= activeSquadId then
				RegroupPromptNotificationState.dismissNotification(activeNotifId)
			end
		end
	end, { currentSquadId })

	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		SquadLifecycleEventReceiver = React.createElement(SquadLifecycleEventReceiver, {
			currentSquadId = currentSquadId
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
	local squadParentChannelEventReceiver

	if v7 then
		squadParentChannelEventReceiver = React.createElement(SquadParentChannelEventReceiver, {
			currentParentChannelId = v7.parentChannelId
		})
	end

	children.SquadParentChannelEventReceiver = squadParentChannelEventReceiver
	local squadMemberStatusEventReceiver

	if
		(SquadUnifyCoplayExperimentation.getOneOnOnePartyCreationEnabled() or SquadUnifyCoplayExperimentation.getMultiInvitePartyCreationEnabled())
		and v3.squadLocation == SquadLocationEnum.InExperience
	then
		squadMemberStatusEventReceiver = React.createElement(SquadMemberStatusEventReceiver)
	end

	children.SquadMemberStatusEventReceiver = squadMemberStatusEventReceiver
	local squadAppChatEventReceiver

	if not (FFlagSquadAppChatRTNFix or v4 == SquadRootViewType.None) then
		local createElement2 = React.createElement
		local conversationId

		if v7 then
			conversationId = v7.parentChannelId
		end

		squadAppChatEventReceiver = createElement2(SquadAppChatEventReceiver, {
			conversationId = conversationId
		})
	end

	children.SquadAppChatEventReceiver = squadAppChatEventReceiver

	children.SquadExperienceInviteEventReceiver = React.createElement(SquadExperienceInviteEventReceiver, {
		currentSquadId = currentSquadId
	})
	local squadRccEventReceiver

	if v3.squadLocation == SquadLocationEnum.InExperience then
		squadRccEventReceiver = React.createElement(SquadRccEventReceiver, {
			currentSquadId = currentSquadId
		})
	end

	children.SquadRccEventReceiver = squadRccEventReceiver

	children.SquadStorageEventReceiver = React.createElement(SquadStorageEventReceiver)
	local createElement2 = React.createElement
	local v15

	if FFlagEnablePartyNudgeV1_DEV then
		v15 = SquadNudgeEventReceiver_NudgeV1Exp
	else
		v15 = SquadNudgeEventReceiver
	end

	children.SquadNudgeEventReceiver = createElement2(v15, {
		currentSquadId = currentSquadId,
		currentParentChannelId = v8
	})

	children.ScheduledSquadEventReceiver = React.createElement(ScheduledSquadEventReceiver)
	local squadRegroupPromptEventReceiver

	if v14 then
		squadRegroupPromptEventReceiver = React.createElement(SquadRegroupPromptEventReceiver, {
			currentSquadMembers = v7 and v7.members or {},
			currentSquadId = currentSquadId
		})
	end

	children.SquadRegroupPromptEventReceiver = squadRegroupPromptEventReceiver
	return createElement(fragment, nil, children)
end
