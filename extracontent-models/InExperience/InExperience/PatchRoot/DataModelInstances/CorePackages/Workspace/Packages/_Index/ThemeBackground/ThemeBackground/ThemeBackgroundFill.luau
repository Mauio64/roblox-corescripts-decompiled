local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local ThemeBackgroundImage = require(parent.ThemeBackgroundImage)

local function ThemeBackgroundFill(props)
	return React.createElement("Frame", {
		BackgroundColor3 = props.baseColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = props.Position,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = 0,
		ref = props.onPageChanged,
		[React.Change.AbsolutePosition] = props.onPageChanged,
		[React.Change.AbsoluteSize] = props.onPageChanged
	}, {
		Image = React.createElement(ThemeBackgroundImage, { image = props.image })
	})
end

return ThemeBackgroundFill
