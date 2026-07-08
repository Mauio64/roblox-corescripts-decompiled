local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Foundation = require(ExpChatParent.Foundation)
local Coachmark = Foundation.Coachmark
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local Constants = require(ExpChat.PresetChat.Constants)
local Localization = require(ExpChat.Localization)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local useChatTooltipLifecycle = require(ExpChat.ChatWindow.UI.useChatTooltipLifecycle)

local function PresetChatTooltip(t1: {[any]: any}) -- line: 37
	-- upvalues: FFlagExpChatPresetChatEnabled (copy), FFlagExpChatUseUnifiedTooltipStore (copy), React (copy), GetChatTooltipStore (copy), SignalsReact (copy), useChatTooltipLifecycle (copy), Localization (copy), ExpChatShared (copy), Constants (copy), Coachmark (copy), PopoverSide (copy), PopoverAlign (copy)
	if not FFlagExpChatPresetChatEnabled or not FFlagExpChatUseUnifiedTooltipStore then
		return React.createElement(React.Fragment, nil, t1.children)
	end

	local v18 = GetChatTooltipStore(false)
	local v19 = SignalsReact.useSignalState(v18.getShouldShow("PresetChatTooltip"))
	local v20 = useChatTooltipLifecycle({
		tooltipKey = "PresetChatTooltip",
		targetTextChannel = t1.targetTextChannel
	})
	local v21 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.QuickWords.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.QuickWords.Body"
	})
	local v22 = React.useCallback(function() -- line: 55
		-- upvalues: v20 (copy), ExpChatShared (copy), Constants (copy)
		v20.onDismiss()
		ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
			event_type = Constants.Analytics.EventTypes.Dismiss,
			component = Constants.Analytics.Components.PresetTooltip
		}, ExpChatShared.Analytics.DefaultStandardizedFields)
	end, { v20.onDismiss })

	React.useEffect(function() -- line: 64
		-- upvalues: v19 (copy), ExpChatShared (copy), Constants (copy)
		if v19 then
			ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
				event_type = Constants.Analytics.EventTypes.Show,
				component = Constants.Analytics.Components.PresetTooltip
			}, ExpChatShared.Analytics.DefaultStandardizedFields)
		end
	end, { v19 })

	if not v19 then
		return React.createElement(React.Fragment, nil, t1.children)
	end

	return React.createElement(Coachmark, {
		title = v21.headerText,
		text = v21.bodyText,
		isOpen = v20.isActive,
		onClose = v22,
		side = PopoverSide.Right,
		align = PopoverAlign.Center
	}, t1.children)
end

return React.memo(PresetChatTooltip)
