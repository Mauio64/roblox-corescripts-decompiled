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
local FFlagEnableDialogAfterSquadJoin = SharedFlags.FFlagEnableDialogAfterSquadJoin
local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local LifecycleEvents = ToastNotification.LifecycleEvents
local NotificationTypeEnum = ToastNotification.ToastNotificationTypeModule.NotificationTypeEnum
local default2 = ToastNotification.ToastNotificationSnoozeManager.default
local SquadUnifyCoplayExperimentation = require(SquadsCoreParent.SocialExperiments).SquadUnifyCoplayExperimentation
local v65 = game:DefineFastFlag("LeaveSquadIfChatDisabled", false)

return function() -- line: 80
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadSelector (copy), FFlagEnableSquadCoplayAnalytic (copy), useEffectOnce (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), LifecycleEvents (copy), NotificationTypeEnum (copy), EventNames (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), joinSquad (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), FFlagEnableDialogAfterSquadJoin (copy), default2 (copy), SoundManager2 (copy), Sounds (copy), GetFFlagEnableCrossExpVoice (copy), FFlagPartyVoiceBlockSync (copy), useSelector (copy), CrossExperienceVoiceManager (copy), FIntPartyVoiceJoinRequestPulseCheckTimeout (copy), useCrossExperienceVoice (copy), useCrossExperienceVoiceConnector (copy), useOnSquadEnded (copy), FFlagReadAppChatFetchingVariable (copy), v65 (copy), leaveSquad (copy), CurrentSquadUpdated (copy), FFlagAppChatNavigateBackIfOSAUnacknowledged (copy), FFlagAppChatShowOSAOnPageEntry (copy), FFlagEnableSquadRegroupServerCapacityCheck (copy), Players (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadLocationEnum (copy), ExperienceService (copy), RegroupPromptNotificationState (copy), SquadLifecycleEventReceiver (copy), SquadParentChannelEventReceiver (copy), SquadUnifyCoplayExperimentation (copy), SquadMemberStatusEventReceiver (copy), FFlagSquadAppChatRTNFix (copy), SquadRootViewType (copy), SquadAppChatEventReceiver (copy), SquadExperienceInviteEventReceiver (copy), SquadRccEventReceiver (copy), SquadStorageEventReceiver (copy), FFlagEnablePartyNudgeV1_DEV (copy), SquadNudgeEventReceiver_NudgeV1Exp (copy), SquadNudgeEventReceiver (copy), ScheduledSquadEventReceiver (copy), SquadRegroupPromptEventReceiver (copy)
	local v66 = useDispatch()
	local v67 = tonumber(useLocalUserId()) or 0
	local v68 = React.useContext(SquadExternalContractContext)
	local v69 = v68.useSquadRootView()
	local v70 = v68.useIsChatEnabled()
	local v71 = v68.useIsLoadingChatSettings()
	local v72 = useCurrentSquadSelector()
	local v73 = (not v72 or not v72.squadId) and "" or v72.squadId
	local v74 = (not v72 or not v72.parentChannelId) and "" or v72.parentChannelId

	if FFlagEnableSquadCoplayAnalytic then
		useEffectOnce(function() -- line: 97
			-- upvalues: v72 (copy), logInExpCoplayTelemetry (copy), v73 (copy), v68 (copy), SquadCoplayJoin (copy)
			if v72 then
				logInExpCoplayTelemetry(v73, v72.members, v68.squadLocation, SquadCoplayJoin.ExperienceJoin, v68.fireSquadAnalytics)
			end
		end, {})
	end

	React.useEffect(function() -- line: 117
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), v66 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v70 (copy)
		local v83 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadInvitation, function(p1) -- line: 121
			-- upvalues: v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), HttpService (copy), default (copy), v66 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v70 (copy)
			if p1 and (p1.userActionType == "click" and p1.notificationData and p1.visualItem and p1.visualItem.eventName == "JoinSquad" and p1.visualItem.actionEventParams) then
				v68.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v74,
					toastAction = SquadToastActionsAndStates.SquadInviteAccept,
					toastType = SquadToastType.SquadInvite
				})

				local data = HttpService:JSONDecode(p1.visualItem.actionEventParams)

				default:dismissNotification(p1.notificationData.id)
				v66(joinSquad(data.squadId, v68.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v68.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v68.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v70))
			end
		end)

		return function() -- line: 151
			-- upvalues: v83 (copy)
			v83()
		end
	end, {
		v74,
		v66,
		joinSquad,
		v68.fireSquadAnalytics,
		v68.setSquadPrompt,
		v68.squadLocation,
		if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v70
	})

	if FFlagEnableDialogAfterSquadJoin then
		React.useEffect(function() -- line: 166
			-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), HttpService (copy), v68 (copy), default (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v66 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v70 (copy)
			local v84 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadInvitationV2, function(p2) -- line: 170
				-- upvalues: HttpService (copy), v68 (copy), default (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), v66 (copy), joinSquad (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v70 (copy)
				if p2 and (p2.userActionType == "click" and p2.notificationData and p2.visualItem and p2.visualItem.actionEventParams) then
					local data = HttpService:JSONDecode(p2.visualItem.actionEventParams)

					if p2.visualItem.visualItemName == "view" and v68.showGroupOSADialog then
						default:dismissNotification(p2.notificationData.id)
						v68.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v74,
							toastAction = SquadToastActionsAndStates.SquadInviteViewOsa,
							toastType = SquadToastType.SquadInviteV2
						})
						v68.showGroupOSADialog(data.chatId, function() -- line: 188
							-- upvalues: v66 (copy), joinSquad (copy), data (copy), v68 (copy), FFlagEnableSquadCoplayAnalytic (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v70 (copy)
							v66(joinSquad(data.squadId, v68.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v68.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v68.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v70))
						end, function() -- line: 204
						end)

						return
					end

					if p2.visualItem.visualItemName == "join" then
						default:dismissNotification(p2.notificationData.id)
						v68.fireSquadAnalytics(EventNames.SquadToastActions, {
							parentChannelId = v74,
							toastAction = SquadToastActionsAndStates.SquadInviteAccept,
							toastType = SquadToastType.SquadInviteV2
						})
						v66(joinSquad(data.squadId, v68.setSquadPrompt, if not FFlagEnableSquadCoplayAnalytic then nil else v68.fireSquadAnalytics, if not FFlagEnableSquadCoplayAnalytic then nil else v68.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v70))
					end
				end
			end)

			return function() -- line: 229
				-- upvalues: v84 (copy)
				v84()
			end
		end, {
			v74,
			v66,
			joinSquad,
			v68.fireSquadAnalytics,
			v68.setSquadPrompt,
			v68.showGroupOSADialog,
			v68.squadLocation,
			if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v70
		})
	end

	React.useEffect(function() -- line: 245
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v70 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
		local v85 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadInvitation, function(p3) -- line: 249
			-- upvalues: v70 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
			if v70 and not default2:isSnoozedNotificationType(p3.notificationType) then
				SoundManager2:PlaySound(Sounds.PartyToast.Name)
			end
		end)

		return function() -- line: 259
			-- upvalues: v85 (copy)
			if v85 then
				v85()
			end
		end
	end, { v70 })

	if FFlagEnableDialogAfterSquadJoin then
		React.useEffect(function() -- line: 268
			-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v70 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
			local v86 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.Display, NotificationTypeEnum.SquadInvitationV2, function(p4) -- line: 272
				-- upvalues: v70 (copy), default2 (copy), SoundManager2 (copy), Sounds (copy)
				if v70 and not default2:isSnoozedNotificationType(p4.notificationType) then
					SoundManager2:PlaySound(Sounds.PartyToast.Name)
				end
			end)

			return function() -- line: 282
				-- upvalues: v86 (copy)
				if v86 then
					v86()
				end
			end
		end, { v70 })
	end

	React.useEffect(function() -- line: 291
		-- upvalues: default (copy), NotificationTypeEnum (copy), FFlagEnableDialogAfterSquadJoin (copy), v70 (copy), v67 (copy), HttpService (copy), v73 (copy)
		local v87 = default:listenToDisplayNotification(function(p5) -- line: 293
			-- upvalues: NotificationTypeEnum (copy), FFlagEnableDialogAfterSquadJoin (copy), v70 (copy), default (copy), v67 (copy), HttpService (copy), v73 (copy)
			if not p5 then
				return
			end

			if (p5.notificationType == NotificationTypeEnum.SquadInvitation or (FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 or p5.notificationType == NotificationTypeEnum.SquadExperienceInvitation or p5.notificationType == NotificationTypeEnum.SquadJoinRequestPrompt or p5.notificationType == NotificationTypeEnum.SquadAcceptJoinRequest)) and not v70 then
				default:dismissNotification(p5.notificationId)

				return
			end

			if v67 <= 0 then
				if p5.notificationId and (p5.notificationType == NotificationTypeEnum.SquadInvitation or (FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 or p5.notificationType == NotificationTypeEnum.SquadExperienceInvitation)) then
					default:dismissNotification(p5.notificationId)
				end

				return
			end

			if p5.notificationType == NotificationTypeEnum.SquadInvitation or FFlagEnableDialogAfterSquadJoin and p5.notificationType == NotificationTypeEnum.SquadInvitationV2 then
				local data = HttpService:JSONDecode(p5.lifecycleData)

				if v73 == data.squadId then
					default:dismissNotification(p5.notificationId)
				end
			end
		end)

		return function() -- line: 346
			-- upvalues: v87 (copy)
			v87:Disconnect()
		end
	end, {
		v73,
		v67,
		v70
	})
	React.useEffect(function() -- line: 352
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
		local v88 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadJoinRequestPrompt, function(p6) -- line: 356
			-- upvalues: v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
			if p6 and (p6.userActionType == "click" and p6.notificationData and p6.visualItem and p6.visualItem.eventName == "RequestToJoinParty" and p6.visualItem.actionEventParams) then
				v68.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v74,
					toastAction = SquadToastActionsAndStates.RequestToJoinPartyAccept,
					toastType = SquadToastType.RequestToJoinParty
				})
				default:dismissNotification(p6.notificationData.id)
			end
		end)

		return function() -- line: 380
			-- upvalues: v88 (copy)
			v88()
		end
	end, {
		v74,
		v68.fireSquadAnalytics
	})
	React.useEffect(function() -- line: 386
		-- upvalues: LifecycleEvents (copy), NotificationTypeEnum (copy), v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
		local v89 = LifecycleEvents:RegisterCallback(LifecycleEvents.ToastEvents.UserAction, NotificationTypeEnum.SquadAcceptJoinRequest, function(p7) -- line: 390
			-- upvalues: v68 (copy), EventNames (copy), v74 (copy), SquadToastActionsAndStates (copy), SquadToastType (copy), default (copy)
			if p7 and (p7.userActionType == "click" and p7.notificationData and p7.visualItem and p7.visualItem.eventName == "AcceptPartyJoinRequest" and p7.visualItem.actionEventParams) then
				v68.fireSquadAnalytics(EventNames.SquadToastActions, {
					parentChannelId = v74,
					toastAction = SquadToastActionsAndStates.AcceptPartyJoinRequestAccept,
					toastType = SquadToastType.AcceptPartyJoinRequest
				})
				default:dismissNotification(p7.notificationData.id)
			end
		end)

		return function() -- line: 414
			-- upvalues: v89 (copy)
			v89()
		end
	end, {
		v74,
		v68.fireSquadAnalytics
	})

	if GetFFlagEnableCrossExpVoice() and FFlagPartyVoiceBlockSync then
		local v75 = React.useCallback(function(p8) -- line: 422
			return p8.Squad.UserBlocking.isBlockedByMe
		end, {})
		local v76 = useSelector(v75)
		local v77 = React.useRef({})

		React.useEffect(function() -- line: 429
			-- upvalues: v77 (copy), v76 (copy), CrossExperienceVoiceManager (copy)
			if v77.current == v76 then
				return
			end

			for k, v in pairs(v76) do
				local v93 = v77.current[k] or false

				if v and not v93 then
					CrossExperienceVoiceManager.default:blockVoiceParticipant(k)
				elseif not v and v93 then
					CrossExperienceVoiceManager.default:unblockVoiceParticipant(k)
				end
			end

			v77.current = v76
		end, { v76 })
	end

	if GetFFlagEnableCrossExpVoice() then
		if FIntPartyVoiceJoinRequestPulseCheckTimeout > 0 then
			useCrossExperienceVoice({
				handleRCCConnectionTimeout = true
			})
		else
			useCrossExperienceVoice()
		end

		local v78 = useCrossExperienceVoiceConnector()

		useOnSquadEnded(function() -- line: 458
			-- upvalues: v78 (copy)
			v78()
		end)
	end

	React.useEffect(function() -- line: 463
		-- upvalues: FFlagReadAppChatFetchingVariable (copy), v71 (copy), v70 (copy), v73 (copy), v65 (copy), v66 (copy), leaveSquad (copy), v68 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), CurrentSquadUpdated (copy)
		if (not FFlagReadAppChatFetchingVariable or not v71) and (not v70 and v73 ~= "") then
			if v65 then
				v66(leaveSquad(nil, v68.setSquadPrompt, nil, v68.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v70))

				return
			end

			v66(CurrentSquadUpdated(nil))
		end
	end, {
		v70,
		v73,
		if not FFlagReadAppChatFetchingVariable then nil else v71,
		if not v65 then nil else v68.setSquadPrompt,
		if not v65 then nil else v68.squadLocation
	})

	if FFlagAppChatNavigateBackIfOSAUnacknowledged and not FFlagAppChatShowOSAOnPageEntry then
		local v79 = v68.useGetConversationFromId(v74)
		local v80 = v68.shouldShowOSAForConversation(v79)

		React.useEffect(function() -- line: 496
			-- upvalues: v80 (copy), v73 (copy), v66 (copy), leaveSquad (copy), v68 (copy)
			if v80 and v73 ~= "" then
				v66(leaveSquad(nil, v68.setSquadPrompt, nil, v68.squadLocation, true))
			end
		end, {
			v80,
			v73,
			v68.setSquadPrompt,
			v68.squadLocation
		})
	end

	local v81 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1
	local v82 = FFlagEnableSquadRegroupExperimentation and (v68.squadLocation == SquadLocationEnum.InExperience and (v81 and (v72 and (v72.selfPermissions and (v72.selfPermissions.canSeeRegroupPromptToast and #v72.members > 1)))))

	React.useEffect(function() -- line: 520
		-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), ExperienceService (copy), RegroupPromptNotificationState (copy)
		if not FFlagEnableSquadRegroupExperimentation then
			return function() -- line: 522
			end
		end

		local v94 = ExperienceService:RegisterForExperienceLeave(function() -- line: 525
			-- upvalues: RegroupPromptNotificationState (copy)
			local v107 = RegroupPromptNotificationState.getActiveNotifId()

			RegroupPromptNotificationState.dismissNotification(v107)
		end)

		return function() -- line: 530
			-- upvalues: v94 (copy)
			if v94 and v94.Disconnect then
				v94:Disconnect()
			end
		end
	end, {})
	React.useEffect(function() -- line: 537
		-- upvalues: FFlagEnableSquadRegroupExperimentation (copy), RegroupPromptNotificationState (copy), v73 (copy)
		if FFlagEnableSquadRegroupExperimentation then
			local v95 = RegroupPromptNotificationState.getActiveNotifId()
			local v96 = RegroupPromptNotificationState.getActiveSquadId()

			if v95 ~= nil and v96 ~= v73 then
				RegroupPromptNotificationState.dismissNotification(v95)
			end
		end
	end, { v73 })

	return React.createElement(React.Fragment, nil, {
		SquadLifecycleEventReceiver = React.createElement(SquadLifecycleEventReceiver, {
			currentSquadId = v73
		}),
		SquadParentChannelEventReceiver = if not v72 then nil else React.createElement(SquadParentChannelEventReceiver, {
			currentParentChannelId = v72.parentChannelId
		}),
		SquadMemberStatusEventReceiver = if not SquadUnifyCoplayExperimentation.getOneOnOnePartyCreationEnabled() and not SquadUnifyCoplayExperimentation.getMultiInvitePartyCreationEnabled() or v68.squadLocation ~= SquadLocationEnum.InExperience then nil else React.createElement(SquadMemberStatusEventReceiver),
		SquadAppChatEventReceiver = if FFlagSquadAppChatRTNFix or v69 == SquadRootViewType.None then nil else React.createElement(SquadAppChatEventReceiver, {
			conversationId = if not v72 then nil else v72.parentChannelId
		}),
		SquadExperienceInviteEventReceiver = React.createElement(SquadExperienceInviteEventReceiver, {
			currentSquadId = v73
		}),
		SquadRccEventReceiver = if v68.squadLocation ~= SquadLocationEnum.InExperience then nil else React.createElement(SquadRccEventReceiver, {
			currentSquadId = v73
		}),
		SquadStorageEventReceiver = React.createElement(SquadStorageEventReceiver),
		SquadNudgeEventReceiver = React.createElement(if not FFlagEnablePartyNudgeV1_DEV then SquadNudgeEventReceiver else SquadNudgeEventReceiver_NudgeV1Exp, {
			currentSquadId = v73,
			currentParentChannelId = v74
		}),
		ScheduledSquadEventReceiver = React.createElement(ScheduledSquadEventReceiver),
		SquadRegroupPromptEventReceiver = if not v82 then nil else React.createElement(SquadRegroupPromptEventReceiver, {
			currentSquadMembers = v72 and v72.members or {},
			currentSquadId = v73
		})
	})
end
