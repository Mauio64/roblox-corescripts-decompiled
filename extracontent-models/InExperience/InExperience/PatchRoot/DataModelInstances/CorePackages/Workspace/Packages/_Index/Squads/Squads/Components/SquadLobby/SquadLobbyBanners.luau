local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local Squads = script:FindFirstAncestor("Squads")

local parent = Squads.Parent
local CrossExperience = require(parent.CrossExperience)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local VoiceChat = require(parent.VoiceChat)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local useAppPolicy = UniversalAppPolicy.useAppPolicy

local dependencies = require(Squads.dependencies)

local react = dependencies.React
local foundation = dependencies.Foundation
local sharedFlags = dependencies.SharedFlags

local default = CrossExperienceVoice.CrossExperienceVoiceManager.default
local VoiceStatus = CrossExperience.Utils.VoiceStatus
local VoiceStatusChanged = CrossExperience.Actions.VoiceStatusChanged
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus
local useLocalization = dependencies.Hooks.useLocalization
local useDispatch = dependencies.Hooks.useDispatch
local useTokens = foundation.Hooks.useTokens
local useNavigation = dependencies.useNavigation
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local Hooks2 = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks2.useCurrentSquadParentChannelId
local useStore = dependencies.Hooks.useStore
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local getFFlagEnableCrossExpVoiceMemoryCheck = sharedFlags.getFFlagEnableCrossExpVoiceMemoryCheck
local fFlagEnableVoiceEuConsentPrompt = sharedFlags.FFlagEnableVoiceEuConsentPrompt
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local useIsAnyOtherUserPartyVoiceEligible = require(Squads.Hooks.useIsAnyOtherUserPartyVoiceEligible)
local Hooks3 = require(parent.SquadsCore.Hooks)
local useIsLocalPlayerPartyVoiceEligible = Hooks3.useIsLocalPlayerPartyVoiceEligible
local Hooks4 = require(parent.SquadsCore.Hooks)
local useIsCurrentSquadPartyVoiceEligible = Hooks4.useIsCurrentSquadPartyVoiceEligible

local Constants = require(parent.SquadsCore.Constants)
local SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY = Constants.SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY
local Constants2 = require(parent.SquadsCore.Constants)
local SQUAD_VOICE_EU_MODAL_SEEN_KEY = Constants2.SQUAD_VOICE_EU_MODAL_SEEN_KEY
local appStorageAccess = require(parent.SquadsCore.appStorageAccess)
local getTableAppStorageKey = appStorageAccess.getTableAppStorageKey
local displayEuConsentPrompt = require(parent.SquadsCore.displayEuConsentPrompt)

local defineFastString = game:DefineFastString("PartyVoiceBannerErrorUserNotEligibleURL", "")
local defineFastFlag = game:DefineFastFlag("DisallowSquadLobbyBannersInlineButtons", false)
local defineFastFlag2 = game:DefineFastFlag("DisablePartyVoiceEligibilityBanner", false)

function openWebview(title: string, url: string)
	if not game:GetEngineFeature("SetWebViewTitle") then
		title = nil
	end

	GuiService:BroadcastNotification(
		HttpService:JSONEncode({ title = title, presentationStyle = 0, visible = true, url = url }),
		20
	)
end

