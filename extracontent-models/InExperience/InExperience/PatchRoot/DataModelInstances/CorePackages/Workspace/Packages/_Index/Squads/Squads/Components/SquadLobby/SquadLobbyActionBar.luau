local Squads = script:FindFirstAncestor("Squads")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local parent = Squads.Parent
require(parent.CrossExperience)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SocialCommon = require(parent.SocialCommon)
local UIBlox = require(parent.UIBlox)
local VoiceChat = require(parent.VoiceChat)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local Constants = require(Squads.Common.Constants)
local dependencies = require(Squads.dependencies)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
local FFlagSquadLobbyActionBarFixMicLevelRerender = require(Squads.Flags.FFlagSquadLobbyActionBarFixMicLevelRerender)

local sharedFlags = dependencies.SharedFlags

local squadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local SquadSessionProvider = require(parent.SquadsCore.SquadSessionProvider)
local SquadLobbySessionProvider = SquadSessionProvider.SquadLobbySessionProvider
local Enums = require(parent.SquadsCore.Enums)
local SquadState = Enums.SquadState
local Thunks = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks.leaveSquad
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization

local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens

local useLastInputMethod = FocusNavigationUtils.useLastInputMethod

local ExternalEventConnection = RoactUtils.ExternalEventConnection

local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
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
local useIsParticipantMuted = CrossExperienceVoice.Hooks.useIsParticipantMuted
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local CrossExperienceVoiceManager = CrossExperienceVoice.CrossExperienceVoiceManager
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local defineFastFlag = game:DefineFastFlag("EnableCrossExpVoiceDebug", false)
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)
local engineFeature = game:GetEngineFeature("AudioFocusManagement")

local defineFastString = game:DefineFastString("SquadExperiencePickerTooltipSeenStorageValue", "True")

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = sharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

local v = squadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled() and "size-800-800"
	or "size-600-600"

local v2 = {
	["icons/menu/platformChatOff"] = "speech-bubble-align-center",
	["icons/common/play"] = "play-large",
	["icons/common/search"] = "magnifying-glass",
	["icons/navigation/close"] = "x",
	["icons/controls/headphone"] = "headphones",
	["icons/actions/truncationCollapse_small"] = "chevron-large-up",
	["icons/status/player/developer"] = "hammer-code"
}

local v3 = squadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled()
	and "icons/common/search"
	or "icons/common/play"

local function getTooltipWasShownFromAppStorage(ftuxAppStorageKey): boolean -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return AppStorageService:GetItem(ftuxAppStorageKey)
	end)

	if success and result ~= nil then
		return result == defineFastString
	end

	return false
end

local function setTooltipWasShownFromAppStorage(ftuxAppStorageKey) -- 1 equivalent call inferred from this helper
	pcall(function()
		AppStorageService:SetItem(ftuxAppStorageKey, defineFastString)
		AppStorageService:Flush()
	end)
end

