local Squads = script:FindFirstAncestor("Squads")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SquadsParent = Squads.Parent

require(SquadsParent.CrossExperience)

local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local FocusNavigationUtils = require(SquadsParent.FocusNavigationUtils)
local Foundation = require(SquadsParent.Foundation)
local React = require(SquadsParent.React)
local RoactUtils = require(SquadsParent.RoactUtils)
local RobloxAppSessionization = require(SquadsParent.RobloxAppSessionization)
local SocialCommon = require(SquadsParent.SocialCommon)
local UIBlox = require(SquadsParent.UIBlox)
local VoiceChat = require(SquadsParent.VoiceChat)
local useAppPolicy = require(SquadsParent.UniversalAppPolicy).useAppPolicy
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local Constants = require(Squads.Common.Constants)
local dependencies = require(Squads.dependencies)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
local SharedFlags = dependencies.SharedFlags
local SquadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local SquadLobbySessionProvider = require(SquadsParent.SquadsCore.SquadSessionProvider).SquadLobbySessionProvider
local SquadState = require(SquadsParent.SquadsCore.Enums).SquadState
local leaveSquad = require(SquadsParent.SquadsCore.Thunks).leaveSquad
local useCurrentSquadParentChannelId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens
local useLastInputMethod = FocusNavigationUtils.useLastInputMethod
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local InputUtilities = SocialCommon.Utils.InputUtilities
local SessionType = RobloxAppSessionization.SessionType
local ControlState = UIBlox.Core.Control.Enum.ControlState
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceDisconnected = CrossExperienceVoice.Hooks.useIsVoiceDisconnected
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useIsActiveParticipant = CrossExperienceVoice.Hooks.useIsActiveParticipant
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local v53 = game:DefineFastFlag("EnableCrossExpVoiceDebug", false)
local EngineFeature = game:GetEngineFeature("AudioFocusManagement")
local v55 = game:DefineFastString("SquadExperiencePickerTooltipSeenStorageValue", "True")
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local v57 = not SquadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled() and "size-600-600" or "size-800-800"
local t1 = {
	["icons/menu/platformChatOff"] = "speech-bubble-align-center",
	["icons/common/play"] = "play-large",
	["icons/common/search"] = "magnifying-glass",
	["icons/navigation/close"] = "x",
	["icons/controls/headphone"] = "headphones",
	["icons/actions/truncationCollapse_small"] = "chevron-large-up",
	["icons/status/player/developer"] = "hammer-code"
}
local v59 = not SquadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled() and "icons/common/play" or "icons/common/search"

local function getTooltipWasShownFromAppStorage(p1) -- line: 148
	-- upvalues: AppStorageService (copy), v55 (copy)
	local ok, result = pcall(function() -- line: 149
		-- upvalues: AppStorageService (copy), p1 (copy)
		return AppStorageService:GetItem(p1)
	end)

	if not ok or result == nil then
		return false
	end

	return result == v55
end
local function setTooltipWasShownFromAppStorage(p2) -- line: 160
	-- upvalues: AppStorageService (copy), v55 (copy)
	pcall(function() -- line: 161
		-- upvalues: AppStorageService (copy), p2 (copy), v55 (copy)
		AppStorageService:SetItem(p2, v55)
		AppStorageService:Flush()
	end)
