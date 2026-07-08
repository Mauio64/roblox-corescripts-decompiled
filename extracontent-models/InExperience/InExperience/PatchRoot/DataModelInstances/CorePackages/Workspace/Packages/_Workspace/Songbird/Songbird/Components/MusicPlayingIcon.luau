local Songbird = script:FindFirstAncestor("Songbird")
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local AnimatedBar = require(Songbird.Components.AnimatedBar)
local t1 = {
	numAnimatedBars = 5,
	isMoving = true
}
local t2 = {
	0.4,
	0.3,
	0.75,
	0.55
}

local function MusicPlayingIcon(t3: {[any]: any}) -- line: 27
	-- upvalues: Cryo (copy), t1 (copy), React (copy), AnimatedBar (copy), t2 (copy)
	local v9 = Cryo.Dictionary.join(t1, t3)
	local v10 = 8 / v9.numAnimatedBars
	local t4 = {}

	for i = 1, v9.numAnimatedBars do
		t4[`Bar{ i }`] = React.createElement(AnimatedBar, {
			layoutOrder = i,
			width = UDim.new(1 / (v9.numAnimatedBars * 1.3), -v10),
			heightRange = v9.heightRange,
			isMoving = v9.isMoving,
			staticHeight = t2[i]
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = v9.zIndex
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v10)
		})
	}, t4)
end

return MusicPlayingIcon
