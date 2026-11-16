local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")

local AnimatedBar = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Components/AnimatedBar")

local v5 = { numAnimatedBars = 5, isMoving = true }

local v6 = { 0.4, 0.3, 0.75, 0.55 }

local function MusicPlayingIcon(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v7 = 8 / joined.numAnimatedBars

	local children = {}

	for i = 1, joined.numAnimatedBars do
		children[`Bar{i}`] = React.createElement(AnimatedBar, {
			layoutOrder = i,
			width = UDim.new(1 / (joined.numAnimatedBars * 1.3), -v7),
			heightRange = joined.heightRange,
			isMoving = joined.isMoving,
			staticHeight = v6[i]
		})
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = joined.zIndex
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v7)
			})
		},
		children
	)
end

return MusicPlayingIcon