end
local function v62(t2: {[any]: any}) -- line: 167
	-- upvalues: React (copy), ControlState (copy), useTokens (copy), useLastInputMethod (copy), SquadCoordinationExperienceJoinExperimentation (copy), AppStorageService (copy), v55 (copy), InputUtilities (copy), CoreGui (copy), ExternalEventConnection (copy), UserInputService (copy), Foundation (copy), withTooltip (copy), withHoverTooltip (copy)
	local v72, v73 = React.useBinding(ControlState.Initialize)
	local v74 = useTokens()
	local v75 = useLastInputMethod()
	local t3 = {
		headerText = t2.tooltipText
	}
	local v77, v78 = React.useState(false)

	React.useEffect(function() -- line: 179
		-- upvalues: SquadCoordinationExperienceJoinExperimentation (copy), t2 (copy), AppStorageService (copy), v55 (copy), v78 (copy)
		if SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			if t2.enableFirstTimeTooltip and t2.showFtuxCustomConditionsMet and (t2.currentHoveredButton == "" or t2.currentHoveredButton == t2.triggerPointName) then
				local ftuxAppStorageKey = t2.ftuxAppStorageKey
				local ok, result = pcall(function() -- line: 149
					-- upvalues: AppStorageService (copy), ftuxAppStorageKey (copy)
					return AppStorageService:GetItem(ftuxAppStorageKey)
				end)

				if not ok or (result == nil or result ~= v55) then
					local ftuxAppStorageKey2 = t2.ftuxAppStorageKey

					pcall(function() -- line: 161
						-- upvalues: AppStorageService (copy), ftuxAppStorageKey2 (copy), v55 (copy)
						AppStorageService:SetItem(ftuxAppStorageKey2, v55)
						AppStorageService:Flush()
					end)

					if t2.currentHoveredButton == "" then
						v78(true)

						return
					end

					return
				end
			end

			if not t2.enableFirstTimeTooltip or t2.currentHoveredButton ~= "" and t2.currentHoveredButton ~= t2.triggerPointName then
				v78(false)
			end

			return
		end
	end, {
		t2.currentHoveredButton,
		t2.enableFirstTimeTooltip,
		t2.ftuxAppStorageKey,
		t2.showFtuxCustomConditionsMet,
		t2.triggerPointName
	})

	local v79 = React.useCallback(function(p3) -- line: 210
		-- upvalues: InputUtilities (copy), v75 (copy), v78 (copy)
		if InputUtilities.isActivationInput(p3) or v75 == "Gamepad" then
			v78(false)
		end
	end, { v75 })
	local t4 = {
		DisplayOrder = 6,
		disabled = false,
		guiTarget = CoreGui,
		active = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v77,
		triggerPointName = t2.triggerPointName
	}

	local function v81(p4, p5, p6: ((...any) -> ...any)?) -- line: 226
		-- upvalues: React (copy), ControlState (copy), SquadCoordinationExperienceJoinExperimentation (copy), t2 (copy), v72 (copy), v73 (copy), v77 (copy), ExternalEventConnection (copy), UserInputService (copy), v79 (copy), Foundation (copy), v74 (copy)
		local v150 = React.useCallback(function(p7) -- line: 227
			-- upvalues: ControlState (copy), SquadCoordinationExperienceJoinExperimentation (copy), t2 (copy), p6 (copy), v72 (copy), v73 (copy)
			local v166 = ControlState.fromRawValue(p7)

			if SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				if v166 == ControlState.Hover then
					t2.onHoverCalled(t2.triggerPointName)
				elseif v166 == ControlState.Default then
					t2.onHoverCalled("")
				end
			end

			if p6 then
				p6(v72:getValue(), v166)
			end

			v73(v166)
		end, {
			v72,
			t2.onHoverCalled,
			t2.triggerPointName,
			v73
		})
		local v151 = React.useCallback(function() -- line: 244
			-- upvalues: t2 (copy), v77 (copy)
			if t2.onActivated then
				t2.onActivated(v77)
			end
		end, {
			v77,
			t2.onActivated
		})

		return React.createElement("Frame", {
			AutomaticSize = t2.automaticSize,
			LayoutOrder = t2.layoutOrder,
			Size = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			[React.Change.AbsolutePosition] = p4,
			[React.Change.AbsoluteSize] = p5
		}, {
			InputEndedConnection = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() or not v77 then nil else React.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = v79
			}),
			React.createElement(Foundation.View, {
				Size = UDim2.fromScale(1, 1),
				backgroundStyle = t2.backgroundStyle,
				cornerRadius = UDim.new(0, v74.Radius.Circle),
				isDisabled = t2.isDisabled,
				onActivated = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then t2.onActivated else v151,
				onStateChanged = v150
			}, t2.children)
		})
	end

	if SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and v77 then
		return (withTooltip(t3, t4, function(p8) -- line: 278
			-- upvalues: v81 (copy)
			return v81(p8, p8, nil)
		end))
	end

	return (withHoverTooltip(t3, t4, function(p9, p10) -- line: 282
		-- upvalues: v81 (copy)
		return v81(p9, p9, p10)
	end))
