local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local FoundationImage = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local Constants = require(MomentsCreation.Constants)

local function RadialProgressBar(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationImage (copy), Constants (copy)
	local v11 = useTokens()
	local Background = v11.Color.ActionSubtle.Background
	local Foreground = v11.Color.ActionSubtle.Foreground
	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, Foreground.Transparency),
		NumberSequenceKeypoint.new(0.4999, Foreground.Transparency),
		NumberSequenceKeypoint.new(0.5, Background.Transparency),
		NumberSequenceKeypoint.new(1, Background.Transparency)
	})
	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Foreground.Color3),
		ColorSequenceKeypoint.new(0.4999, Foreground.Color3),
		ColorSequenceKeypoint.new(0.5, Background.Color3),
		ColorSequenceKeypoint.new(1, Background.Color3)
	})

	return React.createElement(View, {
		BackgroundTransparency = 1,
		tag = "anchor-center-center position-center-center size-full"
	}, {
		LeftGradient = React.createElement(View, {
			tag = "clip",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(FoundationImage, {
				Image = Constants.RadialFillImage,
				Size = UDim2.fromScale(2, 1)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = t1.progress:map(function(n1: number) -- line: 58
						return (math.clamp(n1 * 360, 180, 360))
					end)
				})
			})
		}),
		RightGradient = React.createElement(View, {
			tag = "clip position-top-center",
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement(FoundationImage, {
				Image = Constants.RadialFillImage,
				Size = UDim2.fromScale(2, 1),
				Position = UDim2.fromScale(-1, 0)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = numberSequence,
					Color = colorSequence,
					Rotation = t1.progress:map(function(n2: number) -- line: 77
						return (math.clamp(n2 * 360, 0, 180))
					end)
				})
			})
		})
	})
end

return RadialProgressBar
