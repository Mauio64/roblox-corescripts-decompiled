local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/fNN")
local module3 = require("@luauforge/bundled/fNO")

local extended = module.PureComponent:extend("ShimmerAnimation")

extended.defaultProps = { shimmerSpeed = 2, shimmerScale = 2 }

function extended.render(p2)
	local appTheme = p2.props.appTheme
	local size = p2.props.Size
	local position = p2.props.Position
	local anchorPoint = p2.props.AnchorPoint
	local layoutOrder = p2.props.LayoutOrder
	local shimmerScale = p2.props.shimmerScale
	local image = appTheme and appTheme.ShimmerAnimation.Image
		or "rbxasset://textures/ui/LuaApp/graphic/shimmer.png"
	local aspectRatio = appTheme and appTheme.ShimmerAnimation.AspectRatio or 0.876
	local transparency = appTheme and appTheme.ShimmerAnimation.Transparency or 0.65

	local udim = UDim2.new(aspectRatio * shimmerScale, 0, shimmerScale, 0)
	local shimmerSpeed = p2.props.shimmerSpeed

	local v5 = shimmerSpeed == 0 and 0 or (shimmerScale + 1) / shimmerSpeed

	return module.createElement(module2, {
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		Image = image,
		imageSize = udim,
		ImageTransparency = transparency,
		imageAnchorPoint = Vector2.new(0, 0.5),
		imagePositionStart = UDim2.new(-shimmerScale, 0, 0.5, 0),
		imagePositionEnd = UDim2.new(1, 0, 0.5, 0),
		imageScrollCycleTime = v5
	})
end

return (module3(extended))
