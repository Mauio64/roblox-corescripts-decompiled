local parent = script:FindFirstAncestor("AuthCommon").Parent
local Foundation = require(parent.Foundation)
local Roact = require(parent.Roact)

local extended = Roact.PureComponent:extend("BackgroundFill")

function extended.render(p)
	local image = p.props.Image

	return Roact.createElement(Foundation.Image, {
		Image = image,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Crop
	})
end

return extended