end
local function tagToSize(p11) -- line: 292
	return {
		["size-600-600"] = p11.Size.Size_600,
		["size-800-800"] = p11.Size.Size_800
	}
end
local function renderStandardImage(p12, p13, p14, p15) -- line: 299
	-- upvalues: t1 (copy), React (copy), Foundation (copy)
	local v87 = t1[p13]

	if v87 then
		local t5 = {
			["size-600-600"] = p15.Size.Size_600,
			["size-800-800"] = p15.Size.Size_800
		}

		return React.createElement(Foundation.Icon, {
			name = v87,
			style = if not p12 then p15.Color.Content.Emphasis else p15.Color.Content.Muted,
			size = t5[p14] or t5["size-600-600"],
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	end

	return React.createElement(Foundation.Image, {
		Image = p13,
		tag = {
			["content-emphasis"] = not p12,
			["content-muted"] = p12,
			["anchor-center-center position-center-center " .. p14] = true
		}
	})
end
local function getLoadingIndicatorIcon(p16, p17, b1: boolean?, b2: boolean?, n1: number?) -- line: 322
	-- upvalues: VoiceChat (copy)
	local v94 = p16.Config.ColorMode.IsLight ~= "true" and "MicLight" or "MicDark"

	if not b1 or (not p17 or p17.isMuted) then
		return VoiceChat.Utils.GetIcon("Muted", v94)
	end

	if b2 then
		return VoiceChat.Utils.GetIcon("Unmuted", v94, n1)
	end

	return VoiceChat.Utils.GetIcon("Unmuted0", v94)
end
local function renderToggleAudioFocusButton(p18, p19, p20, p21, p22) -- line: 340
	-- upvalues: React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), Foundation (copy)
	return React.createElement(v62, {
		isDisabled = false,
		layoutOrder = 0,
		triggerPointName = "ToggleAudioFocusButton",
		automaticSize = Enum.AutomaticSize.X,
		currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else p21,
		enableFirstTimeTooltip = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
		ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "",
		onActivated = p20,
		onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else p22,
		showFtuxCustomConditionsMet = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
		tooltipText = p19
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p18.Padding.Small),
			PaddingRight = UDim.new(0, p18.Padding.Small)
		}),
		ToggleFocusButtonIcon = React.createElement(Foundation.Image, {
			Image = "icons/controls/headphone",
			tag = "anchor-center-center position-center-center size-900 content-emphasis"
		}),
		CaretIcon = React.createElement(Foundation.Image, {
			Image = "icons/actions/truncationCollapse_small",
			tag = "anchor-center-center position-center-center size-300-300 content-emphasis"
		})
	})
end

