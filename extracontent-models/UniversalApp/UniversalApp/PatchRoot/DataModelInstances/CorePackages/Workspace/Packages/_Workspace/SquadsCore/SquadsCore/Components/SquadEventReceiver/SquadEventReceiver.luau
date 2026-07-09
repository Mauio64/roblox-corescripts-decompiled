local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ExperienceService = require(SquadsCoreParent.ExperienceService).ExperienceService
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
local CurrentSquadUpdated = require(SquadsCore.RoduxSquads).Actions.CurrentSquadUpdated
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
local CrossExperienceVoice = require(SquadsCoreParent.CrossExperienceVoice)
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local React = require(SquadsCoreParent.React)
local RoduxSquads = require(SquadsCoreParent.RoduxSquads)
local SharedFlags = require(SquadsCoreParent.SharedFlags)
local SoundManager = require(SquadsCoreParent.SoundManager)
local ToastNotification = require(SquadsCoreParent.ToastNotification)
local ToastNotificationsProtocol = require(SquadsCoreParent.ToastNotificationsProtocol)
local useCrossExperienceVoice = CrossExperienceVoice.Hooks.useCrossExperienceVoice
local useDispatch = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffectOnce = require(SquadsCoreParent.RoactUtils).Hooks.useEffectOnce
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local useSelector = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useSelector
local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector
local Sounds = SoundManager.Sounds
local SoundManager2 = SoundManager.SoundManager
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local FFlagPartyVoiceBlockSync = SharedFlags.FFlagPartyVoiceBlockSync
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FIntPartyVoiceJoinRequestPulseCheckTimeout = SharedFlags.FIntPartyVoiceJoinRequestPulseCheckTimeout
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local FFlagReadAppChatFetchingVariable = SharedFlags.FFlagReadAppChatFetchingVariable
local FFlagEnablePartyNudgeV1_DEV = SharedFlags.FFlagEnablePartyNudgeV1_DEV
local FFlagAppChatNavigateBackIfOSAUnacknowledged = SharedFlags.FFlagAppChatNavigateBackIfOSAUnacknowledged
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local FFlagEnableSquadRegroupServerCapacityCheck = SharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local FFlagEnableScheduledSquads = SharedFlags.FFlagEnableScheduledSquads
local FFlagEnableDialogAfterSquadJoin = SharedFlags.FFlagEnableDialogAfterSquadJoin
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default2 = ToastNotification.ToastNotificationSnoozeManager.default
local SquadUnifyCoplayExperimentation = require(SquadsCoreParent.SocialExperiments).SquadUnifyCoplayExperimentation
local v66 = game:DefineFastFlag("LeaveSquadIfChatDisabled", false)

