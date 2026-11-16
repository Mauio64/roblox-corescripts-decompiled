local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local core = parent2.Core

local React = require(parent3.React)
require(parent.Style.StyleTypes)
local useStyle = require(core.Style.useStyle)

local function GradientFrame(props)
	local frameRef = props.frameRef
	local gradientStyle = props.gradientStyle
	local height = props.height
	local zIndex = props.ZIndex

	local theme = useStyle().Theme

	local color = gradientStyle and gradientStyle.Color or theme.BackgroundDefault.Color
	local transparency = gradientStyle and gradientStyle.Transparency or theme.BackgroundDefault.Transparency

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex,
			ref = frameRef
		},
		{
			Left = React.createElement(
				"Frame",
				{
					BackgroundTransparency = transparency,
					BackgroundColor3 = color,
					Size = UDim2.new(0, 50, 0, height)
				},
				{
					Gradient = React.createElement("UIGradient", {
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(1, 1)
						})
					})
				}
			),
			Right = React.createElement("Frame", {
				BackgroundTransparency = transparency,
				BackgroundColor3 = color,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 50, 0, height)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0)
					})
				})
			})
		}
	)
end

return GradientFrame
