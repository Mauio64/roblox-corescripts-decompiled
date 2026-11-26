local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperience")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils")
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppSessionization")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SocialCommon")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local VoiceChat = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/VoiceChat")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/Constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local SquadPartySheetActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadPartySheetActionEnum")
local FFlagSquadLobbyActionBarFixMicLevelRerender = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadLobbyActionBarFixMicLevelRerender")

local sharedFlags = dependencies.SharedFlags

local squadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local squadLobbySessionProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadSessionProvider").SquadLobbySessionProvider
local squadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadState
local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").leaveSquad
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization

local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens

local useLastInputMethod = FocusNavigationUtils.useLastInputMethod

local externalEventConnection = RoactUtils.ExternalEventConnection

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local inputUtilities = SocialCommon.Utils.InputUtilities

local sessionType = RobloxAppSessionization.SessionType

local controlState = UIBlox.Core.Control.Enum.ControlState
local withHoverTooltip = UIBlox.App.Dialog.TooltipV2.withHoverTooltip
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip

local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useParticipants = CrossExperienceVoice.Hooks.useParticipants
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local useIsVoiceFocused = CrossExperienceVoice.Hooks.useIsVoiceFocused
local useIsVoiceDisconnected = CrossExperienceVoice.Hooks.useIsVoiceDisconnected
local useBackgroundExperience = CrossExperienceVoice.Hooks.useBackgroundExperience
local useIsActiveParticipant = CrossExperienceVoice.Hooks.useIsActiveParticipant
local useIsParticipantMuted = CrossExperienceVoice.Hooks.useIsParticipantMuted
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local crossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local defineFastFlag = game:DefineFastFlag("EnableCrossExpVoiceDebug", false)
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local defineFastString = game:DefineFastString("SquadExperiencePickerTooltipSeenStorageValue", "True")

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = sharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

local v5 = squadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled()
	and "size-800-800"
	or "size-600-600"

local v6 = {
	["icons/menu/platformChatOff"] = "speech-bubble-align-center",
	["icons/common/play"] = "play-large",
	["icons/common/search"] = "magnifying-glass",
	["icons/navigation/close"] = "x",
	["icons/controls/headphone"] = "headphones",
	["icons/actions/truncationCollapse_small"] = "chevron-large-up",
	["icons/status/player/developer"] = "hammer-code"
}

local v7 = squadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled()
	and "icons/common/search"
	or "icons/common/play"

local function getTooltipWasShownFromAppStorage(p2): boolean
	local success, result = pcall(function()
		return AppStorageService:GetItem(p2)
	end)

	if success and result ~= nil then
		return result == defineFastString
	end

	return false
end

local function setTooltipWasShownFromAppStorage(p2)
	pcall(function()
		AppStorageService:SetItem(p2, defineFastString)
		AppStorageService:Flush()
	end)
end

