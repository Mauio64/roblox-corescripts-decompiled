local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function Carat(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy)
	local chatSettings = t1.chatSettings

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/InGameChat/Caret.png",
		LayoutOrder = t1.layoutOrder,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, -1),
		Size = UDim2.fromOffset(12, 8),
		ImageColor3 = chatSettings.BackgroundColor3,
		ImageTransparency = chatSettings.BackgroundTransparency
	}, {
		CaratGradient = chatSettings.UIGradient and React.createElement("UIGradient", chatSettings.UIGradient)
	})
end

return Carat