local function fn(props)
	local v = useTokens()
	local v2 = props.isButtonInline and not defineFastFlag

	local v3 = react.useMemo(function()
		local createElement = react.createElement
		local text = foundation.Text
		local v3 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = v.Color.None,
			colorstyle = v.Color.Content.Emphasis,
			fontStyle = v.Typography.BodySmall,
			LayoutOrder = 1,
			Text = props.label,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.None,
			TextWrapped = true,
			testId = 0
		}
		local testId

		if FFlagSquadsEnableFoundationTestIds then
			testId = `{props.testId}--label`
		end

		v3.testId = testId
		local children = { createElement(text, v3) }

		if not props.sublabels then
			return children
		end

		for i, sublabel in ipairs(props.sublabels) do
			if not (sublabel and sublabel ~= "") then
				continue
			end

			local createElement2 = react.createElement
			local text2 = foundation.Text
			local v4 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v.Color.None,
				colorstyle = v.Color.Content.Emphasis,
				fontStyle = v.Typography.BodySmall,
				LayoutOrder = i + 1,
				Text = sublabel,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.None,
				TextWrapped = true,
				RichText = true,
				testId = 0
			}
			local testId2

			if FFlagSquadsEnableFoundationTestIds then
				testId2 = `{props.testId}--sublabel-{i}`
			end

			v4.testId = testId2
			table.insert(children, createElement2(text2, v4))
		end

		return children
	end, { props.label, props.sublabels, props.testId })

	local createElement = react.createElement
	local v4 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = v.Color.Surface.Surface_200.Color3,
		BackgroundTransparency = v.Color.Surface.Surface_200.Transparency,
		LayoutOrder = props.LayoutOrder
	}
	local children = {
		UICorner = react.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Small) }),
		UIPadding = react.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Gap.XLarge),
			PaddingRight = UDim.new(0, v.Gap.XLarge),
			PaddingTop = UDim.new(0, v.Gap.Medium),
			PaddingBottom = UDim.new(0, v.Gap.Medium)
		}),
		UIListLayout = 0,
		TextFrame = 0,
		InlineButton = 0,
		BottomButton = 0
	}

	local createElement2 = react.createElement
	local fillDirection

	if v2 then
		fillDirection = Enum.FillDirection.Horizontal
	else
		fillDirection = Enum.FillDirection.Vertical
	end

	local padding

	if v2 then
		padding = UDim.new(0, v.Gap.XSmall)
	else
		padding = UDim.new(0, v.Gap.Medium)
	end

	local v5 = {
		FillDirection = fillDirection,
		Padding = padding,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Wraps = not v2,
		HorizontalFlex = 0,
		VerticalFlex = 0
	}
	local horizontalFlex

	if v2 then
		horizontalFlex = Enum.UIFlexAlignment.SpaceBetween
	else
		horizontalFlex = Enum.UIFlexAlignment.Fill
	end

	v5.HorizontalFlex = horizontalFlex
	local verticalFlex

	if v2 then
		verticalFlex = Enum.UIFlexAlignment.Fill
	else
		verticalFlex = Enum.UIFlexAlignment.None
	end

	v5.VerticalFlex = verticalFlex
	children.UIListLayout = createElement2("UIListLayout", v5)

	children.TextFrame = react.createElement(
		foundation.View,
		{ tag = "col auto-xy gap-small wrap", LayoutOrder = 1, testId = props.testId },
		v3
	)
	local inlineButton

	if props.onActivated and v2 then
		local createElement3 = react.createElement
		local button = foundation.Button
		local v6 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			text = props.buttonLabel,
			variant = foundation.Enums.ButtonVariant.Link,
			onActivated = props.onActivated,
			testId = 0
		}
		local testId

		if FFlagSquadsEnableFoundationTestIds then
			testId = `{props.testId}--button`
		end

		v6.testId = testId
		inlineButton = createElement3(button, v6)
	end

	children.InlineButton = inlineButton
	local bottomButton

	if props.onActivated and not v2 then
		local createElement3 = react.createElement
		local button = foundation.Button
		local v6 = {
			LayoutOrder = 2,
			text = props.buttonLabel,
			variant = foundation.Enums.ButtonVariant.Standard,
			size = foundation.Enums.ButtonSize.Small,
			onActivated = props.onActivated,
			fillBehavior = foundation.Enums.FillBehavior.Fill,
			testId = 0
		}
		local testId

		if FFlagSquadsEnableFoundationTestIds then
			testId = `{props.testId}--button`
		end

		v6.testId = testId
		bottomButton = createElement3(button, v6)
	end

	children.BottomButton = bottomButton
	return createElement("Frame", v4, children)
end

local function fn2(p)
	local v = useLocalUserId()
	local v2 = useDispatch()
	local v3 = react.useContext(SquadExternalContractContext)
	local state, setState = react.useState(false)

	local tableAppStorageKey = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_SEEN_KEY)
	local tableAppStorageKey2 = getTableAppStorageKey(SQUAD_VOICE_EU_MODAL_CONSENT_GIVEN_KEY)

	react.useEffect(function()
		if tableAppStorageKey[tostring(v)] and not tableAppStorageKey2[tostring(v)] then
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
			LayoutOrder = p.LayoutOrder,
			label = "Give consent to the voice recording policy in order to access voice chat.",
			buttonLabel = "Connect",
			isButtonInline = true,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-eu-consent" or nil,
			onActivated = function()
				v2(displayEuConsentPrompt(v3.setSquadPrompt, tostring(v), tableAppStorageKey, tableAppStorageKey2))
			end
		}))
	end

	return nil
