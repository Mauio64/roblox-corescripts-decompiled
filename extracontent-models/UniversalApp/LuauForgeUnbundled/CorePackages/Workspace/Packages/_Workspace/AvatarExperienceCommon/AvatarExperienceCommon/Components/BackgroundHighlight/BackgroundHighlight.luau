local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation").Hooks.useTokens

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

local function Gradient(p2)
	local v5 = useTokens()

	return React.createElement(
		"Frame",
		{
			BackgroundColor3 = v5.Color.Surface.Surface_0.Color3,
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			ZIndex = 1
		},
		{
			UIGradient = React.createElement("UIGradient", {
				Rotation = p2.Rotation,
				Transparency = p2.Transparency
			})
		}
	)
end

local function BackgroundHighlight(p2)
	return React.createElement("Frame", {
		Size = UDim2.fromScale(1.2, 1.2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = p2.highlightColor.Transparency,
		BackgroundColor3 = p2.highlightColor.Color3,
		BorderSizePixel = 0,
		ZIndex = p2.ZIndex or 0
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
