local module = require("@luauforge/deferred/hcT")
local module2 = require("@luauforge/deferred/hcS")

local module3 = require("@luauforge/deferred/hdd")

local function ResponsiveEdgeSurfaceView(props)
	local element = module2.createElement(module3.Provider, { value = props.isDocked }, props.children)
	local element2 = module2.createElement(module.View, {
		tag = {
			["col size-full-0 auto-y padding-large"] = true,
			["radius-top-large bg-surface-0"] = props.isDocked,
			["stroke-standard stroke-default radius-large bg-surface-100"] = not props.isDocked
		}
	}, element)
	local v5

	if props.isDocked then
		v5 = module2.createElement(module.View, {
			LayoutOrder = props.LayoutOrder,
			tag = "anchor-bottom-center size-full-0 auto-y",
			Position = UDim2.new(0.5, 0, 1, -props.keyboardInset),
			testId = "ResponsiveEdgeSurface_Docked"
		}, { Surface = element2 })
	else
		v5 = module2.createElement(module.View, {
			LayoutOrder = props.LayoutOrder,
			tag = "anchor-bottom-right auto-y",
			Position = UDim2.new(1, -props.margin, 1, -props.margin),
			Size = UDim2.fromOffset(props.sideWidth, 0),
			testId = "ResponsiveEdgeSurface_Side"
		}, {
			Shadow = module2.createElement(module.Image, {
				Image = "component_assets/dropshadow_17_8",
				Size = UDim2.new(1, 32, 1, 32),
				Position = UDim2.fromOffset(-16, -16),
				ZIndex = 0,
				slice = { center = Rect.new(16, 16, 17, 17), scale = 2 },
				imageStyle = props.shadowStyle,
				testId = "ResponsiveEdgeSurface_Shadow"
			}),
			Surface = element2
		})
	end

	return module2.createElement(module.View, {
		tag = "size-full",
		ref = props.hostRef,
		onAbsolutePositionChanged = props.onHostMeasured,
		onAbsoluteSizeChanged = props.onHostMeasured,
		testId = "ResponsiveEdgeSurface"
	}, { PositionedSurface = v5 })
end

return ResponsiveEdgeSurfaceView
