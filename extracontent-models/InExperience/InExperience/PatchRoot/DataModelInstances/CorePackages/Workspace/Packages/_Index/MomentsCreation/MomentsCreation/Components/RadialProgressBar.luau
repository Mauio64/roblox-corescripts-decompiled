local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Image = Foundation.Image
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local Constants = require(MomentsCreation.Constants)

local function RadialProgressBar(p)
	local v = useTokens()
	local background = v.Color.ActionSubtle.Background
	local foreground = v.Color.ActionSubtle.Foreground

	local numberSequence = NumberSequence.new({
		NumberSequenceKeypoint.new(0, foreground.Transparency),
		NumberSequenceKeypoint.new(0.4999, foreground.Transparency),
		NumberSequenceKeypoint.new(0.5, background.Transparency),
		NumberSequenceKeypoint.new(1, background.Transparency)
	})

	local colorSequence = ColorSequence.new({
		ColorSequenceKeypoint.new(0, foreground.Color3),
		ColorSequenceKeypoint.new(0.4999, foreground.Color3),
		ColorSequenceKeypoint.new(0.5, background.Color3),
		ColorSequenceKeypoint.new(1, background.Color3)
	})

	return React.createElement(
		View,
		{
			BackgroundTransparency = 1,
			tag = "anchor-center-center position-center-center size-full"
		},
		{
			LeftGradient = React.createElement(View, {
				Size = UDim2.fromScale(0.5, 1),
				tag = "clip"
			}, {
				Image = React.createElement(
					Image,
					{ Image = Constants.RadialFillImage, Size = UDim2.fromScale(2, 1) },
					{
						Gradient = React.createElement("UIGradient", {
							Transparency = numberSequence,
							Color = colorSequence,
							Rotation = p.progress:map(function(p2: number)
								return (math.clamp(p2 * 360, 180, 360))
							end)
						})
					}
				)
			}),
			RightGradient = React.createElement(
				View,
				{ Size = UDim2.fromScale(0.5, 1), tag = "clip position-top-center" },
				{
					Image = React.createElement(
						Image,
						{
							Image = Constants.RadialFillImage,
							Size = UDim2.fromScale(2, 1),
							Position = UDim2.fromScale(-1, 0)
						},
						{
							Gradient = React.createElement("UIGradient", {
								Transparency = numberSequence,
								Color = colorSequence,
								Rotation = p.progress:map(function(p2: number)
									return (math.clamp(p2 * 360, 0, 180))
								end)
							})
						}
					)
				}
			)
		}
	)
end

return RadialProgressBar
