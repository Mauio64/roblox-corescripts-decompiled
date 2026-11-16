local module = require("@luauforge/deferred/gQN")
local module2 = require("@luauforge/deferred/gQM")

require("@luauforge/deferred/gQP")

local defineFastString = game:DefineFastString(
	"AXBackgroundGenerationCreateTooltip",
	"AXBackgroundGenerationCreateTooltip"
)

local function usePlusCreateTileViewModel(data)
	local v5 = module.Hooks.useTokens()
	local ref = module2.useRef(nil)
	local ref2 = module2.useRef(nil)
	module2.useImperativeHandle(data.impressionRef, function()
		return ref.current
	end, {})
	local isDisabled = data.isDisabled == true
	local v6 = module2.useCallback(function()
		if ref2.current then
			ref2.current()
		end

		if data.onActivated then
			data.onActivated()
		end
	end, { data.onActivated })

	local v7 = {
		anchorRef = ref,
		backgroundStyle = 0,
		dismissTooltipRef = 0,
		iconStyle = 0,
		LayoutOrder = 0,
		onActivated = 0,
		tooltipLocalizationKey = "Feature.Avatar.BackgroundGeneration.Tooltip.CreateBackground",
		tooltipStorageKey = 0
	}

	local v8 = if isDisabled then v5.Color.Shift.Shift_200 else v5.Color.Common.Shimmer
	v7.backgroundStyle = v8
	v7.dismissTooltipRef = ref2
	v7.iconStyle = v5.Color.Content.Muted
	v7.LayoutOrder = data.LayoutOrder
	v7.onActivated = v6

	v7.tooltipStorageKey = defineFastString
	return v7
end

return usePlusCreateTileViewModel
