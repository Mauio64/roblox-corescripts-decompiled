local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local ShimmerAnimation = require(Modules.LuaApp.Components.ShimmerAnimation)
local ThemeContext_DEPRECATED = require(Modules.LuaApp.ThemeContext_DEPRECATED)
local v5 = Roact.PureComponent:extend("ShimmerPanel")

function v5.render(p1) -- line: 10
	-- upvalues: Roact (copy), ThemeContext_DEPRECATED (copy), ShimmerAnimation (copy)
	local propsSize = p1.props.Size
	local propsPosition = p1.props.Position
	local propsLayoutOrder = p1.props.LayoutOrder

	return Roact.createElement(ThemeContext_DEPRECATED.Consumer, {
		render = function(p2) -- line: 16
			-- upvalues: Roact (copy), propsSize (copy), propsPosition (copy), propsLayoutOrder (copy), ShimmerAnimation (copy)
			return Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = propsSize,
				Position = propsPosition,
				BackgroundColor3 = p2.ShimmerPanel.Color,
				BackgroundTransparency = p2.ShimmerPanel.Transparency,
				LayoutOrder = propsLayoutOrder
			}, { Roact.createElement(ShimmerAnimation, {
				shimmerScale = 4,
				shimmerSpeed = 2.5,
				Size = UDim2.new(1, 0, 1, 0)
			}) })
		end
	})
end

return v5
