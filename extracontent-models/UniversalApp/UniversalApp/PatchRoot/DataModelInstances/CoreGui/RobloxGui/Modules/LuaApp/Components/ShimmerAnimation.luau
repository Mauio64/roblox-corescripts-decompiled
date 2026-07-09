local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local TextureScroller = require(Modules.LuaApp.Components.TextureScroller)
local withTheme_DEPRECATED = require(Modules.LuaApp.withTheme_DEPRECATED)
local v5 = Roact.PureComponent:extend("ShimmerAnimation")

v5.defaultProps = {
	shimmerSpeed = 2,
	shimmerScale = 2
}

function v5.render(p1) -- line: 21
	-- upvalues: Roact (copy), TextureScroller (copy)
	local appTheme = p1.props.appTheme
	local propsSize = p1.props.Size
	local propsPosition = p1.props.Position
	local propsAnchorPoint = p1.props.AnchorPoint
	local propsLayoutOrder = p1.props.LayoutOrder
	local shimmerScale = p1.props.shimmerScale
	local v13 = appTheme and appTheme.ShimmerAnimation.Image or "rbxasset://textures/ui/LuaApp/graphic/shimmer.png"
	local v14 = appTheme and appTheme.ShimmerAnimation.AspectRatio or 0.876
	local v15 = appTheme and appTheme.ShimmerAnimation.Transparency or 0.65
	local uDim2 = UDim2.new(v14 * shimmerScale, 0, shimmerScale, 0)
	local shimmerSpeed = p1.props.shimmerSpeed
	local n1 = 0

	if shimmerSpeed ~= 0 then
		n1 = (shimmerScale + 1) / shimmerSpeed
	end

	return Roact.createElement(TextureScroller, {
		Size = propsSize,
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		LayoutOrder = propsLayoutOrder,
		Image = v13,
		imageSize = uDim2,
		ImageTransparency = v15,
		imageAnchorPoint = Vector2.new(0, 0.5),
		imagePositionStart = UDim2.new(-shimmerScale, 0, 0.5, 0),
		imagePositionEnd = UDim2.new(1, 0, 0.5, 0),
		imageScrollCycleTime = n1
	})
end

return (withTheme_DEPRECATED(v5))