local function fn(data)
	local v4, v5 = React.useBinding(ControlState.Initialize)
	local v6 = useTokens()
	local v7 = useLastInputMethod()

	local v8 = { headerText = data.tooltipText }

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			return
		end

		if
			data.enableFirstTimeTooltip
			and data.showFtuxCustomConditionsMet
			and (data.currentHoveredButton == "" or data.currentHoveredButton == data.triggerPointName)
			and not getTooltipWasShownFromAppStorage(data.ftuxAppStorageKey) -- inferred equivalent call
		then
			setTooltipWasShownFromAppStorage(data.ftuxAppStorageKey) -- inferred equivalent call

			if data.currentHoveredButton ~= "" then
				return
			end

			setState(true)
		elseif
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

	local callback2 = React.useCallback(function(p)
		if InputUtilities.isActivationInput(p) or v7 == "Gamepad" then
			setState(false)
		end
	end, { v7 })

	local v9 = {
		DisplayOrder = 6,
		disabled = false,
		guiTarget = CoreGui,
		active = 0,
		triggerPointName = 0
	}
	local active

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		active = state
	end

	v9.active = active

	v9.triggerPointName = data.triggerPointName

	local function fn2(p, p2, callback)
		local onStateChanged = React.useCallback(function(p3)
			local v10 = ControlState.fromRawValue(p3)

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				if v10 == ControlState.Hover then
					data.onHoverCalled(data.triggerPointName)
				elseif v10 == ControlState.Default then
					data.onHoverCalled("")
				end
			end

			if callback then
				callback(v4:getValue(), v10)
			end

			v5(v10)
		end, { v4, data.onHoverCalled, data.triggerPointName, v5 })

		local onActivated = React.useCallback(function()
			if data.onActivated then
				data.onActivated(state)
			end
		end, { state, data.onActivated })

		local createElement = React.createElement
		local v10 = {
			AutomaticSize = data.automaticSize,
			LayoutOrder = data.layoutOrder,
			Size = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			[React.Change.AbsolutePosition] = p,
			[React.Change.AbsoluteSize] = p2
		}
		local inputEndedConnection

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and state then
			inputEndedConnection = React.createElement(ExternalEventConnection, {
				event = UserInputService.InputEnded,
				callback = callback2
			})
		end

		local createElement2 = React.createElement
		local view = Foundation.View
		local v11 = {
			Size = UDim2.fromScale(1, 1),
			backgroundStyle = data.backgroundStyle,
			cornerRadius = UDim.new(0, v6.Radius.Circle),
			isDisabled = data.isDisabled,
			onActivated = 0,
			onStateChanged = 0
		}

		if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			onActivated = data.onActivated
		end

		v11.onActivated = onActivated

		v11.onStateChanged = onStateChanged
		return createElement("Frame", v10, {
			InputEndedConnection = inputEndedConnection,
			createElement2(view, v11, data.children)
		})
	end

	local function fn3(p)
		return fn2(p, p, nil)
	end

	local function fn4(p, p2)
		return fn2(p, p, p2)
	end

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and state then
		return (withTooltip(v8, v9, fn3))
	end

	return (withHoverTooltip(v8, v9, fn4))
end

local function tagToSize(p) -- 1 equivalent call inferred from this helper
	return { ["size-600-600"] = p.Size.Size_600, ["size-800-800"] = p.Size.Size_800 }
end

local function renderStandardImage(contentmuted, image, p, p2, testId: string?)
	local name = v2[image]

	if not name then
		return React.createElement(Foundation.Image, {
			Image = image,
			tag = {
				["content-emphasis"] = not contentmuted,
				["content-muted"] = contentmuted,
				["anchor-center-center position-center-center " .. p] = true
			},
			testId = testId
		})
	end

	local v4 = tagToSize(p2) -- inferred equivalent call
	local createElement = React.createElement
	local icon = Foundation.Icon
	local style

	if contentmuted then
		style = p2.Color.Content.Muted
	else
		style = p2.Color.Content.Emphasis
	end

	return createElement(icon, {
		name = name,
		style = style,
		size = v4[p] or v4["size-600-600"],
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		testId = testId
	})
end

local function getLoadingIndicatorIcon(p, p2, flag: boolean?, flag2: boolean?, state: number?)
	local v4 = p.Config.ColorMode.IsLight == "true" and "MicDark" or "MicLight"

	if flag and p2 and not p2.isMuted then
		if flag2 then
			return VoiceChat.Utils.GetIcon("Unmuted", v4, state)
		end

		return VoiceChat.Utils.GetIcon("Unmuted0", v4)
	end

	return VoiceChat.Utils.GetIcon("Muted", v4)
end

