local colorGradientCircle = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceCommon").Components.ColorGradientCircle
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")

local function SlotCircularGradientFrame(props)
	return React.createElement(colorGradientCircle, {
		hasBorder = true,
		Colors = props.Colors,
		Size = UDim2.fromScale(0.4, 0.4),
		Position = UDim2.fromScale(0.5, 0.5),
		Rotation = props.Rotation,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Transparency = props.Transparency,
		Offset = props.Offset
	})
end

return SlotCircularGradientFrame
