local HttpService = game:GetService("HttpService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ExpChatShared = require(parent.ExpChatShared)
local SignalsReact = require(parent.SignalsReact)

local Config = require(ExpChat.Config)
local Constants = require(ExpChat.PresetChat.Constants)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local Localization = require(ExpChat.Localization)
local PresetChatTooltip = require(script.Parent.PresetChatTooltip)
local hasPresetEmoji = require(script.Parent.hasPresetEmoji)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatCenterMobilePresetButton = require(ExpChat.Flags.FFlagExpChatCenterMobilePresetButton)
local FFlagExpChatPresetFullWidthButtonFixes = require(ExpChat.Flags.FFlagExpChatPresetFullWidthButtonFixes)
local FFlagExpChatPresetEntryPointClickAction = require(ExpChat.Flags.FFlagExpChatPresetEntryPointClickAction)

local FFlagExpChatPresetChatCircleFaceEmojiEntryPointRolloutEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatCircleFaceEmojiEntryPointRolloutEnabled)

local SocialExperiments = require(parent.SocialExperiments)
local ExpChatPresetChatEmojiTabExperimentation = SocialExperiments.ExpChatPresetChatEmojiTabExperimentation

local function PresetChatButton(props)
	local ref = React.useRef(false)
	local anchorRef

	if FFlagExpChatPresetFullWidthButtonFixes then
		anchorRef = React.useRef(nil)
	end

	local ref2

	if FFlagExpChatPresetFullWidthButtonFixes then
		ref2 = React.useRef(nil)
	end

	if props.fullWidth then
		anchorRef = ref2
	end

	local v = Localization.useLocalization({
		sendQuickWords = "CoreScripts.TextChat.Action.SendQuickWords"
	})

	local presetChatStore = GetPresetChatStore(false)
	local v2 = SignalsReact.useSignalState(presetChatStore.getIsTrayOpen)

	local v3 = false

	if FFlagExpChatPresetChatCircleFaceEmojiEntryPointRolloutEnabled then
		local v4 = SignalsReact.useSignalState(presetChatStore.getCategoryGroups)
		v3 = React.useMemo(function()
			return hasPresetEmoji(v4)
		end, { v4 })
	elseif ExpChatPresetChatEmojiTabExperimentation.isExperimentEnabled then
		v3 = ExpChatPresetChatEmojiTabExperimentation.getIsEmojiIconEnabled()
	end

	local onActivated = React.useCallback(function()
		if FFlagExpChatUseUnifiedTooltipStore then
			local chatTooltipStore = GetChatTooltipStore(false)

			if not ref.current then
				ref.current = true
				chatTooltipStore.reportImpression("PresetChatTooltip")
			end

			chatTooltipStore.setIsDismissed("PresetChatTooltip", true)
		end

		local isTrayOpen = presetChatStore.getIsTrayOpen(false)
		setIsPresetTrayOpen(presetChatStore, not isTrayOpen)
		local analytics = ExpChatShared.Analytics
		local expChatPresetActionConfig = ExpChatShared.Analytics.ExpChatPresetActionConfig
		local v4 = {
			event_type = Constants.Analytics.EventTypes.Click,
			component = Constants.Analytics.Components.PresetEntryPointButton,
			extra_json = 0
		}
		local extra_json

		if FFlagExpChatPresetEntryPointClickAction then
			local click_action

			if isTrayOpen then
				click_action = Constants.Analytics.ClickActions.Close
			else
				click_action = Constants.Analytics.ClickActions.Open
			end

			extra_json = HttpService:JSONEncode({ click_action = click_action })
		end

		v4.extra_json = extra_json
		analytics:TelemetryLogEvent(expChatPresetActionConfig, v4, ExpChatShared.Analytics.DefaultStandardizedFields)
	end, { presetChatStore })
	local v4

	if props.fullWidth then
		local createElement = React.createElement
		local button = Foundation.Button
		local v5 = {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			onActivated = onActivated,
			text = v.sendQuickWords,
			variant = Foundation.Enums.ButtonVariant.Standard,
			width = UDim.new(1, 0),
			ref = 0,
			testId = "--social-exp-chat-button-send-quick-words"
		}
		local ref3

		if FFlagExpChatPresetFullWidthButtonFixes then
			ref3 = anchorRef
		end

		v5.ref = ref3
		v4 = createElement(button, v5)
	else
		local createElement = React.createElement
		local iconButton = Foundation.IconButton
		local name

		if v3 then
			name = Config.PresetChat.EmojiIcon
		else
			name = Config.PresetChat.Icon
		end

		local variant

		if v2 then
			variant = Config.PresetChat.IconVariantActive
		else
			variant = Config.PresetChat.IconVariant
		end

		local v5 = {
			icon = { name = name, variant = variant },
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = 0,
			isCircular = 0,
			isDisabled = false,
			onActivated = 0,
			ref = 0,
			testId = "--social-exp-chat-iconbutton-quick-words"
		}
		local size

		if props.size == nil then
			size = Foundation.Enums.InputSize.Small
		else
			size = props.size
		end

		v5.size = size
		v5.isCircular = props.isCircular == nil or props.isCircular

		v5.onActivated = onActivated
		local ref3

		if FFlagExpChatPresetFullWidthButtonFixes then
			ref3 = anchorRef
		end

		v5.ref = ref3
		v4 = createElement(iconButton, v5)
	end

	local createElement = React.createElement
	local v5 = { targetTextChannel = props.targetTextChannel, anchorRef = 0 }

	if not FFlagExpChatPresetFullWidthButtonFixes then
		anchorRef = nil
	end

	v5.anchorRef = anchorRef
	local element = createElement(PresetChatTooltip, v5, v4)

	if FFlagExpChatCenterMobilePresetButton and props.addTopPadding ~= nil then
		return React.createElement(Foundation.View, {
			tag = {
				["size-full-0 auto-y"] = FFlagExpChatPresetFullWidthButtonFixes and props.fullWidth == true,
				["auto-xy"] = not FFlagExpChatPresetFullWidthButtonFixes or props.fullWidth ~= true
			},
			padding = {
				top = UDim.new(0, props.addTopPadding and 8 or 0),
				bottom = UDim.new(0, 1)
			}
		}, element)
	end

	return element
end

return React.memo(PresetChatButton)
