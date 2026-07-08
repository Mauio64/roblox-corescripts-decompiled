local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local ColorGradientCircle = require(Parent.AXCommon).Components.ColorGradientCircle
local React = require(Parent.React)

local function SlotCircularGradientFrame(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), ColorGradientCircle (copy)
	return React.createElement(ColorGradientCircle, {
		hasBorder = true,
		Colors = t1.Colors,
		Size = UDim2.fromScale(0.4, 0.4),
		Position = UDim2.fromScale(0.5, 0.5),
		Rotation = t1.Rotation,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Transparency = t1.Transparency,
		Offset = t1.Offset
	})
end

return SlotCircularGradientFrame
