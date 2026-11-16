local parent = script.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local Foundation = require(parent.Foundation)
local Loading = Foundation.Loading
local IconSize = Foundation.Enums.IconSize

local extended = Roact.PureComponent:extend("LoadingStatePage")

function extended.render(_)
	return Roact.createElement(Loading, {
		size = IconSize.Medium,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
end

return extended
