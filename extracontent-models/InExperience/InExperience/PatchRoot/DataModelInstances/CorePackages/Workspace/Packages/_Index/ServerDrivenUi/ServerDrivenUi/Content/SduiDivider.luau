local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)

local function SduiDivider(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy)
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local position = t1.position
	local anchorPoint = t1.anchorPoint
	local backgroundColor3 = t1.backgroundColor3
	local backgroundTransparency = t1.backgroundTransparency

	return React.createElement("Frame", {
		Size = size or UDim2.new(1, 0, 0, 1),
		LayoutOrder = layoutOrder,
		Position = position,
		AnchorPoint = anchorPoint,
		BackgroundColor3 = backgroundColor3 or Color3.new(1, 1, 1),
		BackgroundTransparency = backgroundTransparency or 0.85,
		BorderSizePixel = 0,
		[React.Tag] = "data-testid=--sdui-divider"
	})
end

return React.memo(SduiDivider)
