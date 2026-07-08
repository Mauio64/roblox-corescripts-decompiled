local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Foundation = require(ExpChatParent.Foundation)
local React = require(ExpChatParent.React)
local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local Constants = require(ExpChat.PresetChat.Constants)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local Localization = require(ExpChat.Localization)
local PresetChatTooltip = require(script.Parent.PresetChatTooltip)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore

local function PresetChatButton(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), Localization (copy), GetPresetChatStore (copy), SignalsReact (copy), FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), setIsPresetTrayOpen (copy), ExpChatShared (copy), Constants (copy), Foundation (copy), Config (copy), PresetChatTooltip (copy)
	local v17 = React.useRef(false)
	local v18 = Localization.useLocalization({
		sendQuickWords = "CoreScripts.TextChat.Action.SendQuickWords"
	})
	local v19 = GetPresetChatStore(false)
	local v20 = SignalsReact.useSignalState(v19.getIsTrayOpen)
	local v21 = React.useCallback(function() -- line: 34
		-- upvalues: FFlagExpChatUseUnifiedTooltipStore (copy), GetChatTooltipStore (copy), v17 (copy), setIsPresetTrayOpen (copy), v19 (copy), ExpChatShared (copy), Constants (copy)
		if FFlagExpChatUseUnifiedTooltipStore then
			local v23 = GetChatTooltipStore(false)

			if not v17.current then
				v17.current = true
				v23.reportImpression("PresetChatTooltip")
			end

			v23.setIsDismissed("PresetChatTooltip", true)
		end

		setIsPresetTrayOpen(v19, not v19.getIsTrayOpen(false))
		ExpChatShared.Analytics:TelemetryLogEvent(ExpChatShared.Analytics.ExpChatPresetActionConfig, {
			event_type = Constants.Analytics.EventTypes.Click,
			component = Constants.Analytics.Components.PresetEntryPointButton
		}, ExpChatShared.Analytics.DefaultStandardizedFields)
	end, { v19 })
	local v22 = if not t1.fullWidth then React.createElement(Foundation.IconButton, {
		isDisabled = false,
		icon = {
			name = Config.PresetChat.Icon,
			variant = if not v20 then Config.PresetChat.IconVariant else Config.PresetChat.IconVariantActive
		},
		variant = Foundation.Enums.ButtonVariant.Standard,
		size = if t1.size == nil then Foundation.Enums.InputSize.Small else t1.size,
		isCircular = t1.isCircular == nil or t1.isCircular,
		onActivated = v21
	}) else React.createElement(Foundation.Button, {
		fillBehavior = Foundation.Enums.FillBehavior.Fit,
		onActivated = v21,
		text = v18.sendQuickWords,
		variant = Foundation.Enums.ButtonVariant.Standard,
		width = UDim.new(1, 0)
	})

	return React.createElement(PresetChatTooltip, {
		targetTextChannel = t1.targetTextChannel
	}, v22)
end

return React.memo(PresetChatButton)
