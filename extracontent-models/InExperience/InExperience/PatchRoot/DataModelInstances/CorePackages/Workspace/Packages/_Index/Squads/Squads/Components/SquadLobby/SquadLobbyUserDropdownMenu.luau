local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local SquadsParent = Squads.Parent
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local ExperienceService = require(SquadsParent.ExperienceService)
local FocusNavigationUtils = require(SquadsParent.FocusNavigationUtils)
local InputHandlers = require(SquadsParent.InputHandlers)
local UIBlox = require(SquadsParent.UIBlox)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)

require(Squads.Common.ModelTypes)

local Cryo = dependencies.Cryo
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local React = dependencies.React
local SharedFlags = dependencies.SharedFlags
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local v16 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v17 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.DataHydration).Presence.PresenceEnums.PresenceType
local Images = UIBlox.App.ImageSet.Images
local ModalBottomSheet = UIBlox.ModalBottomSheet
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useStore = dependencies.Hooks.useStore
local useSelector = dependencies.Hooks.useSelector
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useSquadUserDropdownMenuButtons = require(Squads.Hooks.useSquadUserDropdownMenuButtons)
local GameParams = ExperienceService.GameParams
local ExperienceService2 = ExperienceService.ExperienceService
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadLocationEnum = require(SquadsParent.SquadsCore.Enums).SquadLocationEnum
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local Constants = require(SquadsParent.SquadsCore.Constants)
local useIsLocalPlayerPartyVoiceEligible = require(SquadsParent.SquadsCore.Hooks).useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = require(SquadsParent.SquadsCore.Hooks).useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = require(SquadsParent.SquadsCore.Hooks).useIsCurrentSquadPartyVoiceEligible
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local getFFlagEnableCrossExpVoiceAbuseReport = SharedFlags.getFFlagEnableCrossExpVoiceAbuseReport
local FFlagEnableSquadUserCardHoverFix = SharedFlags.FFlagEnableSquadUserCardHoverFix
local FFlagSquadLaunchExperienceMobileFix = SharedFlags.FFlagSquadLaunchExperienceMobileFix
local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local v47 = Images["icons/common/play"]
local v48 = Images["icons/menu/profile"]
local v49 = Images["icons/actions/feedback"]
local v50 = Images["icons/actions/leave"]
local v51 = Images["icons/controls/headphoneDeafen_small"]
local v52 = Images["icons/controls/microphoneMute"]
local v53 = Images["icons/controls/microphone"]
local t1 = {
	isInExperience = false,
	parentChannelId = "",
	userId = "",
	onDismiss = function() -- line: 110
	end,
	openViewProfile = function() -- line: 111
	end,
	openVoiceAbuseReport = function() -- line: 112
	end
}

