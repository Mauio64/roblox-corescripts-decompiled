local module = require("@luauforge/deferred/gQN")
local module2 = require("@luauforge/deferred/gQM")

local module3 = require("@luauforge/deferred/gQQ")

local buttonVariant = module.Enums.ButtonVariant
local iconName = module.Enums.IconName
local inputSize = module.Enums.InputSize

local function GenerationResultActionsView(props)
	return module2.createElement(
		module.View,
		{
			tag = "row align-y-center gap-medium auto-xy",
			LayoutOrder = props.LayoutOrder,
			testId = "generation-result-actions"
		},
		{
			Reset = module2.createElement(module.IconButton, {
				icon = iconName.ArrowSpinClockwise,
				isCircular = true,
				isDisabled = props.isDisabled,
				LayoutOrder = 1,
				onActivated = props.onDelete,
				size = inputSize.Medium,
				variant = buttonVariant.OverMedia,
				testId = "generation-result-reset-button"
			}),
			Publish = module2.createElement(
				module.View,
				{
					tag = "auto-xy",
					LayoutOrder = 2,
					testId = "generation-result-publish-anchor"
				},
				{
					Button = module2.createElement(module.IconButton, {
						icon = iconName.ArrowUpFromLandscapeRectangle,
						isCircular = true,
						isDisabled = props.isDisabled,
						onActivated = props.onPublish,
						size = inputSize.Medium,
						variant = buttonVariant.OverMedia,
						testId = "generation-result-publish-button"
					}),
					Tooltip = module2.createElement(module3, {
						popoverSide = "Bottom",
						tooltipLocalizationKey = props.tooltipLocalizationKey,
						tooltipStorageKey = props.tooltipStorageKey,
						dismissTooltipRef = props.dismissTooltipRef,
						showTooltip = props.showTooltip
					})
				}
			)
		}
	)
end

return module2.memo(GenerationResultActionsView)
