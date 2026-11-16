local parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(parent.React)

local function Carat(p)
	local chatSettings = p.chatSettings

	return React.createElement("ImageLabel", {
		LayoutOrder = p.layoutOrder,
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 1, -1),
		Size = UDim2.fromOffset(12, 8),
		Image = "rbxasset://textures/ui/InGameChat/Caret.png",
		ImageColor3 = chatSettings.BackgroundColor3,
		ImageTransparency = chatSettings.BackgroundTransparency
	}, {
		CaratGradient = chatSettings.UIGradient and React.createElement("UIGradient", chatSettings.UIGradient)
	})
end

return Carat
