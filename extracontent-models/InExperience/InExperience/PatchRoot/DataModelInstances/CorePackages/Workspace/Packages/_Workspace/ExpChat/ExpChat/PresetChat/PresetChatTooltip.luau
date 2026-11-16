local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local Coachmark = Foundation.Coachmark
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local FFlagExpChatPresetFullWidthButtonFixes = require(ExpChat.Flags.FFlagExpChatPresetFullWidthButtonFixes)

local Constants = require(ExpChat.PresetChat.Constants)
local Localization = require(ExpChat.Localization)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local useChatTooltipLifecycle = require(ExpChat.ChatWindow.UI.useChatTooltipLifecycle)

local function PresetChatTooltip(props)
	if not (FFlagExpChatPresetChatEnabled and FFlagExpChatUseUnifiedTooltipStore) then
		return React.createElement(React.Fragment, nil, props.children)
	end

	local chatTooltipStore = GetChatTooltipStore(false)
	local v = SignalsReact.useSignalState(chatTooltipStore.getShouldShow("PresetChatTooltip"))

	local v2 = useChatTooltipLifecycle({
		tooltipKey = "PresetChatTooltip",
		targetTextChannel = props.targetTextChannel
	})

	local v3 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.QuickWords.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.QuickWords.Body"
	})

	local onClose = React.useCallback(function()
		v2.onDismiss()

		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Dismiss,
				component = Constants.Analytics.Components.PresetTooltip
			},
			ExpChatShared.Analytics.DefaultStandardizedFields
		)
	end, { v2.onDismiss })

	React.useEffect(function()
		if v then
			ExpChatShared.Analytics:TelemetryLogEvent(
				ExpChatShared.Analytics.ExpChatPresetActionConfig,
				{
					event_type = Constants.Analytics.EventTypes.Show,
					component = Constants.Analytics.Components.PresetTooltip
				},
				ExpChatShared.Analytics.DefaultStandardizedFields
			)
		end
	end, { v })

	if not v then
		return React.createElement(React.Fragment, nil, props.children)
	end

	if FFlagExpChatPresetFullWidthButtonFixes and props.anchorRef ~= nil then
		return React.createElement(React.Fragment, nil, props.children, React.createElement(Coachmark, {
			title = v3.headerText,
			text = v3.bodyText,
			isOpen = v2.isActive,
			onClose = onClose,
			side = PopoverSide.Right,
			align = PopoverAlign.Center,
			anchorRef = props.anchorRef
		}))
	end

	return React.createElement(Coachmark, {
		title = v3.headerText,
		text = v3.bodyText,
		isOpen = v2.isActive,
		onClose = onClose,
		side = PopoverSide.Right,
		align = PopoverAlign.Center
	}, props.children)
end

return React.memo(PresetChatTooltip)