local function fn(data)
	local v8, v9 = React.useBinding(controlState.Initialize)
	local v10 = useTokens()
	local v11 = useLastInputMethod()

	local v12 = { headerText = data.tooltipText }

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			return
		end

		if
			data.enableFirstTimeTooltip
			and data.showFtuxCustomConditionsMet
			and (data.currentHoveredButton == "" or data.currentHoveredButton == data.triggerPointName)
		then
			local ftuxAppStorageKey = data.ftuxAppStorageKey
			local success, result = pcall(function()
				return AppStorageService:GetItem(ftuxAppStorageKey)
			end)
			local v13 = if success and result ~= nil then result == defineFastString else false

			if not v13 then
				local ftuxAppStorageKey2 = data.ftuxAppStorageKey
				pcall(function()
					AppStorageService:SetItem(ftuxAppStorageKey2, defineFastString)
					AppStorageService:Flush()
				end)

				if data.currentHoveredButton ~= "" then
					return
				end

				setState(true)
				return
			end
		end

		if
			not data.enableFirstTimeTooltip
			or data.currentHoveredButton ~= "" and data.currentHoveredButton ~= data.triggerPointName
		then
			setState(false)
		end
	end, {
		data.currentHoveredButton,
		data.enableFirstTimeTooltip,
		data.ftuxAppStorageKey,
		data.showFtuxCustomConditionsMet,
		data.triggerPointName
	})

	local v13 = React.useCallback(function(p2)
		if inputUtilities.isActivationInput(p2) or v11 == "Gamepad" then
			setState(false)
		end
	end, { v11 })

	local v14 = {
		DisplayOrder = 6,
		disabled = false,
		guiTarget = CoreGui,
		active = 0,
		triggerPointName = 0
	}

	local v15 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil
	v14.active = v15

	v14.triggerPointName = data.triggerPointName

	local function fn2(p2, p3, callback)
		local v16 = React.useCallback(function(p4)
			local v17 = controlState.fromRawValue(p4)

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				if v17 == controlState.Hover then
					data.onHoverCalled(data.triggerPointName)
				elseif v17 == controlState.Default then
					data.onHoverCalled("")
				end
			end

			if callback then
				callback(v8:getValue(), v17)
			end

			v9(v17)
		end, { v8, data.onHoverCalled, data.triggerPointName, v9 })

		local v17 = React.useCallback(function()
			if data.onActivated then
				data.onActivated(state)
			end
		end, { state, data.onActivated })

		local createElement = React.createElement
		local v19 = {
			AutomaticSize = data.automaticSize,
			LayoutOrder = data.layoutOrder,
			Size = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			[React.Change.AbsolutePosition] = p2,
			[React.Change.AbsoluteSize] = p3
		}

		local v21 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and state then React.createElement(externalEventConnection, {
			event = UserInputService.InputEnded,
			callback = v13
		}) else nil

		local createElement2 = React.createElement
		local view = Foundation.View
		local v22 = {
			Size = UDim2.fromScale(1, 1),
			backgroundStyle = data.backgroundStyle,
			cornerRadius = UDim.new(0, v10.Radius.Circle),
			isDisabled = data.isDisabled,
			onActivated = 0,
			onStateChanged = 0
		}

		if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			v17 = data.onActivated
		end

		v22.onActivated = v17

		v22.onStateChanged = v16
		return createElement("Frame", v19, {
			InputEndedConnection = v21,
			createElement2(view, v22, data.children)
		})
	end

	local function fn3(p2)
		return fn2(p2, p2, nil)
	end

	local function fn4(p2, p3)
		return fn2(p2, p2, p3)
	end

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and state then
		return (withTooltip(v12, v14, fn3))
	end

	return (withHoverTooltip(v12, v14, fn4))
end

local function tagToSize(p2)
	return { ["size-600-600"] = p2.Size.Size_600, ["size-800-800"] = p2.Size.Size_800 }
end

local function renderStandardImage(p2, p3, p4, p5, testId)
	local v8 = v6[p3]

	if not v8 then
		return React.createElement(Foundation.Image, {
			Image = p3,
			tag = {
				["content-emphasis"] = not p2,
				["content-muted"] = p2,
				["anchor-center-center position-center-center " .. p4] = true
			},
			testId = testId
		})
	end

	local v9 = {
		["size-600-600"] = p5.Size.Size_600,
		["size-800-800"] = p5.Size.Size_800
	}

	local createElement = React.createElement
	local icon = Foundation.Icon

	local v11 = if p2 then p5.Color.Content.Muted else p5.Color.Content.Emphasis
	return createElement(icon, {
		name = v8,
		style = v11,
		size = v9[p4] or v9["size-600-600"],
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		testId = testId
	})
end

