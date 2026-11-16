local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local getEasingNumberSequence = require(MomentsCommon.Utils.getEasingNumberSequence)

local useMemo = React.useMemo

local v = {
	anchorPoint = Vector2.new(0, 0),
	endingTransparency = 1,
	position = UDim2.fromScale(0, 0),
	startingTransparency = 0.4
}

return function(p)
	local union = Cryo.Dictionary.union(v, p)

	local transparency = useMemo(function()
		return NumberSequence.new(getEasingNumberSequence(
			union.startingTransparency,
			union.endingTransparency,
			15,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		))
	end, { union.startingTransparency, union.endingTransparency })

	return React.createElement(View, {
		AnchorPoint = union.anchorPoint,
		tag = "bg-contrast",
		Position = union.position,
		Size = union.size,
		ZIndex = union.zIndex or 1
	}, {
		UIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, union.color3),
				ColorSequenceKeypoint.new(1, union.color3)
			}),
			Rotation = union.rotation,
			Transparency = transparency
		})
	})
end
