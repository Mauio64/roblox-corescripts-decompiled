local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local core = parent.Core
local useStyle = require(core.Style.useStyle)

local ReactOtter = require(parent2.ReactOtter)

local v = { dampingRatio = 1, frequency = 3 }

local v2 = {
	top = 270,
	topRight = 305,
	right = 0,
	bottomRight = 45,
	bottom = 90,
	bottomLeft = 135,
	left = 180,
	topLeft = 225
}

local function Overlay(props)
	local theme = useStyle().Theme

	local v3 = props.showGradient and 0 or 1
	local backgroundTransparency, v4 = ReactOtter.useAnimatedBinding(v3)

	React.useEffect(function()
		if props.showGradient == false then
			v4(ReactOtter.spring(1, v))
		else
			v4(ReactOtter.spring(0, v))
		end
	end, { props.showGradient })

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = props.ZIndex
	}, {
		Overlay = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = theme.Overlay.Color,
			BackgroundTransparency = theme.Overlay.Transparency,
			ZIndex = 1
		}),
		Gradient = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = backgroundTransparency,
				ZIndex = 2
			},
			{
				UIGradient = React.createElement("UIGradient", {
					Rotation = v2[props.gradientDirection],
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
						ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 0.89)
					})
				})
			}
		)
	})
end

return Overlay
