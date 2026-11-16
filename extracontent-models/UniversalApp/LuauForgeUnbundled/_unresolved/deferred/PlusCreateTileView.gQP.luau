local module = require("@luauforge/deferred/gQN")
local module2 = require("@luauforge/deferred/gQM")

local module3 = require("@luauforge/deferred/gQQ")

local function PlusCreateTileView(props)
	return module2.createElement(module2.Fragment, nil, {
		Tile = module2.createElement(module.View, {
			tag = "col align-x-center align-y-center size-full auto-y radius-medium clip",
			onActivated = props.onActivated,
			backgroundStyle = props.backgroundStyle,
			LayoutOrder = props.LayoutOrder,
			testId = "PlusCreateTile",
			ref = props.anchorRef
		}, {
			Icon = module2.createElement(module.Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				name = module.Enums.IconName.PlusLarge,
				style = props.iconStyle,
				size = module.Enums.IconSize.Large
			})
		}),
		Tooltip = module2.createElement(module3, {
			popoverSide = "Bottom",
			tooltipLocalizationKey = props.tooltipLocalizationKey,
			tooltipStorageKey = props.tooltipStorageKey,
			dismissTooltipRef = props.dismissTooltipRef,
			showTooltip = true
		})
	})
end

return PlusCreateTileView