return function() -- line: 81
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadSelector (copy), FFlagEnableSquadCoplayAnalytic (copy), useEffectOnce (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), EventNames (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), joinSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), FFlagEnableDialogAfterSquadJoin (copy), default2 (copy), SoundManager2 (copy), Sounds (copy), GetFFlagEnableCrossExpVoice (copy), FFlagPartyVoiceBlockSync (copy), useSelector (copy), CrossExperienceVoiceManager (copy), FIntPartyVoiceJoinRequestPulseCheckTimeout (copy), useCrossExperienceVoice (copy), useCrossExperienceVoiceConnector (copy), useOnSquadEnded (copy), FFlagReadAppChatFetchingVariable (copy), v66 (copy), leaveSquad (copy), CurrentSquadUpdated (copy), FFlagAppChatNavigateBackIfOSAUnacknowledged (copy), FFlagAppChatShowOSAOnPageEntry (copy), FFlagEnableSquadRegroupServerCapacityCheck (copy), Players (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadLocationEnum (copy), ExperienceService (copy), RegroupPromptNotificationState (copy), SquadLifecycleEventReceiver (copy), SquadParentChannelEventReceiver (copy), SquadUnifyCoplayExperimentation (copy), SquadMemberStatusEventReceiver (copy), FFlagSquadAppChatRTNFix (copy), SquadRootViewType (copy), SquadAppChatEventReceiver (copy), SquadExperienceInviteEventReceiver (copy), SquadRccEventReceiver (copy), SquadStorageEventReceiver (copy), FFlagEnablePartyNudgeV1_DEV (copy), SquadNudgeEventReceiver_NudgeV1Exp (copy), SquadNudgeEventReceiver (copy), FFlagEnableScheduledSquads (copy), ScheduledSquadEventReceiver (copy), SquadRegroupPromptEventReceiver (copy)
	local v67 = useDispatch()
	local v68 = tonumber(useLocalUserId()) or 0
	local v69 = React.useContext(SquadExternalContractContext)
	local v70 = v69.useSquadRootView()
	local v71 = v69.useIsChatEnabled()
	local v72 = v69.useIsLoadingChatSettings()
	local v73 = useCurrentSquadSelector()
	local v74 = (not v73 or not v73.squadId) and "" or v73.squadId
	local v75 = (not v73 or not v73.parentChannelId) and "" or v73.parentChannelId

	if FFlagEnableSquadCoplayAnalytic then
		useEffectOnce(function() -- line: 98
			-- upvalues: v73 (copy), logInExpCoplayTelemetry (copy), v74 (copy), v69 (copy), SquadCoplayJoin (copy)
			if v73 then
				logInExpCoplayTelemetry(v74, v73.members, v69.squadLocation, SquadCoplayJoin.ExperienceJoin, v69.fireSquadAnalytics)
			end
		end, {})
	end

	React.useEffect(function() -- line: 118
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), v67 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v71 (copy)
		local v84 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadInvitation, function(p1) -- line: 122
			-- upvalues: v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), v67 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v71 (copy)
			if p1 and (p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "JoinSquad" and p1.visualItem.actionEventParams) then
				v69.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v75,
					toastAction = SquadToastActionsAndStates.SquadInviteAccept,
					toastType = SquadToastType.SquadInvite
				})

				local data = HttpService:JSONDecode(p1.visualItem.actionEventParams)

				default:dismissNotification(p1.notificationData.id)
				v67(joinSquad(data.squadId, v69.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v69.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v69.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v71))
			end
		end)

		return function() -- line: 152
			-- upvalues: v84 (copy)
			v84()
		end
	end, {
		v75,
		v67,
		joinSquad,
		v69.fireSquadAnalytics,
		v69.setSquadPrompt,
		v69.squadLocation,
		if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v71
	})

	if FFlagEnableDialogAfterSquadJoin then
		React.useEffect(function() -- line: 167
			-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), v69 (copy), default (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v67 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v71 (copy)
			local v85 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadInvitationV2, function(p2) -- line: 171
				-- upvalues: HttpService (copy), v69 (copy), default (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v67 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v71 (copy)
				if p2 and (p2.userActionType == "click" and p2.notificationData and p2.visualItem and p2.visualItem.actionEventParams) then
					local data = HttpService:JSONDecode(p2.visualItem.actionEventParams)

					if p2.visualItem.visualItemName == "view" and v69.showGroupOSADialog then
						default:dismissNotification(p2.notificationData.id)
						v69.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v75,
							toastAction = SquadToastActionsAndStates.SquadInviteViewOsa,
							toastType = SquadToastType.SquadInviteV2
						})
						v69.showGroupOSADialog(data.chatId, function() -- line: 189
							-- upvalues: v67 (copy), joinSquad (copy), data (copy), v69 (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v71 (copy)
							v67(joinSquad(data.squadId, v69.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v69.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v69.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v71))
						end, function() -- line: 205
						end)

						return
					end

					if p2.visualItem.visualItemName == "join" then
						default:dismissNotification(p2.notificationData.id)
						v69.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v75,
							toastAction = SquadToastActionsAndStates.SquadInviteAccept,
							toastType = SquadToastType.SquadInviteV2
						})
						v67(joinSquad(data.squadId, v69.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v69.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v69.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v71))
					end
				end
			end)

			return function() -- line: 230
				-- upvalues: v85 (copy)
				v85()
			end
		end, {
			v75,
			v67,
			joinSquad,
			v69.fireSquadAnalytics,
			v69.setSquadPrompt,
			v69.showGroupOSADialog,
			v69.squadLocation,
			if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v71
		})
	end

	React.useEffect(function() -- line: 246
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v71 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
		local v86 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadInvitation, function(p3) -- line: 250
			-- upvalues: v71 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
			if v71 and not default2:isSnoozedNotificationType(p3.notificationType) then
				SoundManager2:PlaySound(Sounds.PartyToast.Name)
			end
		end)

		return function() -- line: 260
			-- upvalues: v86 (copy)
			if v86 then
				v86()
			end
		end
	end, { v71 })

	if FFlagEnableDialogAfterSquadJoin then
		React.useEffect(function() -- line: 269
			-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v71 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
			local v87 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadInvitationV2, function(p4) -- line: 273
				-- upvalues: v71 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
				if v71 and not default2:isSnoozedNotificationType(p4.notificationType) then
					SoundManager2:PlaySound(Sounds.PartyToast.Name)
				end
			end)

			return function() -- line: 283
				-- upvalues: v87 (copy)
				if v87 then
					v87()
				end
			end
		end, { v71 })
	end

	React.useEffect(function() -- line: 292
		-- upvalues: default (copy), NotificationTypeEnum (copy), FFlagEnableDialogAfterSquadJoin (copy), v71 (copy), v68 (copy), HttpService (copy), v74 (copy)
		local v88 = default:listenToDisplayNotification(function(p5) -- line: 294
			-- upvalues: NotificationTypeEnum (copy), FFlagEnableDialogAfterSquadJoin (copy), v71 (copy), default (copy), v68 (copy), HttpService (copy), v74 (copy)
			if not p5 then
				return
			end

			if (p5.notificationType == NotificationTypeEnum.SquadInvitation or (FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 or p5.notificationType == NotificationTypeEnum.SquadExperienceInvitation or p5.notificationType == NotificationTypeEnum.SquadJoinRequestPrompt or p5.notificationType == NotificationTypeEnum.SquadAcceptJoinRequest)) and not v71 then
				default:dismissNotification(p5.notificationId)

				return
			end

			if v68 <= 0 then
				if p5.notificationId and (p5.notificationType == NotificationTypeEnum.SquadInvitation or (FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 or p5.notificationType == NotificationTypeEnum.SquadExperienceInvitation)) then
					default:dismissNotification(p5.notificationId)
				end

				return
			end

			if p5.notificationType == NotificationTypeEnum.SquadInvitation or FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 then
				local data = HttpService:JSONDecode(p5.lifecycleData)

				if v74 == data.squadId then
					default:dismissNotification(p5.notificationId)
				end
			end
		end)

		return function() -- line: 347
			-- upvalues: v88 (copy)
			v88:Disconnect()
		end
	end, {
		v74,
		v68,
		v71
	})
	React.useEffect(function() -- line: 353
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
		local v89 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadJoinRequestPrompt, function(p6) -- line: 357
			-- upvalues: v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
			if p6 and (p6.userActionType == "click" and p6.notificationData and p6.visualItem and p6.visualItem.eventName == "RequestToJoinParty" and p6.visualItem.actionEventParams) then
				v69.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v75,
					toastAction = SquadToastActionsAndStates.RequestToJoinPartyAccept,
					toastType = SquadToastType.RequestToJoinParty
				})
				default:dismissNotification(p6.notificationData.id)
			end
		end)

		return function() -- line: 381
			-- upvalues: v89 (copy)
			v89()
		end
	end, {
		v75,
		v69.fireSquadAnalytics
	})
	React.useEffect(function() -- line: 387
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
		local v90 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadAcceptJoinRequest, function(p7) -- line: 391
			-- upvalues: v69 (copy), EventNames (copy), v75 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
			if p7 and (p7.userActionType == "click" and p7.notificationData and p7.visualItem and p7.visualItem.eventName == "AcceptPartyJoinRequest" and p7.visualItem.actionEventParams) then
				v69.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v75,
					toastAction = SquadToastActionsAndStates.AcceptPartyJoinRequestAccept,
					toastType = SquadToastType.AcceptPartyJoinRequest
				})
				default:dismissNotification(p7.notificationData.id)
			end
		end)

		return function() -- line: 415
			-- upvalues: v90 (copy)
			v90()
		end
	end, {
		v75,
		v69.fireSquadAnalytics
	})

	if GetFFlagEnableCrossExpVoice() and FFlagPartyVoiceBlockSync then
		local v76 = React.useCallback(function(p8) -- line: 423
			return p8.Squad.UserBlocking.isBlockedByMe
		end, {})
		local v77 = useSelector(v76)
		local v78 = React.useRef({})

		React.useEffect(function() -- line: 430
			-- upvalues: v78 (copy), v77 (copy), CrossExperienceVoiceManager (copy)
			if v78.current == v77 then
				return
			end

			for k, v in pairs(v77) do
				local v94 = v78.current[k] or false

				if v and not v94 then
					CrossExperienceVoiceManager.default:blockVoiceParticipant(k)
				elseif not v and v94 then
					CrossExperienceVoiceManager.default:unblockVoiceParticipant(k)
				end
			end

			v78.current = v77
		end, { v77 })
	end

	if GetFFlagEnableCrossExpVoice() then
		if FIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			useCrossExperienceVoice({
				handleRCCConnectionTimeout = true
			})
		else
			useCrossExperienceVoice()
		end

		local v79 = useCrossExperienceVoiceConnector()

		useOnSquadEnded(function() -- line: 459
			-- upvalues: v79 (copy)
			v79()
		end)
	end

	React.useEffect(function() -- line: 464
		-- upvalues: FFlagReadAppChatFetchingVariable (copy), v72 (copy), v71 (copy), v74 (copy), v66 (copy), v67 (copy), leaveSquad (copy), v69 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), CurrentSquadUpdated (copy)
		if (not FFlagReadAppChatFetchingVariable or not v72) and (not v71 and v74 ~= "") then
			if v66 then
				v67(leaveSquad(nil, v69.setSquadPrompt, nil, v69.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v71))

				return
			end

			v67(CurrentSquadUpdated(nil))
		end
	end, {
		v71,
		v74,
		if not FFlagReadAppChatFetchingVariable then nil else v72,
		if not v66 then nil else v69.setSquadPrompt,
		if not v66 then nil else v69.squadLocation
	})

	if FFlagAppChatNavigateBackIfOSAUnacknowledged and not FFlagAppChatShowOSAOnPageEntry then
		local v80 = v69.useGetConversationFromId(v75)
		local v81 = v69.shouldShowOSAForConversation(v80)

		React.useEffect(function() -- line: 497
			-- upvalues: v81 (copy), v74 (copy), v67 (copy), leaveSquad (copy), v69 (copy)
			if v81 and v74 ~= "" then
				v67(leaveSquad(nil, v69.setSquadPrompt, nil, v69.squadLocation, true))
			end
		end, {
			v81,
			v74,
			v69.setSquadPrompt,
			v69.squadLocation
		})
	end

	local v82 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1
	local v83 = FFlagEnableSquadRegroupExperimentation and (v69.squadLocation == SquadLocationEnum.InExperience and (v82 and (v73 and (v73.selfPermissions and (v73.selfPermissions.canSeeRegroupPromptToast and #v73.members > 1)))))

	React.useEffect(function() -- line: 521
		-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), ExperienceService (copy), RegroupPromptNotificationState (copy)
		if not FFlagEnableSquadRegroupExperimentation then
			return function() -- line: 523
			end
		end

		local v95 = ExperienceService:RegisterForExperienceLeave(function() -- line: 526
			-- upvalues: RegroupPromptNotificationState (copy)
			local v108 = RegroupPromptNotificationState.getActiveNotifId()

			RegroupPromptNotificationState.dismissNotification(v108)
		end)

		return function() -- line: 531
			-- upvalues: v95 (copy)
			if v95 and v95.Disconnect then
				v95:Disconnect()
			end
		end
	end, {})
	React.useEffect(function() -- line: 538
		-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), RegroupPromptNotificationState (copy), v74 (copy)
		if FFlagEnableSquadRegroupExperimentation then
			local v96 = RegroupPromptNotificationState.getActiveNotifId()
			local v97 = RegroupPromptNotificationState.getActiveSquadId()

			if v96 ~= nil and v97 ~= v74 then
				RegroupPromptNotificationState.dismissNotification(v96)
			end
		end
	end, { v74 })

	return React.createElement(React.Fragment, nil, {
		SquadLifecycleEventReceiver = React.createElement(SquadLifecycleEventReceiver, {
			currentSquadId = v74
		}),
		SquadParentChannelEventReceiver = if not v73 then nil else React.createElement(SquadParentChannelEventReceiver, {
			currentParentChannelId = v73.parentChannelId
		}),
		SquadMemberStatusEventReceiver = if not SquadUnifyCoplayExperimentation.getOneOnOnePartyCreationEnabled() and not SquadUnifyCoplayExperimentation.getMultiInvitePartyCreationEnabled() or v69.squadLocation ~= SquadLocationEnum.InExperience then nil else React.createElement(SquadMemberStatusEventReceiver),
		SquadAppChatEventReceiver = if FFlagSquadAppChatRTNFix or v70 == SquadRootViewType.None then nil else React.createElement(SquadAppChatEventReceiver, {
			conversationId = if not v73 then nil else v73.parentChannelId
		}),
		SquadExperienceInviteEventReceiver = React.createElement(SquadExperienceInviteEventReceiver, {
			currentSquadId = v74
		}),
		SquadRccEventReceiver = if v69.squadLocation ~= SquadLocationEnum.InExperience then nil else React.createElement(SquadRccEventReceiver, {
			currentSquadId = v74
		}),
		SquadStorageEventReceiver = React.createElement(SquadStorageEventReceiver),
		SquadNudgeEventReceiver = React.createElement(if not FFlagEnablePartyNudgeV1_DEV then SquadNudgeEventReceiver else SquadNudgeEventReceiver_NudgeV1Exp, {
			currentSquadId = v74,
			currentParentChannelId = v75
		}),
		ScheduledSquadEventReceiver = if not FFlagEnableScheduledSquads then nil else React.createElement(ScheduledSquadEventReceiver),
		SquadRegroupPromptEventReceiver = if not v83 then nil else React.createElement(SquadRegroupPromptEventReceiver, {
			currentSquadMembers = v73 and v73.members or {},
			currentSquadId = v74
		})
	})
end