local function renderToggleAudioFocusButton(p, audioText, toggleVoiceChatMenu, state, onHoverCalled)
	local createElement = React.createElement
	local v4 = {
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

	v4.currentHoveredButton = state

	v4.enableFirstTimeTooltip = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
		and nil

	v4.ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
		and ""
		or nil

	v4.onActivated = toggleVoiceChatMenu

	if not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		onHoverCalled = nil
	end

	v4.onHoverCalled = onHoverCalled

	v4.showFtuxCustomConditionsMet = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
		and nil

	v4.tooltipText = audioText
	return createElement(fn, v4, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p.Padding.Small),
			PaddingRight = UDim.new(0, p.Padding.Small)
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
	local v4 = useDispatch()
	local v5 = useLocalization({
		audioText = "Feature.Squads.Label.Audio",
		findExperiencesText = squadCoordinationExperienceJoinExperimentation.getIsNewTooltipCopyEnabled() and "Feature.Squads.Label.FindExperiencesPlayTogether" or "Feature.Squads.Label.FindExperiences",
		leavePartyText = "Feature.Squads.Label.LeaveParty",
		muteMicText = "Feature.Squads.Label.MuteMic",
		unmuteMicText = "Feature.Squads.Label.UnmuteMic",
		viewChatText = "Feature.Squads.Label.ViewChat"
	})

	local v6 = useTokens()

	local parentChannelId = useCurrentSquadParentChannelId()
	local v7 = useCurrentSquadSelector()

	local voiceStatus = useVoiceStatus()

	local state, setState = React.useState("")

	local v8 = React.useCallback(function(p)
		setState(p)
	end, {})

	local v9 = v7 and v7.members and #v7.members or 0

	local v10 = useAppPolicy((React.useCallback(function(p)
		return p.getCanUsePlatformChat()
	end, {})))

	local v11 = React.useMemo(function()
		return HttpService:GenerateGUID()
	end, {})
	local v12

	if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v12 = React.useContext(SquadLobbySessionProvider.Context)
	else
		v12 = nil
	end

	local v13 = React.useContext(SquadExternalContractContext)

	local v14 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v13.useIsChatEnabled()

	local onActivated = React.useCallback(function(isFtuxTooltipShown)
		v13.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = parentChannelId,
			actionType = SquadPartySheetActionEnum.ChatButtonClicked,
			isFtuxTooltipShown = isFtuxTooltipShown,
			voiceStatus = voiceStatus
		})

		if parentChannelId and parentChannelId ~= "" and props.navigateToChat then
			props.navigateToChat(parentChannelId)
		else
			props.navigateAwayFromSquad()
		end
	end, {
		props.navigateAwayFromSquad,
		props.navigateToChat,
		parentChannelId,
		v13.fireSquadAnalytics,
		voiceStatus
	})

	local useCallback = React.useCallback
	local function fn2(isFtuxTooltipShown)
		if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
			v12.updateMetadata(
				SessionType.Metadata.SquadLobbyPage.ExperiencePickerUuid,
				HttpService:GenerateGUID(false)
			)
		end

		v13.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = parentChannelId,
			actionType = SquadPartySheetActionEnum.PickExperienceButtonClicked,
			isFtuxTooltipShown = isFtuxTooltipShown,
			voiceStatus = voiceStatus
		})

		if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
			v13.showSearchOverlay(v4)
		else
			props.navigateToHomePage()
		end
	end

	local navigateToHomePage = props.navigateToHomePage
	local fireSquadAnalytics = v13.fireSquadAnalytics
	local v15

	if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
		v15 = v4
	end

	local showSearchOverlay

	if squadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled() then
		showSearchOverlay = v13.showSearchOverlay
	end

	local v16

	if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v16 = v12.updateMetadata
	end

	local onActivated2 = useCallback(fn2, {
		parentChannelId,
		navigateToHomePage,
		fireSquadAnalytics,
		v15,
		showSearchOverlay,
		v16,
		voiceStatus
	})

	local useCallback2 = React.useCallback
	local function fn3(isFtuxTooltipShown)
		v13.fireSquadAnalytics(EventNames.PartySheetAction, {
			parentChannelId = parentChannelId,
			actionType = SquadPartySheetActionEnum.EndCallButtonClicked,
			isFtuxTooltipShown = isFtuxTooltipShown,
			voiceStatus = voiceStatus
		})

		v4(leaveSquad(nil, v13.setSquadPrompt, function()
			props.navigateAwayFromSquad()
		end, v13.squadLocation, not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v14))
	end

	local navigateAwayFromSquad = props.navigateAwayFromSquad

	local fireSquadAnalytics2 = v13.fireSquadAnalytics
	local setSquadPrompt = v13.setSquadPrompt
	local squadLocation = v13.squadLocation
	local v17

	if fFlagPartyDevAPIToRespectThirdPartySettingsEnabled then
		v17 = v14
	end

	local onActivated3 = useCallback2(fn3, {
		v4,
		navigateAwayFromSquad,
		parentChannelId,
		fireSquadAnalytics2,
		setSquadPrompt,
		squadLocation,
		v17,
		voiceStatus
	})

	local isDisabled = props.squadState ~= SquadState.Active

	local useMemo = React.useMemo
	local function fn4()
		local createElement = React.createElement
		local currentHoveredButton

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			currentHoveredButton = state
		end

		local v18 = {
			currentHoveredButton = currentHoveredButton,
			enableFirstTimeTooltip = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
			isDisabled = isDisabled,
			layoutOrder = 2,
			onActivated = onActivated,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "ChatButton"
		}
		local onHoverCalled

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			onHoverCalled = v8
		end

		v18.onHoverCalled = onHoverCalled

		v18.showFtuxCustomConditionsMet = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
			and nil

		v18.tooltipText = v5.viewChatText
		local unreadMessagesBadge

		if props.hasUnreadMessages then
			unreadMessagesBadge = React.createElement(Badge, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, -v6.Size.Size_250, 0, v6.Size.Size_250),
				variant = BadgeVariant.Alert,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--chat-button--unread-badge" or nil
			})
		end

		return createElement(fn, v18, {
			UnreadMessagesBadge = unreadMessagesBadge,
			renderStandardImage(
				isDisabled,
				"icons/menu/platformChatOff",
				"size-800-800",
				v6,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--chat-button--icon" or nil
			)
		})
	end

	local v18

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v18 = state
	end

	local viewChatText = v5.viewChatText
	local v19

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v19 = v8
	end

	local chatButton = useMemo(fn4, {
		v18,
		v6,
		isDisabled,
		viewChatText,
		onActivated,
		v19,
		props.hasUnreadMessages
	})

	local useMemo2 = React.useMemo
	local function fn5()
		if props.isInExperience then
			return nil
		end

		local createElement = React.createElement
		local currentHoveredButton

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			currentHoveredButton = state
		end

		local v20 = {
			currentHoveredButton = currentHoveredButton,
			enableFirstTimeTooltip = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and true or nil,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "SquadExperiencePickerTooltipSeen" or nil,
			isDisabled = isDisabled,
			layoutOrder = 3,
			onActivated = onActivated2,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "PickExperienceButton"
		}
		local onHoverCalled

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			onHoverCalled = v8
		end

		v20.onHoverCalled = onHoverCalled
		local showFtuxCustomConditionsMet

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			showFtuxCustomConditionsMet = v9 >= 2
		end

		v20.showFtuxCustomConditionsMet = showFtuxCustomConditionsMet

		v20.tooltipText = v5.findExperiencesText
		return (createElement(
			fn,
			v20,
			renderStandardImage(
				isDisabled,
				v3,
				v,
				v6,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--pick-experience-button--icon" or nil
			)
		))
	end

	local v20

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v20 = state
	end

	local findExperiencesText = v5.findExperiencesText
	local v21

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v21 = v9
	end

	local v22

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v22 = v8
	end

	local pickExperienceButton = useMemo2(fn5, {
		v20,
		v6,
		isDisabled,
		findExperiencesText,
		v21,
		v22,
		props.isInExperience,
		props.navigateToHomePage
	})

	local useMemo3 = React.useMemo
	local function fn6()
		local backgroundStyle

		if isDisabled then
			backgroundStyle = v6.Color.ActionStandard.Background
		else
			backgroundStyle = v6.Color.System.Alert
		end

		local createElement = React.createElement
		local currentHoveredButton

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			currentHoveredButton = state
		end

		local v23 = {
			backgroundStyle = backgroundStyle,
			currentHoveredButton = currentHoveredButton,
			enableFirstTimeTooltip = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
			ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
			isDisabled = isDisabled,
			layoutOrder = 4,
			onActivated = onActivated3,
			onHoverCalled = 0,
			showFtuxCustomConditionsMet = 0,
			tooltipText = 0,
			triggerPointName = "EndCallButton"
		}
		local onHoverCalled

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			onHoverCalled = v8
		end

		v23.onHoverCalled = onHoverCalled

		v23.showFtuxCustomConditionsMet = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
			and nil

		v23.tooltipText = v5.leavePartyText
		return createElement(
			fn,
			v23,
			renderStandardImage(
				isDisabled,
				"icons/navigation/close",
				"size-600-600",
				v6,
				FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--end-call-button--icon" or nil
			)
		)
	end

	local v23

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v23 = state
	end

	local leavePartyText = v5.leavePartyText
	local v24

	if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
		v24 = v8
	end

	local endCallButton = useMemo3(fn6, { v23, v6, isDisabled, leavePartyText, onActivated3, v24 })

	local debugVoiceButton = nil
	local toggleAudioFocusButton, toggleMicButton

	if getFFlagEnableCrossExpVoice() then
		local v25 = tonumber(useLocalUserId()) or -1
		local ref = React.useRef(0)
		local v26 = useBackgroundExperience()
		local v27 = useParticipant(v25)
		local v28 = useIsVoiceConnected()
		local v29 = useIsVoiceDisconnected()
		local v30 = useIsVoiceFocused() or props.forceIsVoiceFocused
		local v31 = useParticipants()
		local v32 = useIsActiveParticipant(v25)
		local v51

		if FFlagSquadLobbyActionBarFixMicLevelRerender then
			v51 = useIsParticipantMuted(v25) == true
		end

		local state2, setState2 = React.useState(0)
		local v52 = engineFeature

		local onActivated4 = React.useCallback(function(_)
			print("----------- CEV FOREGROUND -----------")
			print("Experience info", HttpService:JSONEncode(v26))
			print("Current Voice Participant", HttpService:JSONEncode(v27))
			print("Squads Store Participants", HttpService:JSONEncode(v31 or {}))
			print("--------------------------------------")
			CrossExperienceVoiceManager.default:dumpDebugData()
		end, { v31, v27 })

		local onActivated5 = React.useCallback(function(_)
			if v27 then
				if v27.isMuted then
					CrossExperienceVoiceManager.default:unmuteVoiceParticipant(v27.userId)
				else
					CrossExperienceVoiceManager.default:muteVoiceParticipant(v27.userId)
				end
			end
		end, { v27 })

		local v55 = not isDisabled

		if v55 then
			if v28 then
				if v27 == nil then
					v55 = false
				else
					v55 = not v27.isMuted and v32 == true
				end
			else
				v55 = v28
			end
		end

		local useEffect = React.useEffect
		local function fn7()
			if FFlagSquadLobbyActionBarFixMicLevelRerender and not v55 then
				return nil
			end

			local renderStepService = props.renderStepService or RunService
			renderStepService:BindToRenderStep(v11, 1, function()
				if ref.current > 3 then
					setState2(math.random())
					ref.current = 0
				else
					ref.current += 1
				end
			end)

			return function()
				renderStepService:UnbindFromRenderStep(v11)
			end
		end

		local v56

		if FFlagSquadLobbyActionBarFixMicLevelRerender then
			v56 = { v55, props.renderStepService }
		else
			v56 = { props.renderStepService }
		end

		useEffect(fn7, v56)

		toggleAudioFocusButton = React.useMemo(function()
			if isDisabled or not (v52 and v28) then
				return nil
			end

			return renderToggleAudioFocusButton(v6, v5.audioText, props.toggleVoiceChatMenu, state, v8)
		end, { v6, v52, state, isDisabled, v28, v5.audioText, v8, props.toggleVoiceChatMenu })

		if defineFastFlag then
			local useMemo4 = React.useMemo
			local function fn8()
				local createElement = React.createElement
				local currentHoveredButton

				if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
					currentHoveredButton = state
				end

				local v58 = {
					currentHoveredButton = currentHoveredButton,
					enableFirstTimeTooltip = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
					ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
					isDisabled = isDisabled,
					layoutOrder = 5,
					onActivated = onActivated4,
					onHoverCalled = 0,
					showFtuxCustomConditionsMet = 0,
					tooltipText = "Debug voice",
					triggerPointName = "DebugVoiceButton"
				}
				local onHoverCalled

				if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
					onHoverCalled = v8
				end

				v58.onHoverCalled = onHoverCalled

				v58.showFtuxCustomConditionsMet = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
					and nil
				return createElement(
					fn,
					v58,
					renderStandardImage(
						isDisabled,
						"icons/status/player/developer",
						"size-600-600",
						v6,
						FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--debug-voice-button--icon" or nil
					)
				)
			end

			local v58

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				v58 = state
			end

			local v59

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				v59 = v8
			end

			debugVoiceButton = useMemo4(fn8, { v58, v6, isDisabled, onActivated4, v59 })
		end

		local useMemo4 = React.useMemo
		local function fn8()
			return getLoadingIndicatorIcon(v6, v27, v28, not isDisabled and v32, state2)
		end

		local v58

		if FFlagSquadLobbyActionBarFixMicLevelRerender then
			v58 = v51
		end

		local image = useMemo4(fn8, { v32, isDisabled, v28, state2, v27, v6, v58 })

		local useMemo5 = React.useMemo
		local function fn9()
			if v29 or not isDisabled and engineFeature and not v30 then
				return nil
			end

			local isDisabled2 = not v28 or v27 == nil or isDisabled
			local v61 = not v28 or not v27 or v27.isMuted

			local createElement = React.createElement
			local currentHoveredButton

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				currentHoveredButton = state
			end

			local v63 = {
				currentHoveredButton = currentHoveredButton,
				enableFirstTimeTooltip = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and nil,
				ftuxAppStorageKey = squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() and "" or nil,
				isDisabled = isDisabled2,
				layoutOrder = 1,
				onActivated = onActivated5,
				onHoverCalled = 0,
				showFtuxCustomConditionsMet = 0,
				tooltipText = 0,
				triggerPointName = "ToggleMicButton"
			}
			local onHoverCalled

			if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
				onHoverCalled = v8
			end

			v63.onHoverCalled = onHoverCalled

			v63.showFtuxCustomConditionsMet = not squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
				and nil
			local tooltipText

			if v61 then
				tooltipText = v5.unmuteMicText
			else
				tooltipText = v5.muteMicText
			end

			v63.tooltipText = tooltipText
			return createElement(
				fn,
				v63,
				renderStandardImage(
					isDisabled2,
					image,
					"size-800-800",
					v6,
					FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar--mic-button--icon" or nil
				)
			)
		end

		local v61

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			v61 = state
		end

		local muteMicText = v5.muteMicText
		local unmuteMicText = v5.unmuteMicText
		local v62

		if squadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled() then
			v62 = v8
		end

		if not FFlagSquadLobbyActionBarFixMicLevelRerender then
			v51 = nil
		end

		toggleMicButton = useMemo5(fn9, {
			v61,
			v6,
			image,
			isDisabled,
			v30,
			v28,
			muteMicText,
			unmuteMicText,
			v62,
			onActivated5,
			v27,
			v29,
			v51
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v25 = {
		AutomaticSize = Enum.AutomaticSize.X,
		AnchorPoint = props.anchorPoint,
		Position = props.position,
		Size = UDim2.fromOffset(0, Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT),
		backgroundStyle = v6.Color.OverMedia.OverMedia_0,
		cornerRadius = UDim.new(0, v6.Radius.Circle),
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v6.Gap.Large),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = v6.Padding.Small,
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-action-bar" or nil
	}

	if not v10 then
		chatButton = nil
	end

	return createElement(view, v25, {
		ToggleAudioFocusButton = toggleAudioFocusButton,
		ToggleMicButton = toggleMicButton,
		ChatButton = chatButton,
		PickExperienceButton = pickExperienceButton,
		EndCallButton = endCallButton,
		DebugVoiceButton = debugVoiceButton
	})
end
