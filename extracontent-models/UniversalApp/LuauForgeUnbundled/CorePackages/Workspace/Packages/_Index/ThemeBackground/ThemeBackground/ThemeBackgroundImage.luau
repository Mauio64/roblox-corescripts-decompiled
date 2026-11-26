local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/React")

local function ThemeBackgroundImage(props)
	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Image = props.image,
		Position = props.Position,
		ScaleType = Enum.ScaleType.Crop,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = 0
	})
end

return ThemeBackgroundImage
