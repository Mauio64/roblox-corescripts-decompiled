local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local CrossExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperience")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local VoiceChat = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/VoiceChat")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local react = dependencies.React
local foundation = dependencies.Foundation
local sharedFlags = dependencies.SharedFlags

local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local voiceStatus = CrossExperience.Utils.VoiceStatus
local voiceStatusChanged = CrossExperience.Actions.VoiceStatusChanged
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useLocalization = dependencies.Hooks.useLocalization
local useDispatch = dependencies.Hooks.useDispatch
local useTokens = foundation.Hooks.useTokens
local useNavigation = dependencies.useNavigation
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadId
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId
local useStore = dependencies.Hooks.useStore
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local getFFlagEnableCrossExpVoiceMemoryCheck = sharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local fFlagEnableVoiceEuConsentPrompt = sharedFlags.FFlagEnableVoiceEuConsentPrompt
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local useIsAnyOtherUserPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useIsAnyOtherUserPartyVoiceEligible")
local useIsLocalPlayerPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useIsLocalPlayerPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useIsCurrentSquadPartyVoiceEligible

local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants").SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants").SQUAD_VOICE_EU_MODAL_SEEN_KEY
local getTableAppStorageKey = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/appStorageAccess").getTableAppStorageKey
local displayEuConsentPrompt = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/displayEuConsentPrompt")

local defineFastString = game:DefineFastString("PartyVoiceBannerErrorUserNotEligibleURL", "")
local defineFastFlag = game:DefineFastFlag("DisallowSquadLobbyBannersInlineButtons", false)
local defineFastFlag2 = game:DefineFastFlag("DisablePartyVoiceEligibilityBanner", false)

function LUAUFORGE_MODULE_GLOBALS_htR_openWebview(title, url)
	if not game:GetEngineFeature("SetWebViewTitle") then
		title = nil
	end

	GuiService:BroadcastNotification(
		HttpService:JSONEncode({
			title = title,
			presentationStyle = 0,
			visible = true,
			url = url
		}),
		20
	)
end