local function getLoadingIndicatorIcon(p2, p3, p4, p5, state)
	local v8 = p2.Config.ColorMode.IsLight == "true" and "MicDark" or "MicLight"

	if p4 and p3 and not p3.isMuted then
		if p5 then
			return VoiceChat.Utils.GetIcon("Unmuted", v8, state)
		end

		return VoiceChat.Utils.GetIcon("Unmuted0", v8)
	end

	return VoiceChat.Utils.GetIcon("Muted", v8)
end

local function renderToggleAudioFocusButton(p2, audioText, toggleVoiceChatMenu, state, onHoverCalled)
	local createElement = React.createElement
	local v9 = {
		automaticSize = Enum.AutomaticSize.X,
		currentHoveredButton = 0,
		enableFirstTimeTooltip = 0,
		ftuxAppStorageKey = 0,
		isDisabled = false,
		layoutOrder = 0,
		onActivated = 0,
		onHoverCalled = 0,
		showFtuxCustomConditionsMet = 0,
		tooltipText = 0,
		triggerPointName = "ToggleAudioFocusButton"
	}

	if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		state = nil
	end

	v9.currentHoveredButton = state

	local v10 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
	v9.enableFirstTimeTooltip = v10

	v9.ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
		and ""
		or nil

	v9.onActivated = toggleVoiceChatMenu

	if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		onHoverCalled = nil
	end

	v9.onHoverCalled = onHoverCalled

	local v11 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
	v9.showFtuxCustomConditionsMet = v11

	v9.tooltipText = audioText
	return createElement(fn, v9, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p2.Padding.Small),
			PaddingRight = UDim.new(0, p2.Padding.Small)
		}),
		ToggleFocusButtonIcon = React.createElement(Foundation.Image, {
			Image = "icons/controls/headphone",
			tag = "anchor-center-center position-center-center size-900 content-emphasis",
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--audio-focus-button--icon" or nil
		}),
		CaretIcon = React.createElement(Foundation.Image, {
			Image = "icons/actions/truncationCollapse_small",
			tag = "anchor-center-center position-center-center size-300-300 content-emphasis",
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--audio-focus-button--caret" or nil
		})
	})
end