return function(t2: {[any]: any}) -- line: 117
	-- upvalues: Cryo (copy), t1 (copy), React (copy), SquadExternalContractContext (copy), useDispatch (copy), useLocalUserId (copy), useStore (copy), useVoiceStatus (copy), FFlagEnableSquadUserCardHoverFix (copy), useSquadUserDropdownMenuButtons (copy), useIsParticipantMutedLocally (copy), useLocalization (copy), Constants (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SquadPromptType (copy), GetFFlagEnableCrossExpVoice (copy), useBackgroundExperience (copy), useParticipants (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), FFlagSquadsPresenceStoreMigration (copy), v16 (copy), useSelector (copy), v17 (copy), PresenceType (copy), GameParams (copy), FFlagSquadLaunchExperienceMobileFix (copy), SquadLocationEnum (copy), ExperienceService2 (copy), v51 (copy), v47 (copy), v50 (copy), v48 (copy), v49 (copy), v52 (copy), v53 (copy), default (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusNavigableSurfaceIdentifierEnum (copy), ModalBottomSheet (copy)
	local v56 = Cryo.Dictionary.union(t1, t2)
	local v57 = React.useContext(SquadExternalContractContext)
	local v58 = useDispatch()
	local v59 = useLocalUserId()
	local v60 = useStore()
	local v61 = useVoiceStatus()
	local v62 = if not FFlagEnableSquadUserCardHoverFix then nil else useSquadUserDropdownMenuButtons(v56.userId, v56.isInExperience)
	local v63 = useIsParticipantMutedLocally(tonumber(v56.userId) or -1)
	local v64 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		viewProfileText = "Feature.Chat.Label.ViewProfile",
		reportUserText = "Feature.Chat.Action.ReportUser",
		removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
		voiceIneligibleText = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible",
		muteVoiceButtonText = "Feature.Chat.Action.MuteVoice",
		unmuteVoiceButtonText = "Feature.Chat.Action.UnmuteVoice"
	})
	local v65 = v57.useGetConversationFromId(v56.parentChannelId)
	local v66 = React.useMemo(function() -- line: 142
		-- upvalues: v65 (copy), Constants (copy), v59 (copy)
		return v65 and (v65.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v65.initiator == v59)
	end, {
		v65,
		v59
	})
	local v67 = React.useCallback(function() -- line: 148
		-- upvalues: v57 (copy), EventNames (copy), v56 (copy), SquadPartySheetActionEnum (copy), v61 (copy)
		v57.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v56.parentChannelId,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = v61
		})
		v56.openViewProfile()
	end, {
		v56.parentChannelId,
		v56.openViewProfile,
		v57.fireSquadAnalytics,
		v61
	})
	local v68 = React.useCallback(function() -- line: 163
		-- upvalues: v57 (copy), EventNames (copy), v56 (copy), SquadPartySheetActionEnum (copy), v61 (copy), v60 (copy), SquadPromptType (copy), v58 (copy)
		v57.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v56.parentChannelId,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = v61
		})
		v57.setSquadPrompt(v60, {
			promptType = SquadPromptType.RemoveFromChat,
			onConfirm = function() -- line: 172
				-- upvalues: v56 (copy), v57 (copy), EventNames (copy), SquadPartySheetActionEnum (copy), v61 (copy), v58 (copy)
				if v56.userId ~= "" and v56.parentChannelId ~= "" then
					v57.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v56.parentChannelId,
						actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
						voiceStatus = v61
					})

					return v57.removeUserFromParentChannel(v58, v56.parentChannelId, v56.userId)
				end

				return nil
			end
		})
	end, {
		v58,
		v56.userId,
		v56.parentChannelId,
		v57.fireSquadAnalytics,
		v57.setSquadPrompt,
		v57.removeUserFromParentChannel,
		v61
	})
	local u69 = nil
	local u70 = nil
	local u71 = nil
	local t3 = {}
	local u73 = nil
	local u74 = nil

	if GetFFlagEnableCrossExpVoice() then
		u69 = useBackgroundExperience()
		u71 = useParticipants() or {}
		t3 = React.useMemo(function() -- line: 207
			-- upvalues: u71 (ref)
			local t4 = {}

			for _, v in pairs(u71) do
				table.insert(t4, v.userId)
			end

			return t4
		end, { u71 })
		u73 = React.useMemo(function() -- line: 214
			-- upvalues: u69 (ref)
			if u69 then
				return u69.voiceChannelId
			end

			return nil
		end, { u69 })
		u74 = React.useMemo(function() -- line: 217
			-- upvalues: u69 (ref)
			if u69 then
				return u69.voiceSessionId
			end

			return nil
		end, { u69 })

		if not FFlagEnableSquadUserCardHoverFix then
			local v75 = if not v56.userId then nil else tonumber(v56.userId)

			if v75 then
				local v76 = useIsLocalPlayerPartyVoiceEligible()
				local v77 = useIsUserPartyVoiceEligible(v75)

				u70 = useIsCurrentSquadPartyVoiceEligible() == true and (v76 and not v77)
			end
		end
	end

	local v78 = React.useCallback(function(p1) -- line: 234
		-- upvalues: v56 (copy)
		return p1.Squad.Presence.byUserId[v56.userId]
	end, { v56.userId })
	local v79 = if not FFlagSquadsPresenceStoreMigration then useSelector(v78) else v16((tostring(v56.userId)))
	local v80 = React.useMemo(function() -- line: 242
		-- upvalues: FFlagEnableSquadUserCardHoverFix (copy), v62 (copy), v79 (copy), FFlagSquadsPresenceStoreMigration (copy), v17 (copy), PresenceType (copy)
		if FFlagEnableSquadUserCardHoverFix then
			local v87 = false

			if table.find(v62, "JoinButton") ~= nil then
				v87 = v79

				if v87 then
					v87 = false

					if v79.userPresenceType == if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v17.InGame then
						if FFlagSquadsPresenceStoreMigration then
							return v79.placeId ~= ""
						end

						v87 = v79.placeId
					end
				end
			end

			return v87
		end

		local v88 = v79

		if v88 then
			v88 = false

			if v79.userPresenceType == if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v17.InGame then
				if FFlagSquadsPresenceStoreMigration then
					return v79.placeId ~= ""
				end

				v88 = v79.placeId
			end
		end

		return v88
	end, {
		v79,
		v62
	})
	local v81 = React.useCallback(function() -- line: 259
		-- upvalues: v80 (copy), GameParams (copy), v56 (copy), FFlagSquadsPresenceStoreMigration (copy), v79 (copy), FFlagSquadLaunchExperienceMobileFix (copy), v57 (copy), SquadLocationEnum (copy), ExperienceService2 (copy)
		if v80 then
			local v89 = GameParams.fromUserId(v56.userId, if not FFlagSquadsPresenceStoreMigration then v79.placeId else v79 and v79.placeId)

			if v56.isInExperience and FFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			local s1 = "SquadLobby"

			if v57.squadLocation == SquadLocationEnum.UniversalApp then
				s1 = "SquadLobbyFromUA"
			elseif v57.squadLocation == SquadLocationEnum.InExperience then
				s1 = "SquadLobbyFromInExp"
			end

			ExperienceService2:LaunchExperience(v89, s1, nil)
		end
	end, {
		v80,
		v57.squadLocation,
		v56.isInExperience,
		v56.userId,
		v79
	})
	local v82 = if not FFlagEnableSquadUserCardHoverFix then React.useMemo(function() -- line: 379
		-- upvalues: v59 (copy), v56 (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), u73 (ref), u70 (ref), v51 (copy), v64 (copy), v80 (copy), v47 (copy), v81 (copy), v48 (copy), v67 (copy), v49 (copy), u74 (ref), t3 (ref), v66 (copy), v50 (copy), v68 (copy)
		local v96 = tostring(v59) == v56.userId
		local isInExperience = v56.isInExperience
		local v98 = getFFlagEnableCrossExpVoiceAbuseReport() and (not not u73 and not v96)
		local t5 = {}

		if u70 then
			table.insert(t5, {
				stayOnActivated = true,
				icon = v51,
				text = v64.voiceIneligibleText
			})
		end

		if v80 then
			table.insert(t5, {
				icon = v47,
				text = v64.joinButtonText,
				onActivated = v81
			})
		end

		if not isInExperience then
			table.insert(t5, {
				icon = v48,
				text = v64.viewProfileText,
				onActivated = v67
			})
		end

		if v98 then
			table.insert(t5, {
				icon = v49,
				text = v64.reportUserText,
				onActivated = function() -- line: 416
					-- upvalues: v59 (copy), v56 (copy), u73 (ref), u74 (ref), t3 (ref)
					local t6 = {
						submitterUserId = tostring(v59),
						abuserUserId = v56.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = u73,
						voiceSessionId = u74,
						voiceUserIds = t3,
						voiceUserCount = #t3
					}

					v56.openSquadVoiceAbuseReport(t6)
				end
			})
		end

		if v66 then
			table.insert(t5, {
				icon = v50,
				text = v64.removeFromGroupText,
				onActivated = v68
			})
		end

		return t5
	end, {
		v56.isInExperience,
		v56.userId,
		v56.openSquadVoiceAbuseReport,
		v64.joinButtonText,
		v64.removeFromGroupText,
		v64.reportUserText,
		v64.viewProfileText,
		v64.voiceIneligibleText,
		u70,
		v59,
		u73,
		u74,
		t3,
		v68,
		v80,
		v66,
		v81,
		v67
	}) else React.useMemo(function() -- line: 289
		-- upvalues: v51 (copy), v64 (copy), v47 (copy), v81 (copy), v50 (copy), v68 (copy), v48 (copy), v67 (copy), v49 (copy), v59 (copy), v56 (copy), u73 (ref), u74 (ref), t3 (ref), v63 (copy), v52 (copy), v53 (copy), default (copy), v62 (copy)
		local t8 = {
			VoiceIneligibleButton = {
				stayOnActivated = true,
				icon = v51,
				text = v64.voiceIneligibleText
			},
			JoinButton = {
				icon = v47,
				text = v64.joinButtonText,
				onActivated = v81
			},
			RemoveUserButton = {
				icon = v50,
				text = v64.removeFromGroupText,
				onActivated = v68
			},
			ViewProfileButton = {
				icon = v48,
				text = v64.viewProfileText,
				onActivated = v67
			},
			ReportButton = {
				icon = v49,
				text = v64.reportUserText,
				onActivated = function() -- line: 314
					-- upvalues: v59 (copy), v56 (copy), u73 (ref), u74 (ref), t3 (ref)
					local t7 = {
						submitterUserId = tostring(v59),
						abuserUserId = v56.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = u73,
						voiceSessionId = u74,
						voiceUserIds = t3,
						voiceUserCount = #t3
					}

					v56.openSquadVoiceAbuseReport(t7)
				end
			},
			MuteVoiceButton = {
				icon = if not v63 then v53 else v52,
				text = if not v63 then v64.muteVoiceButtonText else v64.unmuteVoiceButtonText,
				onActivated = function() -- line: 332
					-- upvalues: v56 (copy), v63 (copy), default (copy)
					local num = tonumber(v56.userId)

					if num then
						if v63 then
							default:unmuteVoiceParticipant(num)

							return
						end

						default:muteVoiceParticipant(num)

						return
					end

					warn("Invalid userId: " .. tostring(v56.userId))
				end
			}
		}
		local t9 = {}

		for _, v94 in v62 do
			local v95 = t8[v94]

			if v95 then
				table.insert(t9, v95)
			end
		end

		return t9
	end, {
		v56.userId,
		v56.openSquadVoiceAbuseReport,
		v64.joinButtonText,
		v64.removeFromGroupText,
		v64.reportUserText,
		v64.viewProfileText,
		v64.voiceIneligibleText,
		v64.muteVoiceButtonText,
		v64.unmuteVoiceButtonText,
		v59,
		u73,
		u74,
		t3,
		v68,
		v62,
		v81,
		v67,
		v63
	})

	if #v82 > 0 then
		return React.createElement(FocusNavigableSurfaceWrapper, {
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p2) -- line: 465
						-- upvalues: v56 (copy)
						v56.onDismiss()
						p2:cancel()
					end)
				}
			},
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ModalBottomSheet, {
			bottomGap = 20,
			screenWidth = 400,
			showImages = true,
			buttonModels = v82,
			onDismiss = function() -- line: 479
				-- upvalues: v56 (copy)
				v56.onDismiss()
			end
		}) })
	end

	v56.onDismiss()

	return nil
end
