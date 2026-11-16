local module = require("@luauforge/bundled/ecR")

local module2 = require("@luauforge/bundled/fNM")
local module3 = require("@luauforge/bundled/fNP")

local extended = module.PureComponent:extend("ShimmerPanel")

function extended.render(p2)
	local size = p2.props.Size
	local position = p2.props.Position
	local layoutOrder = p2.props.LayoutOrder

	return module.createElement(module3.Consumer, {
		render = function(p3)
			return module.createElement("Frame", {
				Size = size,
				Position = position,
				BackgroundColor3 = p3.ShimmerPanel.Color,
				BackgroundTransparency = p3.ShimmerPanel.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = layoutOrder
			}, { module.createElement(module2, {
					Size = UDim2.new(1, 0, 1, 0),
					shimmerScale = 4,
					shimmerSpeed = 2.5
				}) })
		end
	})
end

return extended
