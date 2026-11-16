local Songbird = script:FindFirstAncestor("Songbird")

local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)

local AnimatedBar = require(Songbird.Components.AnimatedBar)

local v = { numAnimatedBars = 5, isMoving = true }

local v2 = { 0.4, 0.3, 0.75, 0.55 }

local function MusicPlayingIcon(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v3 = 8 / joined.numAnimatedBars

	local children = {}

	for i = 1, joined.numAnimatedBars do
		children[`Bar{i}`] = React.createElement(AnimatedBar, {
			layoutOrder = i,
			width = UDim.new(1 / (joined.numAnimatedBars * 1.3), -v3),
			heightRange = joined.heightRange,
			isMoving = joined.isMoving,
			staticHeight = v2[i]
		})
	end

	return React.createElement(
		"Frame",
		{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = joined.zIndex },
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v3)
			})
		},
		children
	)
end

return MusicPlayingIcon