end

local function fn3(p)
	local v = useDispatch()
	local v2 = useStore()
	local v3 = react.useContext(SquadExternalContractContext)
	local partyId = useCurrentSquadId() or ""
	local v4 = useVoiceStatus()

	local v5 = v4 == CrossExperience.Constants.VOICE_STATUS.ERROR_JOIN_FEASIBILITY_CHECK_FAILED
	local v6 = VoiceStatus.isVoiceRetriableErrorByGameJoin(v4) or VoiceStatus.isVoiceRetriableErrorByVoiceJoin(v4)
	local v7 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorGeneral",
		errorButton = "Feature.Squads.Action.VoiceErrorGeneral"
	})

	local onActivated = react.useCallback(function()
		local function fn4(shouldIgnoreMemoryWarning: boolean?)
			v(VoiceStatusChanged({ status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING }))

			default:join({
				partyId = partyId,
				force = true,
				shouldIgnoreMemoryWarning = shouldIgnoreMemoryWarning
			})
		end

		if getFFlagEnableCrossExpVoiceMemoryCheck() and v5 then
			if default:performJoinFeasibilityCheck() then
				fn4()
			else
				v3.setSquadPrompt(v2, {
					hideCancelButton = false,
					promptType = SquadPromptType.ConnectVoiceWithLowMemory,
					onConfirm = function() end,
					onCancel = function()
						fn4(true)
					end
				})
			end
		elseif VoiceStatus.isVoiceRetriableErrorByGameJoin(v4) then
			if getFFlagEnableCrossExpVoiceMemoryCheck() then
				fn4()
				return
			end

			v(VoiceStatusChanged({ status = CrossExperience.Constants.VOICE_STATUS.RCC_CONNECTING }))

			default:join({ partyId = partyId, force = true })
		elseif VoiceStatus.isVoiceRetriableErrorByVoiceJoin(v4) then
			default:rejoinVoice()
		end
	end, { v4, partyId, v5 })

	v6 = getFFlagEnableCrossExpVoiceMemoryCheck() and v5 or v6

	if not v6 then
		return nil
	end

	local createElement = react.createElement
	local v8 = {
		LayoutOrder = p.LayoutOrder,
		label = v7.errorText,
		buttonLabel = v7.errorButton,
		isButtonInline = true,
		onActivated = 0,
		testId = 0
	}

	if partyId == "" then
		onActivated = nil
	end

	v8.onActivated = onActivated
	v8.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-voice-error" or nil
	return (createElement(fn, v8))
end

local function fn4(p)
	local v = useIsCurrentSquadPartyVoiceEligible()
	local v2 = useIsLocalPlayerPartyVoiceEligible()
	local v3 = useIsAnyOtherUserPartyVoiceEligible()
	local v4 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorUserIneligible",
		errorButton = "Feature.Squads.Action.VoiceErrorUserIneligible"
	})

	local v5 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local onActivated = react.useCallback(function()
		if defineFastString ~= "" then
			openWebview(v4.errorButton, defineFastString)
		end
	end, { v4.errorButton })

	if not v or v2 or not v3 then
		return nil
	end

	local createElement = react.createElement
	local v6 = {
		LayoutOrder = p.LayoutOrder,
		label = v4.errorText,
		buttonLabel = v4.errorButton,
		isButtonInline = false,
		onActivated = 0,
		testId = 0
	}

	if not v5 or defineFastString == "" then
		onActivated = nil
	end

	v6.onActivated = onActivated

	v6.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-user-voice-ineligible" or nil
	return createElement(fn, v6)
end

