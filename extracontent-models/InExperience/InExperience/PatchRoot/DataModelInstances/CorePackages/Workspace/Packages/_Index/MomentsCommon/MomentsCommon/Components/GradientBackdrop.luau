local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Cryo = require(MomentsCommonParent.Cryo)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local View = Foundation.View
local getEasingNumberSequence = require(MomentsCommon.Utils.getEasingNumberSequence)
local useMemo = React.useMemo
local t1 = {
	endingTransparency = 1,
	startingTransparency = 0.4,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.fromScale(0, 0)
}

return function(t2: {[any]: any}) -- line: 34
	-- upvalues: Cryo (copy), t1 (copy), useMemo (copy), getEasingNumberSequence (copy), React (copy), View (copy)
	local v11 = Cryo.Dictionary.union(t1, t2)
	local v12 = useMemo(function() -- line: 37
		-- upvalues: getEasingNumberSequence (copy), v11 (copy)
		return NumberSequence.new(getEasingNumberSequence(v11.startingTransparency, v11.endingTransparency, 15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
	end, {
		v11.startingTransparency,
		v11.endingTransparency
	})

	return React.createElement(View, {
		tag = "bg-contrast",
		AnchorPoint = v11.anchorPoint,
		Position = v11.position,
		Size = v11.size,
		ZIndex = v11.zIndex or 1
	}, {
		UIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, v11.color3),
				ColorSequenceKeypoint.new(1, v11.color3)
			}),
			Rotation = v11.rotation,
			Transparency = v12
		})
	})
end
