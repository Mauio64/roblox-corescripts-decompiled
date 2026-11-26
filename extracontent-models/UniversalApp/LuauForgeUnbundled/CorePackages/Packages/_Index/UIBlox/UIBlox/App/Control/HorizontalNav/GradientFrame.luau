local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle

local module = require("@luauforge/deferred/heM")

local function GradientFrame(props)
	local frameRef = props.frameRef
	local gradientStyle = props.gradientStyle
	local height = if not module() then props.height else nil
	local zIndex = props.ZIndex

	local theme = useStyle().Theme

	local color = gradientStyle and gradientStyle.Color or theme.BackgroundDefault.Color
	local transparency = gradientStyle and gradientStyle.Transparency
		or theme.BackgroundDefault.Transparency

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex,
			ref = frameRef
		},
		{
			Left = React.createElement("Frame", {
				BackgroundTransparency = transparency,
				BackgroundColor3 = color,
				Size = UDim2.new(0, 50, module() and 1 or 0, module() and 0 or height)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}),
			Right = React.createElement("Frame", {
				BackgroundTransparency = transparency,
				BackgroundColor3 = color,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 50, module() and 1 or 0, module() and 0 or height)
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