local function fn5(p)
	local v = useVoiceStatus()
	local v2 = useCurrentSquadId() or ""
	local v3 = react.useMemo(function()
		return VoiceChat.Utils.GetSettingsAppAvailable()
	end, {})

	local v4 = useAppPolicy(function(p2)
		return p2
	end)

	local v5 = useLocalization({
		errorText = "Feature.SettingsHub.Prompt.Subtitle.AllowMicrophoneAccess",
		errorSubtext1 = react.useMemo(function()
			local v5

			if v3 then
				v5 = v4.getMicSettingsDeeplinkDirectionsLocaleKey()
			else
				v5 = v4.getMicSettingsDirectionsLocaleKey()
			end

			return v5 or nil
		end, { v4, v3 }),
		errorSubtext2 = react.useMemo(function(): nil | string
			if v4.getRequiresAppRestartOnMicAccessChange() then
				return "Feature.SettingsHub.Prompt.RestartOnMicAccessChange"
			end

			return nil
		end, { v4, v3 }),
		errorButton = "Feature.SettingsHub.Action.OpenSettings"
	})

	local micPermissionsError = VoiceStatus.isMicPermissionsError(v)

	local onActivated = react.useCallback(function()
		pcall(function()
			VoiceChat.Utils.SwitchToMicrophoneSettings()
		end)
	end, {})

	if not micPermissionsError then
		return nil
	end

	local createElement = react.createElement
	local v6 = {
		LayoutOrder = p.LayoutOrder,
		label = v5.errorText,
		sublabels = { v5.errorSubtext1, v5.errorSubtext2 },
		buttonLabel = v5.errorButton,
		isButtonInline = true,
		onActivated = 0,
		testId = 0
	}

	if v2 == "" or not v3 then
		onActivated = nil
	end

	v6.onActivated = onActivated
	v6.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-mic-permissions" or nil
	return (createElement(fn, v6))
end

local function fn6(p)
	local v = useNavigation()
	local conversationId = useCurrentSquadParentChannelId() or ""
	local v2 = useIsCurrentSquadPartyVoiceEligible()
	local v3 = useIsLocalPlayerPartyVoiceEligible()

	if v2 ~= false then
		v3 = false
	end

	local v4 = useLocalization({
		errorText = "Feature.Squads.Label.VoiceErrorPartyNotVoiceEligible",
		errorButton = "Feature.Squads.Action.VoiceErrorPartyNotVoiceEligible"
	})

	local onActivated = react.useCallback(function()
		if conversationId ~= "" then
			pcall(function()
				v.navigate("CreateUnfilteredChatPartialModal", { conversationId = conversationId })
			end)
		end
	end, { conversationId, v })

	if v3 then
		return react.createElement(fn, {
			LayoutOrder = p.LayoutOrder,
			label = v4.errorText,
			buttonLabel = v4.errorButton,
			isButtonInline = false,
			onActivated = onActivated,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby-banner-party-voice-ineligible" or nil
		})
	end

	return nil
end

return function(p)
	local v = useTokens()
	local v2 = react.useCallback(function(p2)
		if p2 then
			p.onAbsoluteSizeChanged(p2.AbsoluteSize)
		end
	end, { p.onAbsoluteSizeChanged })

	local createElement = react.createElement
	local v3 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		[react.Change.AbsoluteSize] = v2
	}
	local v4 = {
		UIPadding = react.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Padding.XLarge),
			PaddingRight = UDim.new(0, v.Padding.XLarge)
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Gap.Medium)
		}),
		VoiceErrorBanner = 0,
		PartyVoiceEligibilityBanner = 0,
		PartyVoiceUserEligibilityBanner = 0,
		VoiceMicPermissionsBanner = 0,
		VoiceEuModalConnectBanner = 0
	}
	local voiceErrorBanner

	if getFFlagEnableCrossExpVoice() then
		voiceErrorBanner = react.createElement(fn3, { LayoutOrder = 1 })
	end

	v4.VoiceErrorBanner = voiceErrorBanner
	local partyVoiceEligibilityBanner

	if getFFlagEnableCrossExpVoice() and not defineFastFlag2 then
		partyVoiceEligibilityBanner = react.createElement(fn6, { LayoutOrder = 2 })
	end

	v4.PartyVoiceEligibilityBanner = partyVoiceEligibilityBanner
	local partyVoiceUserEligibilityBanner

	if getFFlagEnableCrossExpVoice() then
		partyVoiceUserEligibilityBanner = react.createElement(fn4, { LayoutOrder = 3 })
	end

	v4.PartyVoiceUserEligibilityBanner = partyVoiceUserEligibilityBanner
	local voiceMicPermissionsBanner

	if getFFlagEnableCrossExpVoice() then
		voiceMicPermissionsBanner = react.createElement(fn5, { LayoutOrder = 4 })
	end

	v4.VoiceMicPermissionsBanner = voiceMicPermissionsBanner
	local voiceEuModalConnectBanner

	if getFFlagEnableCrossExpVoice() and fFlagEnableVoiceEuConsentPrompt then
		voiceEuModalConnectBanner = react.createElement(fn2, { LayoutOrder = 5 })
	end

	v4.VoiceEuModalConnectBanner = voiceEuModalConnectBanner
	return createElement("Frame", v3, v4)
end
