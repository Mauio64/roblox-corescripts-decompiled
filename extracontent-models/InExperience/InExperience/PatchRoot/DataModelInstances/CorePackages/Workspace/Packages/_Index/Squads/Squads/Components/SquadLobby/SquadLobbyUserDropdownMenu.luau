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
local v44 = Images["icons/common/play"]
local v45 = Images["icons/menu/profile"]
local v46 = Images["icons/actions/feedback"]
local v47 = Images["icons/actions/leave"]
local v48 = Images["icons/controls/headphoneDeafen_small"]
local v49 = Images["icons/controls/microphoneMute"]
local v50 = Images["icons/controls/microphone"]
local t1 = {
	isInExperience = false,
	parentChannelId = "",
	userId = "",
	onDismiss = function() -- line: 102
	end,
	openViewProfile = function() -- line: 103
	end,
	openVoiceAbuseReport = function() -- line: 104
	end
}

return function(t2: {[any]: any}) -- line: 109
	-- upvalues: Cryo (copy), t1 (copy), React (copy), SquadExternalContractContext (copy), useDispatch (copy), useLocalUserId (copy), useStore (copy), useVoiceStatus (copy), FFlagEnableSquadUserCardHoverFix (copy), useSquadUserDropdownMenuButtons (copy), useIsParticipantMutedLocally (copy), useLocalization (copy), Constants (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SquadPromptType (copy), GetFFlagEnableCrossExpVoice (copy), useBackgroundExperience (copy), useParticipants (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), useSelector (copy), PresenceType (copy), GameParams (copy), FFlagSquadLaunchExperienceMobileFix (copy), SquadLocationEnum (copy), ExperienceService2 (copy), v48 (copy), v44 (copy), v47 (copy), v45 (copy), v46 (copy), v49 (copy), v50 (copy), default (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), FocusNavigableSurfaceIdentifierEnum (copy), ModalBottomSheet (copy)
	local v53 = Cryo.Dictionary.union(t1, t2)
	local v54 = React.useContext(SquadExternalContractContext)
	local v55 = useDispatch()
	local v56 = useLocalUserId()
	local v57 = useStore()
	local v58 = useVoiceStatus()
	local v59 = if not FFlagEnableSquadUserCardHoverFix then nil else useSquadUserDropdownMenuButtons(v53.userId, v53.isInExperience)
	local v60 = useIsParticipantMutedLocally(tonumber(v53.userId) or -1)
	local v61 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		viewProfileText = "Feature.Chat.Label.ViewProfile",
		reportUserText = "Feature.Chat.Action.ReportUser",
		removeFromGroupText = "Feature.Chat.Action.RemoveFromGroup",
		voiceIneligibleText = "Feature.Squads.Label.UserDropdownMenuVoiceErrorUserIneligible",
		muteVoiceButtonText = "Feature.Chat.Action.MuteVoice",
		unmuteVoiceButtonText = "Feature.Chat.Action.UnmuteVoice"
	})
	local v62 = v54.useGetConversationFromId(v53.parentChannelId)
	local v63 = React.useMemo(function() -- line: 134
		-- upvalues: v62 (copy), Constants (copy), v56 (copy)
		return v62 and (v62.type == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and v62.initiator == v56)
	end, {
		v62,
		v56
	})
	local v64 = React.useCallback(function() -- line: 140
		-- upvalues: v54 (copy), EventNames (copy), v53 (copy), SquadPartySheetActionEnum (copy), v58 (copy)
		v54.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v53.parentChannelId,
			actionType = SquadPartySheetActionEnum.ViewProfileButtonClicked,
			voiceStatus = v58
		})
		v53.openViewProfile()
	end, {
		v53.parentChannelId,
		v53.openViewProfile,
		v54.fireSquadAnalytics,
		v58
	})
	local v65 = React.useCallback(function() -- line: 155
		-- upvalues: v54 (copy), EventNames (copy), v53 (copy), SquadPartySheetActionEnum (copy), v58 (copy), v57 (copy), SquadPromptType (copy), v55 (copy)
		v54.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v53.parentChannelId,
			actionType = SquadPartySheetActionEnum.RemoveUserDropDownButtonClicked,
			voiceStatus = v58
		})
		v54.setSquadPrompt(v57, {
			promptType = SquadPromptType.RemoveFromChat,
			onConfirm = function() -- line: 164
				-- upvalues: v53 (copy), v54 (copy), EventNames (copy), SquadPartySheetActionEnum (copy), v58 (copy), v55 (copy)
				if v53.userId ~= "" and v53.parentChannelId ~= "" then
					v54.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v53.parentChannelId,
						actionType = SquadPartySheetActionEnum.RemoveUserDialogButtonClicked,
						voiceStatus = v58
					})

					return v54.removeUserFromParentChannel(v55, v53.parentChannelId, v53.userId)
				end

				return nil
			end
		})
	end, {
		v55,
		v53.userId,
		v53.parentChannelId,
		v54.fireSquadAnalytics,
		v54.setSquadPrompt,
		v54.removeUserFromParentChannel,
		v58
	})
	local u66 = nil
	local u67 = nil
	local u68 = nil
	local t3 = {}
	local u70 = nil
	local u71 = nil

	if GetFFlagEnableCrossExpVoice() then
		u66 = useBackgroundExperience()
		u68 = useParticipants() or {}
		t3 = React.useMemo(function() -- line: 199
			-- upvalues: u68 (ref)
			local t4 = {}

			for _, v in pairs(u68) do
				table.insert(t4, v.userId)
			end

			return t4
		end, { u68 })
		u70 = React.useMemo(function() -- line: 206
			-- upvalues: u66 (ref)
			if u66 then
				return u66.voiceChannelId
			end

			return nil
		end, { u66 })
		u71 = React.useMemo(function() -- line: 209
			-- upvalues: u66 (ref)
			if u66 then
				return u66.voiceSessionId
			end

			return nil
		end, { u66 })

		if not FFlagEnableSquadUserCardHoverFix then
			local v72 = if not v53.userId then nil else tonumber(v53.userId)

			if v72 then
				local v73 = useIsLocalPlayerPartyVoiceEligible()
				local v74 = useIsUserPartyVoiceEligible(v72)

				u67 = useIsCurrentSquadPartyVoiceEligible() == true and (v73 and not v74)
			end
		end
	end

	local v75 = React.useCallback(function(p1) -- line: 226
		-- upvalues: v53 (copy)
		return p1.Squad.Presence.byUserId[v53.userId]
	end, { v53.userId })
	local v76 = useSelector(v75)
	local v77 = React.useMemo(function() -- line: 231
		-- upvalues: FFlagEnableSquadUserCardHoverFix (copy), v59 (copy), v76 (copy), PresenceType (copy)
		if FFlagEnableSquadUserCardHoverFix then
			return table.find(v59, "JoinButton") ~= nil and (v76 and (v76.userPresenceType == PresenceType.InGame and v76.placeId))
		end

		return v76 and (v76.userPresenceType == PresenceType.InGame and v76.placeId)
	end, {
		v76,
		v59
	})
	local v78 = React.useCallback(function() -- line: 242
		-- upvalues: v77 (copy), GameParams (copy), v53 (copy), v76 (copy), FFlagSquadLaunchExperienceMobileFix (copy), v54 (copy), SquadLocationEnum (copy), ExperienceService2 (copy)
		if v77 then
			local v84 = GameParams.fromUserId(v53.userId, v76.placeId)

			if v53.isInExperience and FFlagSquadLaunchExperienceMobileFix then
				game:Shutdown()
			end

			local s1 = "SquadLobby"

			if v54.squadLocation == SquadLocationEnum.UniversalApp then
				s1 = "SquadLobbyFromUA"
			elseif v54.squadLocation == SquadLocationEnum.InExperience then
				s1 = "SquadLobbyFromInExp"
			end

			ExperienceService2:LaunchExperience(v84, s1, nil)
		end
	end, {
		v77,
		v54.squadLocation,
		v53.isInExperience,
		v53.userId,
		v76
	})
	local v79 = if not FFlagEnableSquadUserCardHoverFix then React.useMemo(function() -- line: 357
		-- upvalues: v56 (copy), v53 (copy), getFFlagEnableCrossExpVoiceAbuseReport (copy), u70 (ref), u67 (ref), v48 (copy), v61 (copy), v77 (copy), v44 (copy), v78 (copy), v45 (copy), v64 (copy), v46 (copy), u71 (ref), t3 (ref), v63 (copy), v47 (copy), v65 (copy)
		local v91 = tostring(v56) == v53.userId
		local isInExperience = v53.isInExperience
		local v93 = getFFlagEnableCrossExpVoiceAbuseReport() and (not not u70 and not v91)
		local t5 = {}

		if u67 then
			table.insert(t5, {
				stayOnActivated = true,
				icon = v48,
				text = v61.voiceIneligibleText
			})
		end

		if v77 then
			table.insert(t5, {
				icon = v44,
				text = v61.joinButtonText,
				onActivated = v78
			})
		end

		if not isInExperience then
			table.insert(t5, {
				icon = v45,
				text = v61.viewProfileText,
				onActivated = v64
			})
		end

		if v93 then
			table.insert(t5, {
				icon = v46,
				text = v61.reportUserText,
				onActivated = function() -- line: 394
					-- upvalues: v56 (copy), v53 (copy), u70 (ref), u71 (ref), t3 (ref)
					local t6 = {
						submitterUserId = tostring(v56),
						abuserUserId = v53.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = u70,
						voiceSessionId = u71,
						voiceUserIds = t3,
						voiceUserCount = #t3
					}

					v53.openSquadVoiceAbuseReport(t6)
				end
			})
		end

		if v63 then
			table.insert(t5, {
				icon = v47,
				text = v61.removeFromGroupText,
				onActivated = v65
			})
		end

		return t5
	end, {
		v53.isInExperience,
		v53.userId,
		v53.openSquadVoiceAbuseReport,
		v61.joinButtonText,
		v61.removeFromGroupText,
		v61.reportUserText,
		v61.viewProfileText,
		v61.voiceIneligibleText,
		u67,
		v56,
		u70,
		u71,
		t3,
		v65,
		v77,
		v63,
		v78,
		v64
	}) else React.useMemo(function() -- line: 267
		-- upvalues: v48 (copy), v61 (copy), v44 (copy), v78 (copy), v47 (copy), v65 (copy), v45 (copy), v64 (copy), v46 (copy), v56 (copy), v53 (copy), u70 (ref), u71 (ref), t3 (ref), v60 (copy), v49 (copy), v50 (copy), default (copy), v59 (copy)
		local t8 = {
			VoiceIneligibleButton = {
				stayOnActivated = true,
				icon = v48,
				text = v61.voiceIneligibleText
			},
			JoinButton = {
				icon = v44,
				text = v61.joinButtonText,
				onActivated = v78
			},
			RemoveUserButton = {
				icon = v47,
				text = v61.removeFromGroupText,
				onActivated = v65
			},
			ViewProfileButton = {
				icon = v45,
				text = v61.viewProfileText,
				onActivated = v64
			},
			ReportButton = {
				icon = v46,
				text = v61.reportUserText,
				onActivated = function() -- line: 292
					-- upvalues: v56 (copy), v53 (copy), u70 (ref), u71 (ref), t3 (ref)
					local t7 = {
						submitterUserId = tostring(v56),
						abuserUserId = v53.userId,
						reportBeginTimestampMs = workspace:GetServerTimeNow() * 1000,
						voiceChannelId = u70,
						voiceSessionId = u71,
						voiceUserIds = t3,
						voiceUserCount = #t3
					}

					v53.openSquadVoiceAbuseReport(t7)
				end
			},
			MuteVoiceButton = {
				icon = if not v60 then v50 else v49,
				text = if not v60 then v61.muteVoiceButtonText else v61.unmuteVoiceButtonText,
				onActivated = function() -- line: 310
					-- upvalues: v53 (copy), v60 (copy), default (copy)
					local num = tonumber(v53.userId)

					if num then
						if v60 then
							default:unmuteVoiceParticipant(num)

							return
						end

						default:muteVoiceParticipant(num)

						return
					end

					warn("Invalid userId: " .. tostring(v53.userId))
				end
			}
		}
		local t9 = {}

		for _, v89 in v59 do
			local v90 = t8[v89]

			if v90 then
				table.insert(t9, v90)
			end
		end

		return t9
	end, {
		v53.userId,
		v53.openSquadVoiceAbuseReport,
		v61.joinButtonText,
		v61.removeFromGroupText,
		v61.reportUserText,
		v61.viewProfileText,
		v61.voiceIneligibleText,
		v61.muteVoiceButtonText,
		v61.unmuteVoiceButtonText,
		v56,
		u70,
		u71,
		t3,
		v65,
		v59,
		v78,
		v64,
		v60
	})

	if #v79 > 0 then
		return React.createElement(FocusNavigableSurfaceWrapper, {
			isAutoFocusRoot = true,
			isFocusable = true,
			isIsolated = true,
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p2) -- line: 443
						-- upvalues: v53 (copy)
						v53.onDismiss()
						p2:cancel()
					end)
				}
			},
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}, { React.createElement(ModalBottomSheet, {
			bottomGap = 20,
			screenWidth = 400,
			showImages = true,
			buttonModels = v79,
			onDismiss = function() -- line: 457
				-- upvalues: v53 (copy)
				v53.onDismiss()
			end
		}) })
	end

	v53.onDismiss()

	return nil
end
