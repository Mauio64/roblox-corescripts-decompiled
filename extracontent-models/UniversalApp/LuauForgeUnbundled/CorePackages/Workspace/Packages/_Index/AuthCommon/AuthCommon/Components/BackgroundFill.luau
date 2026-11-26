local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")

local extended = Roact.PureComponent:extend("BackgroundFill")

function extended.render(p2)
	local image = p2.props.Image

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
