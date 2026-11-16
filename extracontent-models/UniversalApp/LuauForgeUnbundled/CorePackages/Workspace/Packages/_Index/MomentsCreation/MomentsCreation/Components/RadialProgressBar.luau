local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local image = Foundation.Image
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")

local function RadialProgressBar(p2)
	local v5 = useTokens()
	local background = v5.Color.ActionSubtle.Background
	local foreground = v5.Color.ActionSubtle.Foreground

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
		view,
		{
			BackgroundTransparency = 1,
			tag = "anchor-center-center position-center-center size-full"
		},
		{
			LeftGradient = React.createElement(view, {
				Size = UDim2.fromScale(0.5, 1),
				tag = "clip"
			}, {
				Image = React.createElement(
					image,
					{ Image = Constants.RadialFillImage, Size = UDim2.fromScale(2, 1) },
					{
						Gradient = React.createElement("UIGradient", {
							Transparency = numberSequence,
							Color = colorSequence,
							Rotation = p2.progress:map(function(p3)
								return (math.clamp(p3 * 360, 180, 360))
							end)
						})
					}
				)
			}),
			RightGradient = React.createElement(
				view,
				{ Size = UDim2.fromScale(0.5, 1), tag = "clip position-top-center" },
				{
					Image = React.createElement(
						image,
						{
							Image = Constants.RadialFillImage,
							Size = UDim2.fromScale(2, 1),
							Position = UDim2.fromScale(-1, 0)
						},
						{
							Gradient = React.createElement("UIGradient", {
								Transparency = numberSequence,
								Color = colorSequence,
								Rotation = p2.progress:map(function(p3)
									return (math.clamp(p3 * 360, 0, 180))
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
