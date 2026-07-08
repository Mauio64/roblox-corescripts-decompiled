local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Foundation = require(Parent.Foundation)
local Roact = require(Parent.Roact)
local v4 = Roact.PureComponent:extend("BackgroundFill")

function v4.render(p1) -- line: 8
	-- upvalues: Roact (copy), Foundation (copy)
	local propsImage = p1.props.Image

	return Roact.createElement(Foundation.Image, {
		BorderSizePixel = 0,
		Image = propsImage,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ScaleType = Enum.ScaleType.Crop
	})
end

return v4