return function(t6: {[any]: any}) -- line: 390
	-- upvalues: useDispatch (copy), useLocalization (copy), SquadCoordinationExperienceJoinExperimentation (copy), useTokens (copy), useCurrentSquadParentChannelId (copy), useCurrentSquadSelector (copy), useVoiceStatus (copy), React (copy), useAppPolicy (copy), HttpService (copy), SquadLobbySessionProvider (copy), SquadExternalContractContext (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SessionType (copy), leaveSquad (copy), SquadState (copy), v62 (copy), Badge (copy), BadgeVariant (copy), renderStandardImage (copy), v59 (copy), v57 (copy), GetFFlagEnableCrossExpVoice (copy), useLocalUserId (copy), useBackgroundExperience (copy), useParticipant (copy), useIsVoiceConnected (copy), useIsVoiceDisconnected (copy), useIsVoiceFocused (copy), useParticipants (copy), useIsActiveParticipant (copy), EngineFeature (copy), CrossExperienceVoiceManager (copy), RunService (copy), renderToggleAudioFocusButton (copy), v53 (copy), getLoadingIndicatorIcon (copy), Foundation (copy), Constants (copy)
	local v101 = useDispatch()
	local v102 = useLocalization({
		audioText = "Feature.Squads.Label.Audio",
		leavePartyText = "Feature.Squads.Label.LeaveParty",
		muteMicText = "Feature.Squads.Label.MuteMic",
		unmuteMicText = "Feature.Squads.Label.UnmuteMic",
		viewChatText = "Feature.Squads.Label.ViewChat",
		findExperiencesText = not SquadCoordinationExperienceJoinExperimentation.getIsNewTooltipCopyEnabled() and "Feature.Squads.Label.FindExperiences" or "Feature.Squads.Label.FindExperiencesPlayTogether"
	})
	local v103 = useTokens()
	local v104 = useCurrentSquadParentChannelId()
	local v105 = useCurrentSquadSelector()
	local v106 = useVoiceStatus()
	local v107, v108 = React.useState("")
	local v109 = React.useCallback(function(p23) -- line: 411
		-- upvalues: v108 (copy)
		v108(p23)
	end, {})
	local v110 = (not v105 or not v105.members) and 0 or #v105.members
	local v111 = React.useCallback(function(p24) -- line: 418
		return p24.getCanUsePlatformChat()
	end, {})
	local v112 = useAppPolicy(v111)
	local v113 = React.useMemo(function() -- line: 423
		-- upvalues: HttpService (copy)
		return HttpService:GenerateGUID()
	end, {})
	local v114 = if not SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then nil else React.useContext(SquadLobbySessionProvider.Context)
	local v115 = React.useContext(SquadExternalContractContext)
	local v116 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v115.useIsChatEnabled()
	local v117 = React.useCallback(function(p25) -- line: 435
		-- upvalues: v115 (copy), EventNames (copy), v104 (copy), SquadPartySheetActionEnum (copy), v106 (copy), t6 (copy)
		v115.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v104,
			actionType = SquadPartySheetActionEnum.ChatButtonClicked,
			isFtuxTooltipShown = p25,
			voiceStatus = v106
		})
		t6.navigateAwayFromSquad()
	end, {
		t6.navigateAwayFromSquad,
		v104,
		v115.fireSquadAnalytics,
		v106
	})
	local v118 = React.useCallback(function(p26) -- line: 451
		-- upvalues: SquadCoordinationExperienceJoinExperimentation (copy), v114 (copy), SessionType (copy), HttpService (copy), v115 (copy), EventNames (copy), v104 (copy), SquadPartySheetActionEnum (copy), v106 (copy), v101 (copy), t6 (copy)
		if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
			v114.updateMetadata(SessionType.Metadata.SquadLobbyPage.ExperiencePickerUuid, HttpService:GenerateGUID(false))
		end

		v115.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v104,
			actionType = SquadPartySheetActionEnum.PickExperienceButtonClicked,
			isFtuxTooltipShown = p26,
			voiceStatus = v106
		})

		if SquadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
			v115.showSearchOverlay(v101)

			return
		end

		t6.navigateToHomePage()
	end, {
		v104,
		t6.navigateToHomePage,
		v115.fireSquadAnalytics,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then nil else v101,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then nil else v115.showSearchOverlay,
		if not SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then nil else v114.updateMetadata,
		v106
	})
	local v119 = React.useCallback(function(p27) -- line: 484
		-- upvalues: v115 (copy), EventNames (copy), v104 (copy), SquadPartySheetActionEnum (copy), v106 (copy), v101 (copy), leaveSquad (copy), t6 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v116 (copy)
		v115.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v104,
			actionType = SquadPartySheetActionEnum.EndCallButtonClicked,
			isFtuxTooltipShown = p27,
			voiceStatus = v106
		})
		v101(leaveSquad(nil, v115.setSquadPrompt, function() -- line: 496
			-- upvalues: t6 (copy)
			t6.navigateAwayFromSquad()
		end, v115.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v116))
	end, {
		v101,
		t6.navigateAwayFromSquad,
		v104,
		v115.fireSquadAnalytics,
		v115.setSquadPrompt,
		v115.squadLocation,
		if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v116,
		v106
	})
	local v120 = t6.squadState ~= SquadState.Active
	local v121 = React.useMemo(function() -- line: 516
		-- upvalues: React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v107 (copy), v120 (copy), v117 (copy), v109 (copy), v102 (copy), t6 (copy), Badge (copy), v103 (copy), BadgeVariant (copy), renderStandardImage (copy)
		return React.createElement(v62, {
			layoutOrder = 2,
			triggerPointName = "ChatButton",
			currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
			enableFirstTimeTooltip = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "",
			isDisabled = v120,
			onActivated = v117,
			onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
			showFtuxCustomConditionsMet = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			tooltipText = v102.viewChatText
		}, {
			UnreadMessagesBadge = if not t6.hasUnreadMessages then nil else React.createElement(Badge, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, -v103.Size.Size_250, 0, v103.Size.Size_250),
				variant = BadgeVariant.Alert
			}),
			renderStandardImage(v120, "icons/menu/platformChatOff", "size-800-800", v103)
		})
	end, {
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
		v103,
		v120,
		v102.viewChatText,
		v117,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
		t6.hasUnreadMessages
	})
	local v122 = React.useMemo(function() -- line: 562
		-- upvalues: t6 (copy), React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v107 (copy), v120 (copy), v118 (copy), v109 (copy), v110 (copy), v102 (copy), renderStandardImage (copy), v59 (copy), v57 (copy), v103 (copy)
		if t6.isInExperience then
			return nil
		end

		return (React.createElement(v62, {
			layoutOrder = 3,
			triggerPointName = "PickExperienceButton",
			currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
			enableFirstTimeTooltip = not not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() or nil,
			ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "SquadExperiencePickerTooltipSeen",
			isDisabled = v120,
			onActivated = v118,
			onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
			showFtuxCustomConditionsMet = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v110 >= 2,
			tooltipText = v102.findExperiencesText
		}, renderStandardImage(v120, v59, v57, v103)))
	end, {
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
		v103,
		v120,
		v102.findExperiencesText,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v110,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
		t6.isInExperience,
		t6.navigateToHomePage
	})
	local v123 = React.useMemo(function() -- line: 604
		-- upvalues: v120 (copy), v103 (copy), React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v107 (copy), v119 (copy), v109 (copy), v102 (copy), renderStandardImage (copy)
		local v160 = if not v120 then v103.Color.System.Alert else v103.Color.ActionStandard.Background

		return React.createElement(v62, {
			layoutOrder = 4,
			triggerPointName = "EndCallButton",
			backgroundStyle = v160,
			currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
			enableFirstTimeTooltip = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "",
			isDisabled = v120,
			onActivated = v119,
			onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
			showFtuxCustomConditionsMet = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			tooltipText = v102.leavePartyText
		}, renderStandardImage(v120, "icons/navigation/close", "size-600-600", v103))
	end, {
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
		v103,
		v120,
		v102.leavePartyText,
		v119,
		if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109
	})
	local v124 = nil
	local v125 = nil
	local v126 = nil

	if GetFFlagEnableCrossExpVoice() then
		local v127 = tonumber(useLocalUserId()) or -1
		local v128 = React.useRef(0)
		local v129 = useBackgroundExperience()
		local v130 = useParticipant(v127)
		local v131 = useIsVoiceConnected()
		local v132 = useIsVoiceDisconnected()
		local v133 = useIsVoiceFocused() or t6.forceIsVoiceFocused
		local v134 = useParticipants()
		local v135 = useIsActiveParticipant(v127)
		local v136, v137 = React.useState(0)
		local v138 = EngineFeature
		local v139 = React.useCallback(function(_) -- line: 658
			-- upvalues: HttpService (copy), v129 (copy), v130 (copy), v134 (copy), CrossExperienceVoiceManager (copy)
			print("----------- CEV FOREGROUND -----------")
			print("Experience info", HttpService:JSONEncode(v129))
			print("Current Voice Participant", HttpService:JSONEncode(v130))
			print("Squads Store Participants", HttpService:JSONEncode(v134 or {}))
			print("--------------------------------------")
			CrossExperienceVoiceManager.default:dumpDebugData()
		end, {
			v134,
			v130
		})
		local v140 = React.useCallback(function(_) -- line: 667
			-- upvalues: v130 (copy), CrossExperienceVoiceManager (copy)
			if v130 then
				if v130.isMuted then
					CrossExperienceVoiceManager.default:unmuteVoiceParticipant(v130.userId)

					return
				end

				CrossExperienceVoiceManager.default:muteVoiceParticipant(v130.userId)
			end
		end, { v130 })

		React.useEffect(function() -- line: 677
			-- upvalues: RunService (copy), v113 (copy), v128 (copy), v137 (copy)
			RunService:BindToRenderStep(v113, 1, function() -- line: 678
				-- upvalues: v128 (copy), v137 (copy)
				if v128.current > 3 then
					v137(math.random())
					v128.current = 0

					return
				end

				v128.current = v128.current + 1
			end)

			return function() -- line: 687
				-- upvalues: RunService (copy), v113 (copy)
				RunService:UnbindFromRenderStep(v113)
			end
		end, {})
		v124 = React.useMemo(function() -- line: 692
			-- upvalues: v120 (copy), v138 (copy), v131 (copy), renderToggleAudioFocusButton (copy), v103 (copy), v102 (copy), t6 (copy), v107 (copy), v109 (copy)
			if not v120 and (v138 and v131) then
				return renderToggleAudioFocusButton(v103, v102.audioText, t6.toggleVoiceChatMenu, v107, v109)
			end

			return nil
		end, {
			v103,
			v138,
			v107,
			v120,
			v131,
			v102.audioText,
			v109,
			t6.toggleVoiceChatMenu
		})

		if v53 then
			v125 = React.useMemo(function() -- line: 715
				-- upvalues: React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v107 (copy), v120 (copy), v139 (copy), v109 (copy), renderStandardImage (copy), v103 (copy)
				return React.createElement(v62, {
					layoutOrder = 5,
					tooltipText = "Debug voice",
					triggerPointName = "DebugVoiceButton",
					currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
					enableFirstTimeTooltip = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
					ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "",
					isDisabled = v120,
					onActivated = v139,
					onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
					showFtuxCustomConditionsMet = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil
				}, renderStandardImage(v120, "icons/status/player/developer", "size-600-600", v103))
			end, {
				if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
				v103,
				v120,
				v139,
				if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109
			})
		end

		local v141 = React.useMemo(function() -- line: 751
			-- upvalues: getLoadingIndicatorIcon (copy), v103 (copy), v130 (copy), v131 (copy), v120 (copy), v135 (copy), v136 (copy)
			return getLoadingIndicatorIcon(v103, v130, v131, not v120 and v135, v136)
		end, {
			v135,
			v120,
			v131,
			v136,
			v130,
			v103
		})

		v126 = React.useMemo(function() -- line: 761
			-- upvalues: v132 (copy), v120 (copy), EngineFeature (copy), v133 (copy), v131 (copy), v130 (copy), React (copy), v62 (copy), SquadCoordinationExperienceJoinExperimentation (copy), v107 (copy), v140 (copy), v109 (copy), v102 (copy), renderStandardImage (copy), v141 (copy), v103 (copy)
			if v132 then
				return nil
			end

			if v120 or not EngineFeature or v133 then
				local v163 = not v131 or (v130 == nil or v120)
				local v164 = not v131 or (not v130 or v130.isMuted)

				return React.createElement(v62, {
					layoutOrder = 1,
					triggerPointName = "ToggleMicButton",
					currentHoveredButton = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
					enableFirstTimeTooltip = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
					ftuxAppStorageKey = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else "",
					isDisabled = v163,
					onActivated = v140,
					onHoverCalled = if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
					showFtuxCustomConditionsMet = not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
					tooltipText = if not v164 then v102.muteMicText else v102.unmuteMicText
				}, renderStandardImage(v163, v141, "size-800-800", v103))
			end

			return nil
		end, {
			if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v107,
			v103,
			v141,
			v120,
			v133,
			v131,
			v102.muteMicText,
			v102.unmuteMicText,
			if not SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then nil else v109,
			v140,
			v130,
			v132
		})
	end

	return React.createElement(Foundation.View, {
		AutomaticSize = Enum.AutomaticSize.X,
		AnchorPoint = t6.anchorPoint,
		Position = t6.position,
		Size = UDim2.fromOffset(0, Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT),
		backgroundStyle = v103.Color.OverMedia.OverMedia_0,
		cornerRadius = UDim.new(0, v103.Radius.Circle),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v103.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = v103.Padding.Small
	}, {
		ToggleAudioFocusButton = v124,
		ToggleMicButton = v126,
		ChatButton = if not v112 then nil else v121,
		PickExperienceButton = v122,
		EndCallButton = v123,
		DebugVoiceButton = v125
	})
end