return function(props)
	local v8 = useDispatch()
	local v9 = useLocalization({
		audioText = "Feature.Squads.Label.Audio",
		findExperiencesText = squadCoordinationExperienceJoinExperimentation.getIsNewTooltipCopyEnabled() and "Feature.Squads.Label.FindExperiencesPlayTogether" or "Feature.Squads.Label.FindExperiences",
		leavePartyText = "Feature.Squads.Label.LeaveParty",
		muteMicText = "Feature.Squads.Label.MuteMic",
		unmuteMicText = "Feature.Squads.Label.UnmuteMic",
		viewChatText = "Feature.Squads.Label.ViewChat"
	})

	local v10 = useTokens()

	local v11 = useCurrentSquadParentChannelId()
	local v12 = useCurrentSquadSelector()

	local v13 = useVoiceStatus()

	local state, setState = React.useState("")

	local v14 = React.useCallback(function(p2)
		setState(p2)
	end, {})

	local v15 = v12 and v12.members and #v12.members or 0

	local v17 = useAppPolicy((React.useCallback(function(p2)
		return p2.getCanUsePlatformChat()
	end, {})))

	local v18 = React.useMemo(function()
		return HttpService:GenerateGUID()
	end, {})
	local v19

	if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v19 = React.useContext(squadLobbySessionProvider.Context)
	else
		v19 = nil
	end

	local v20 = React.useContext(squadExternalContractContext)

	local v21 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v20.useIsChatEnabled()

	local v22 = React.useCallback(function(p2)
		v20.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v11,
			actionType = SquadPartySheetActionEnum.ChatButtonClicked,
			isFtuxTooltipShown = p2,
			voiceStatus = v13
		})

		if v11 and v11 ~= "" and props.navigateToChat then
			props.navigateToChat(v11)
		else
			props.navigateAwayFromSquad()
		end
	end, {
		props.navigateAwayFromSquad,
		props.navigateToChat,
		v11,
		v20.fireSquadAnalytics,
		v13
	})

	local useCallback = React.useCallback
	local function fn2(p2)
		if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
			v19.updateMetadata(
				sessionType.Metadata.SquadLobbyPage.ExperiencePickerUuid,
				HttpService:GenerateGUID(false)
			)
		end

		v20.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v11,
			actionType = SquadPartySheetActionEnum.PickExperienceButtonClicked,
			isFtuxTooltipShown = p2,
			voiceStatus = v13
		})

		if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
			v20.showSearchOverlay(v8)
		else
			props.navigateToHomePage()
		end
	end

	local navigateToHomePage = props.navigateToHomePage
	local fireSquadAnalytics = v20.fireSquadAnalytics
	local v24

	if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
		v24 = v8
	end

	local showSearchOverlay

	if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
		showSearchOverlay = v20.showSearchOverlay
	end

	local v25 = if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then v19.updateMetadata else nil
	local v26 = useCallback(fn2, {
		v11,
		navigateToHomePage,
		fireSquadAnalytics,
		v24,
		showSearchOverlay,
		v25,
		v13
	})

	local function fn3(p2)
		v20.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = v11,
			actionType = SquadPartySheetActionEnum.EndCallButtonClicked,
			isFtuxTooltipShown = p2,
			voiceStatus = v13
		})

		v8(leaveSquad(nil, v20.setSquadPrompt, function()
			props.navigateAwayFromSquad()
		end, v20.squadLocation, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v21))
	end

	local v29 = React.useCallback(fn3, {
		v8,
		props.navigateAwayFromSquad,
		v11,
		v20.fireSquadAnalytics,
		v20.setSquadPrompt,
		v20.squadLocation,
		if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then v21 else nil,
		v13
	})

	local v30 = props.squadState ~= squadState.Active

	local useMemo = React.useMemo
	local function fn4()
		local createElement = React.createElement
		local v34 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil

		local v35 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
		local v33 = {
			currentHoveredButton = v34,
			enableFirstTimeTooltip = v35,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
			isDisabled = v30,
			layoutOrder = 2,
			onActivated = v22,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "ChatButton"
		}

		local v36 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
		v33.onHoverCalled = v36

		local v37 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
		v33.showFtuxCustomConditionsMet = v37

		v33.tooltipText = v9.viewChatText

		local v39 = if props.hasUnreadMessages then React.createElement(badge, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(1, -v10.Size.Size_250, 0, v10.Size.Size_250),
			variant = badgeVariant.Alert,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--chat-button--unread-badge" or nil
		}) else nil
		return createElement(fn, v33, {
			UnreadMessagesBadge = v39,
			renderStandardImage(
				v30,
				"icons/menu/platformChatOff",
				"size-800-800",
				v10,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--chat-button--icon" or nil
			)
		})
	end

	local v32

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v32 = state
	end

	local viewChatText = v9.viewChatText

	local v33 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
	local v34 = useMemo(fn4, {
		v32,
		v10,
		v30,
		viewChatText,
		v22,
		v33,
		props.hasUnreadMessages
	})

	local useMemo2 = React.useMemo
	local function fn5()
		if props.isInExperience then
			return nil
		end

		local createElement = React.createElement
		local v38 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil
		local v37 = {
			currentHoveredButton = v38,
			enableFirstTimeTooltip = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and true or nil,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "SquadExperiencePickerTooltipSeen" or nil,
			isDisabled = v30,
			layoutOrder = 3,
			onActivated = v26,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "PickExperienceButton"
		}

		local v39 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
		v37.onHoverCalled = v39

		local v40 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v15 >= 2 else nil
		v37.showFtuxCustomConditionsMet = v40

		v37.tooltipText = v9.findExperiencesText
		return (createElement(
			fn,
			v37,
			renderStandardImage(
				v30,
				v7,
				v5,
				v10,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--pick-experience-button--icon" or nil
			)
		))
	end

	local v36

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v36 = state
	end

	local findExperiencesText = v9.findExperiencesText
	local v37

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v37 = v15
	end

	local v38 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
	local v39 = useMemo2(fn5, {
		v36,
		v10,
		v30,
		findExperiencesText,
		v37,
		v38,
		props.isInExperience,
		props.navigateToHomePage
	})

	local useMemo3 = React.useMemo
	local function fn6()
		local v40 = if v30 then v10.Color.ActionStandard.Background else v10.Color.System.Alert

		local createElement = React.createElement

		local v44 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil

		local v45 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
		local v43 = {
			backgroundStyle = v40,
			currentHoveredButton = v44,
			enableFirstTimeTooltip = v45,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
			isDisabled = v30,
			layoutOrder = 4,
			onActivated = v29,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "EndCallButton"
		}

		local v46 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
		v43.onHoverCalled = v46

		local v47 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
		v43.showFtuxCustomConditionsMet = v47

		v43.tooltipText = v9.leavePartyText
		return createElement(
			fn,
			v43,
			renderStandardImage(
				v30,
				"icons/navigation/close",
				"size-600-600",
				v10,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--end-call-button--icon" or nil
			)
		)
	end

	local v41

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v41 = state
	end

	local leavePartyText = v9.leavePartyText

	local v42 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
	local v43 = useMemo3(fn6, { v41, v10, v30, leavePartyText, v29, v42 })

	local v44 = nil
	local v45, v46

	if getFFlagEnableCrossExpVoice() then
		local v47 = tonumber(useLocalUserId()) or -1
		local ref = React.useRef(0)
		local v48 = useBackgroundExperience()
		local v49 = useParticipant(v47)
		local v50 = useIsVoiceConnected()
		local v51 = useIsVoiceDisconnected()
		local v52 = useIsVoiceFocused() or props.forceIsVoiceFocused
		local v53 = useParticipants()
		local v54 = useIsActiveParticipant(v47)

		local v55 = if FFlagSquadLobbyActionBarFixMicLevelRerender then useIsParticipantMuted(v47) == true else nil

		local state2, setState2 = React.useState(0)
		local v56 = engineFeature

		local v57 = React.useCallback(function(p2)
			print("----------- CEV FOREGROUND -----------")
			print("Experience info", HttpService:JSONEncode(v48))
			print("Current Voice Participant", HttpService:JSONEncode(v49))
			print("Squads Store Participants", HttpService:JSONEncode(v53 or {}))
			print("--------------------------------------")
			crossExperienceVoiceManager.default:dumpDebugData()
		end, { v53, v49 })

		local v58 = React.useCallback(function(p2)
			if v49 then
				if v49.isMuted then
					crossExperienceVoiceManager.default:unmuteVoiceParticipant(v49.userId)
				else
					crossExperienceVoiceManager.default:muteVoiceParticipant(v49.userId)
				end
			end
		end, { v49 })

		local v59 = not v30

		if v59 then
			v59 = if v50 then not (v49 == nil) and (not v49.isMuted and v54 == true) else v50
		end

		local useEffect = React.useEffect
		local function fn7()
			if FFlagSquadLobbyActionBarFixMicLevelRerender and not v59 then
				return nil
			end

			local renderStepService = props.renderStepService or RunService
			renderStepService:BindToRenderStep(v18, 1, function()
				if ref.current > 3 then
					setState2(math.random())
					ref.current = 0
				else
					ref.current += 1
				end
			end)

			return function()
				renderStepService:UnbindFromRenderStep(v18)
			end
		end

		local v60 = if FFlagSquadLobbyActionBarFixMicLevelRerender then { v59, props.renderStepService } else { props.renderStepService }
		useEffect(fn7, v60)

		v45 = React.useMemo(function()
			if v30 or not (v56 and v50) then
				return nil
			end

			return renderToggleAudioFocusButton(v10, v9.audioText, props.toggleVoiceChatMenu, state, v14)
		end, { v10, v56, state, v30, v50, v9.audioText, v14, props.toggleVoiceChatMenu })

		if defineFastFlag then
			local useMemo4 = React.useMemo
			local function fn8()
				local createElement = React.createElement
				local v64 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil

				local v65 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
				local v63 = {
					currentHoveredButton = v64,
					enableFirstTimeTooltip = v65,
					ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
					isDisabled = v30,
					layoutOrder = 5,
					onActivated = v57,
					onHoverCalled = 0,
					showFtuxCustomConditionsMet = 0,
					tooltipText = "Debug voice",
					triggerPointName = "DebugVoiceButton"
				}

				local v66 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
				v63.onHoverCalled = v66

				local v67 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
				v63.showFtuxCustomConditionsMet = v67
				return createElement(
					fn,
					v63,
					renderStandardImage(
						v30,
						"icons/status/player/developer",
						"size-600-600",
						v10,
						FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--debug-voice-button--icon" or nil
					)
				)
			end

			local v62

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				v62 = state
			end

			local v63 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
			v44 = useMemo4(fn8, { v62, v10, v30, v57, v63 })
		end

		local function fn8()
			return getLoadingIndicatorIcon(v10, v49, v50, not v30 and v54, state2)
		end

		local v63 = React.useMemo(fn8, {
			v54,
			v30,
			v50,
			state2,
			v49,
			v10,
			if FFlagSquadLobbyActionBarFixMicLevelRerender then v55 else nil
		})

		local useMemo5 = React.useMemo
		local function fn9()
			if v51 or not v30 and engineFeature and not v52 then
				return nil
			end

			local v64 = not v50 or v49 == nil or v30
			local v65 = not v50 or not v49 or v49.isMuted

			local createElement = React.createElement
			local v69 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then state else nil

			local v70 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
			local v68 = {
				currentHoveredButton = v69,
				enableFirstTimeTooltip = v70,
				ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
				isDisabled = v64,
				layoutOrder = 1,
				onActivated = v58,
				onHoverCalled = 0,
				showFtuxCustomConditionsMet = 0,
				tooltipText = 0,
				triggerPointName = "ToggleMicButton"
			}

			local v71 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then v14 else nil
			v68.onHoverCalled = v71

			local v72 = if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then false else nil
			v68.showFtuxCustomConditionsMet = v72

			local v73 = if v65 then v9.unmuteMicText else v9.muteMicText
			v68.tooltipText = v73
			return createElement(
				fn,
				v68,
				renderStandardImage(
					v64,
					v63,
					"size-800-800",
					v10,
					FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--mic-button--icon" or nil
				)
			)
		end

		local v65

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			v65 = state
		end

		local muteMicText = v9.muteMicText
		local unmuteMicText = v9.unmuteMicText
		local v66

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			v66 = v14
		end

		if not FFlagSquadLobbyActionBarFixMicLevelRerender then
			v55 = nil
		end

		v46 = useMemo5(fn9, {
			v65,
			v10,
			v63,
			v30,
			v52,
			v50,
			muteMicText,
			unmuteMicText,
			v66,
			v58,
			v49,
			v51,
			v55
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v47 = {
		AutomaticSize = Enum.AutomaticSize.X,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		Size = UDim2.fromOffset(0, Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT),
		backgroundStyle = v10.Color.OverMedia.OverMedia_0,
		cornerRadius = UDim.new(0, v10.Radius.Circle),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v10.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = v10.Padding.Small,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar" or nil
	}

	if not v17 then
		v34 = nil
	end

	return createElement(view, v47, {
		ToggleAudioFocusButton = v45,
		ToggleMicButton = v46,
		ChatButton = v34,
		PickExperienceButton = v39,
		EndCallButton = v43,
		DebugVoiceButton = v44
	})
end