local function fn(props)
	local v5 = useTokens()
	local v6 = props.isButtonInline and not defineFastFlag

	local v7 = react.useMemo(function()
		local createElement = react.createElement
		local text = foundation.Text
		local v8 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v5.Color.None,
			colorstyle = v5.Color.Content.Emphasis,
			fontStyle = v5.Typography.BodySmall,
			LayoutOrder = 1,
			Text = props.label,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.None,
			TextWrapped = true,
			testId = 0
		}

		local v9 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--label` else nil
		v8.testId = v9
		local children = { createElement(text, v8) }

		if not props.sublabels then
			return children
		end

		for i, sublabel in ipairs(props.sublabels) do
			if not (sublabel and sublabel ~= "") then
				continue
			end

			local createElement2 = react.createElement
			local text2 = foundation.Text
			local v10 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v5.Color.None,
				colorstyle = v5.Color.Content.Emphasis,
				fontStyle = v5.Typography.BodySmall,
				LayoutOrder = i + 1,
				Text = sublabel,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				TextWrapped = true,
				RichText = true,
				testId = 0
			}

			local v11 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--sublabel-{i}` else nil
			v10.testId = v11
			table.insert(children, createElement2(text2, v10))
		end

		return children
	end, { props.label, props.sublabels, props.testId })

	local createElement = react.createElement
	local v9 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = v5.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = v5.Color.Surface.Surface_200.Transparency,
		LayoutOrder = props.LayoutOrder
	}
	local children = {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.Radius.Small)
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5.Gap.XLarge),
			PaddingRight = UDim.new(0, v5.Gap.XLarge),
			PaddingTop = UDim.new(0, v5.Gap.Medium),
			PaddingBottom = UDim.new(0, v5.Gap.Medium)
		}),
		UIListLayout = 0,
		TextFrame = 0,
		InlineButton = 0,
		BottomButton = 0
	}

	local createElement2 = react.createElement
	local v12 = if v6 then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical
	local v13 = if v6 then UDim.new(0, v5.Gap.XSmall) else UDim.new(0, v5.Gap.Medium)
	local v11 = {
		FillDirection = v12,
		Padding = v13,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Wraps = not v6,
		HorizontalFlex = 0,
		VerticalFlex = 0
	}

	local v14 = if v6 then Enum.UIFlexAlignment.SpaceBetween else Enum.UIFlexAlignment.Fill
	v11.HorizontalFlex = v14
	local v15 = if v6 then Enum.UIFlexAlignment.Fill else Enum.UIFlexAlignment.None
	v11.VerticalFlex = v15
	children.UIListLayout = createElement2("UIListLayout", v11)

	children.TextFrame = react.createElement(
		foundation.View,
		{ tag = "col auto-xy gap-small wrap", LayoutOrder = 1, testId = props.testId },
		v7
	)
	local v16

	if props.onActivated and v6 then
		local createElement3 = react.createElement
		local button = foundation.Button
		local v17 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			text = props.buttonLabel,
			variant = foundation.Enums.ButtonVariant.Link,
			onActivated = props.onActivated,
			testId = 0
		}
		local v18 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--button` else nil
		v17.testId = v18
		v16 = createElement3(button, v17)
	end

	children.InlineButton = v16
	local v17

	if props.onActivated and not v6 then
		local createElement3 = react.createElement
		local button = foundation.Button
		local v18 = {
			LayoutOrder = 2,
			text = props.buttonLabel,
			variant = foundation.Enums.ButtonVariant.Standard,
			size = foundation.Enums.ButtonSize.Small,
			onActivated = props.onActivated,
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			testId = 0
		}
		local v19 = if FFlagSquadsEnableFoundationTestIds then `{props.testId}--button` else nil
		v18.testId = v19
		v17 = createElement3(button, v18)
	end

	children.BottomButton = v17
	return createElement("Frame", v9, children)
end

local function fn2(p2)
	local v5 = useLocalUserId()
	local v6 = useDispatch()
	local v7 = react.useContext(squadExternalContractContext)
	local state, setState = react.useState(false)

	local tableAppStorageKey = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)
	local tableAppStorageKey2 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)

	react.useEffect(function()
		if tableAppStorageKey[tostring(v5)] and not tableAppStorageKey2[tostring(v5)] then
			setState(true)
		end
	end, { HttpService:JSONEncode(tableAppStorageKey), HttpService:JSONEncode(tableAppStorageKey2) })

	react.useEffect(function()
		local eventConnection = default.VoiceEuModalConsented.Event:Connect(function()
			setState(false)
		end)

		local eventConnection2 = default.VoiceEuModalRefused.Event:Connect(function()
			setState(true)
		end)
		return function()
			eventConnection:Disconnect()
			eventConnection2:Disconnect()
		end
	end, {})

	if state then
		return (react.createElement(fn, {
			LayoutOrder = p2.LayoutOrder,
			label = "Give consent to the voice recording policy in order to access voice chat.",
			buttonLabel = "Connect",
			isButtonInline = true,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-eu-consent" or nil,
			onActivated = function()
				v6(displayEuConsentPrompt(v7.setSquadPrompt, tostring(v5), tableAppStorageKey, tableAppStorageKey2))
			end
		}))
	end

	return nil
end

local function fn3(p2)
	local v5 = useDispatch()
	local v6 = useStore()
	local v7 = react.useContext(squadExternalContractContext)
	local v8 = useCurrentSquadId() or ""
	local v9 = useVoiceStatus()

	local v10 = v9 == CrossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED
	local v11 = voiceStatus.isVoiceRetriableErrorByGameJoin(v9)
		or voiceStatus.isVoiceRetriableErrorByVoiceJoin(v9)
	local v12 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorGeneral",
		errorButton = "Feature.Squads.Action.VoiceErrorGeneral"
	})

	local v13 = react.useCallback(function()
		local function fn4(p3)
			v5(voiceStatusChanged({
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))

			default:join({ partyId = v8, force = true, shouldIgnoreMemoryWarning = p3 })
		end

		if getFFlagEnableCrossExpVoiceMemoryCheck() and v10 then
			if default:performJoinFeasibilityCheck() then
				fn4()
			else
				v7.setSquadPrompt(v6, {
					hideCancelButton = false,
					promptType = squadPromptType.ConnectVoiceWithLowMemory,
					onConfirm = function() end,
					onCancel = function()
						fn4(true)
					end
				})
			end
		elseif voiceStatus.isVoiceRetriableErrorByGameJoin(v9) then
			if getFFlagEnableCrossExpVoiceMemoryCheck() then
				fn4()
				return
			end

			v5(voiceStatusChanged({
				status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING
			}))

			default:join({ partyId = v8, force = true })
		elseif voiceStatus.isVoiceRetriableErrorByVoiceJoin(v9) then
			default:rejoinVoice()
		end
	end, { v9, v8, v10 })

	v11 = getFFlagEnableCrossExpVoiceMemoryCheck() and v10 or v11

	if not v11 then
		return nil
	end

	local createElement = react.createElement
	local v15 = {
		LayoutOrder = p2.LayoutOrder,
		label = v12.errorText,
		buttonLabel = v12.errorButton,
		isButtonInline = true,
		onActivated = 0,
		testId = 0
	}

	if v8 == "" then
		v13 = nil
	end

	v15.onActivated = v13
	v15.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-voice-error" or nil
	return (createElement(fn, v15))
end

local function fn4(p2)
	local v5 = useIsCurrentSquadPartyVoiceEligible()
	local v6 = useIsLocalPlayerPartyVoiceEligible()
	local v7 = useIsAnyOtherUserPartyVoiceEligible()
	local v8 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorUserIneligible",
		errorButton = "Feature.Squads.Action.VoiceErrorUserIneligible"
	})

	local v9 = useAppPolicy(function(p3)
		return p3.getWebViewSupport()
	end)

	local v10 = react.useCallback(function()
		if defineFastString ~= "" then
			LUAUFORGE_MODULE_GLOBALS_htR_openWebview(v8.errorButton, defineFastString)
		end
	end, { v8.errorButton })

	if not v5 or v6 or not v7 then
		return nil
	end

	local createElement = react.createElement
	local v12 = {
		LayoutOrder = p2.LayoutOrder,
		label = v8.errorText,
		buttonLabel = v8.errorButton,
		isButtonInline = false,
		onActivated = 0,
		testId = 0
	}

	if not v9 or defineFastString == "" then
		v10 = nil
	end

	v12.onActivated = v10

	v12.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-user-voice-ineligible" or nil
	return createElement(fn, v12)
end

local function fn5(p2)
	local v5 = useVoiceStatus()
	local v6 = useCurrentSquadId() or ""
	local v7 = react.useMemo(function()
		return VoiceChat.Utils.GetSettingsAppAvailable()
	end, {})

	local v8 = useAppPolicy(function(p3)
		return p3
	end)

	local v11 = useLocalization({
		errorText = "Feature.SettingsHub.Prompt.Subtitle.AllowMicrophoneAccess",
		errorSubtext1 = react.useMemo(function()
			return (if v7 then v8.getMicSettingsDeeplinkDirectionsLocaleKey() else v8.getMicSettingsDirectionsLocaleKey())
				or nil
		end, { v8, v7 }),
		errorSubtext2 = react.useMemo(function(): nil | string
			if v8.getRequiresAppRestartOnMicAccessChange() then
				return "Feature.SettingsHub.Prompt.RestartOnMicAccessChange"
			end

			return nil
		end, { v8, v7 }),
		errorButton = "Feature.SettingsHub.Action.OpenSettings"
	})

	local micPermissionsError = voiceStatus.isMicPermissionsError(v5)

	local v12 = react.useCallback(function()
		pcall(function()
			VoiceChat.Utils.SwitchToMicrophoneSettings()
		end)
	end, {})

	if not micPermissionsError then
		return nil
	end

	local createElement = react.createElement
	local v14 = {
		LayoutOrder = p2.LayoutOrder,
		label = v11.errorText,
		sublabels = { v11.errorSubtext1, v11.errorSubtext2 },
		buttonLabel = v11.errorButton,
		isButtonInline = true,
		onActivated = 0,
		testId = 0
	}

	if v6 == "" or not v7 then
		v12 = nil
	end

	v14.onActivated = v12
	v14.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-mic-permissions" or nil
	return (createElement(fn, v14))
end

local function fn6(p2)
	local v5 = useNavigation()
	local v6 = useCurrentSquadParentChannelId() or ""
	local v7 = useIsCurrentSquadPartyVoiceEligible()
	local v8 = useIsLocalPlayerPartyVoiceEligible()

	if v7 ~= false then
		v8 = false
	end

	local v9 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorPartyNotVoiceEligible",
		errorButton = "Feature.Squads.Action.VoiceErrorPartyNotVoiceEligible"
	})

	local v10 = react.useCallback(function()
		if v6 ~= "" then
			pcall(function()
				v5.navigate("CreateUnfilteredChatPartialModal", { conversationId = v6 })
			end)
		end
	end, { v6, v5 })

	if v8 then
		return react.createElement(fn, {
			LayoutOrder = p2.LayoutOrder,
			label = v9.errorText,
			buttonLabel = v9.errorButton,
			isButtonInline = false,
			onActivated = v10,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-party-voice-ineligible" or nil
		})
	end

	return nil
end

return function(p2)
	local v5 = useTokens()
	local v6 = react.useCallback(function(p3)
		if p3 then
			p2.onAbsoluteSizeChanged(p3.AbsoluteSize)
		end
	end, { p2.onAbsoluteSizeChanged })

	local createElement = react.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		[react.Change.AbsoluteSize] = v6
	}
	local v9 = {
		UIPadding = react.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v5.Padding.XLarge),
			PaddingRight = UDim.new(0, v5.Padding.XLarge)
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		VoiceErrorBanner = 0,
		PartyVoiceEligibilityBanner = 0,
		PartyVoiceUserEligibilityBanner = 0,
		VoiceMicPermissionsBanner = 0,
		VoiceEuModalConnectBanner = 0
	}

	local v10 = if getFFlagEnableCrossExpVoice() then react.createElement(fn3, {
		LayoutOrder = 1
	}) else nil
	v9.VoiceErrorBanner = v10

	local v11 = if getFFlagEnableCrossExpVoice() and not defineFastFlag2 then react.createElement(fn6, {
		LayoutOrder = 2
	}) else nil
	v9.PartyVoiceEligibilityBanner = v11

	local v12 = if getFFlagEnableCrossExpVoice() then react.createElement(fn4, {
		LayoutOrder = 3
	}) else nil
	v9.PartyVoiceUserEligibilityBanner = v12

	local v13 = if getFFlagEnableCrossExpVoice() then react.createElement(fn5, {
		LayoutOrder = 4
	}) else nil
	v9.VoiceMicPermissionsBanner = v13

	local v14 = if getFFlagEnableCrossExpVoice() and fFlagEnableVoiceEuConsentPrompt then react.createElement(fn2, {
		LayoutOrder = 5
	}) else nil
	v9.VoiceEuModalConnectBanner = v14
	return createElement("Frame", v8, v9)
end
