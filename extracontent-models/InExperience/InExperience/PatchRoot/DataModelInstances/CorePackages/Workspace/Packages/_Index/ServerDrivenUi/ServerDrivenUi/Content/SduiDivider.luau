local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local FFlagSduiDividerThemeAwareStroke = require(Parent.SharedFlags).FFlagSduiDividerThemeAwareStroke

local function SduiDivider(t1: {[any]: any}) -- line: 22
	-- upvalues: FFlagSduiDividerThemeAwareStroke (copy), useTokens (copy), React (copy)
	local v7 = if not FFlagSduiDividerThemeAwareStroke then nil else useTokens()
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
		BackgroundColor3 = if not FFlagSduiDividerThemeAwareStroke then backgroundColor3 or Color3.new(1, 1, 1) else backgroundColor3 or v7.Color.Stroke.Default.Color3,
		BackgroundTransparency = if not FFlagSduiDividerThemeAwareStroke then backgroundTransparency or 0.85 else backgroundTransparency or v7.Color.Stroke.Default.Transparency,
		BorderSizePixel = 0,
		[React.Tag] = "data-testid=--sdui-divider"
	})
end

return React.memo(SduiDivider)
