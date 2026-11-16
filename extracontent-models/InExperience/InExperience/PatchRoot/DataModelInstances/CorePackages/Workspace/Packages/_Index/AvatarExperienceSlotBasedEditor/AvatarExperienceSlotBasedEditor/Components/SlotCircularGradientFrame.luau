local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local AXCommon = require(parent.AXCommon)
local ColorGradientCircle = AXCommon.Components.ColorGradientCircle
local React = require(parent.React)

local function SlotCircularGradientFrame(props)
	return React.createElement(ColorGradientCircle, {
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
