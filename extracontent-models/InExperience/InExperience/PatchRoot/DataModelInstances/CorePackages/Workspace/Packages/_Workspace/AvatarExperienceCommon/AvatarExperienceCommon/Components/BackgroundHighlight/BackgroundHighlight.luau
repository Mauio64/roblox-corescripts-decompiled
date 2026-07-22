local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.1, 1),
	NumberSequenceKeypoint.new(0.9, 1),
	NumberSequenceKeypoint.new(1, 0)
})
local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.6, 1),
	NumberSequenceKeypoint.new(0.85, 0.15),
	NumberSequenceKeypoint.new(1, 0)
})

local function Gradient(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), React (copy)
	local v9 = useTokens()

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = v9.Color.Surface.Surface_0.Color3,
		Size = UDim2.fromScale(1, 1)
	}, {
		UIGradient = React.createElement("UIGradient", {
			Rotation = t1.Rotation,
			Transparency = t1.Transparency
		})
	})
end
local function BackgroundHighlight(t2: {[any]: any}) -- line: 48
	-- upvalues: React (copy), Gradient (copy), numberSequence2 (copy), numberSequence (copy)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1.2, 1.2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = t2.highlightColor.Transparency,
		BackgroundColor3 = t2.highlightColor.Color3,
		ZIndex = t2.ZIndex or 0
	}, {
		TriangleGradientBottom = React.createElement(Gradient, {
			Rotation = 90,
			Transparency = numberSequence2
		}),
		TriangleGradientLeft = React.createElement(Gradient, {
			Rotation = 210,
			Transparency = numberSequence2
		}),
		TriangleGradientRight = React.createElement(Gradient, {
			Rotation = 330,
			Transparency = numberSequence2
		}),
		EdgeGradientHorizontal = React.createElement(Gradient, {
			Rotation = 0,
			Transparency = numberSequence
		}),
		EdgeGradientVertical = React.createElement(Gradient, {
			Rotation = 90,
			Transparency = numberSequence
		})
	})
end

return BackgroundHighlight
