local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local view = Foundation.View

local getEasingNumberSequence = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/getEasingNumberSequence")

local useMemo = React.useMemo

local v5 = {
	anchorPoint = Vector2.new(0, 0),
	endingTransparency = 1,
	position = UDim2.fromScale(0, 0),
	startingTransparency = 0.4
}

return function(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = useMemo(function()
		return NumberSequence.new(getEasingNumberSequence(
			union.startingTransparency,
			union.endingTransparency,
			15,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.InOut
		))
	end, { union.startingTransparency, union.endingTransparency })

	return React.createElement(view, {
		AnchorPoint = union.anchorPoint,
		cornerRadius = union.cornerRadius,
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
			Transparency = v6
		})
	})
end
