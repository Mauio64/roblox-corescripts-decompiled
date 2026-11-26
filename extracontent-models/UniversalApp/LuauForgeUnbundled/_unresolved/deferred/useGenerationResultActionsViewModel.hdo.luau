local module = require("@luauforge/deferred/hcS")

require("@luauforge/deferred/hdn")

local defineFastString = game:DefineFastString(
	"AXBackgroundGenerationPublishTooltip",
	"AXBackgroundGenerationPublishTooltip"
)

local function useGenerationResultActionsViewModel(data)
	local ref = module.useRef(nil)
	local isDisabled = data.isDisabled == true
	local v5 = module.useCallback(function()
		if ref.current then
			ref.current()
		end

		data.onPublish()
	end, { data.onPublish })

	return {
		dismissTooltipRef = ref,
		isDisabled = isDisabled,
		LayoutOrder = data.LayoutOrder,
		onDelete = data.onDelete,
		onPublish = v5,
		showTooltip = not isDisabled,
		tooltipLocalizationKey = "Feature.Avatar.BackgroundGeneration.Tooltip.PublishBackground",
		tooltipStorageKey = defineFastString
	}
end

return useGenerationResultActionsViewModel
