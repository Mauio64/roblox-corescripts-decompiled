local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDividerThemeAwareStroke = SharedFlags.FFlagSduiDividerThemeAwareStroke

local function SduiDivider(props)
	local v

	if FFlagSduiDividerThemeAwareStroke then
		v = useTokens()
	end

	local size = props.size
	local layoutOrder = props.layoutOrder
	local position = props.position
	local anchorPoint = props.anchorPoint
	local backgroundColor3 = props.backgroundColor3
	local backgroundTransparency = props.backgroundTransparency

	local createElement = React.createElement
	local v2 = {}
	v2.Size = size or UDim2.new(1, 0, 0, 1)
	v2.LayoutOrder = layoutOrder
	v2.Position = position
	v2.AnchorPoint = anchorPoint
	local backgroundColor

	if FFlagSduiDividerThemeAwareStroke then
		backgroundColor = backgroundColor3 or v.Color.Stroke.Default.Color3
	else
		backgroundColor = backgroundColor3 or Color3.new(1, 1, 1)
	end

	v2.BackgroundColor3 = backgroundColor

	v2.BackgroundTransparency = not FFlagSduiDividerThemeAwareStroke and (backgroundTransparency or 0.85)
		or backgroundTransparency
		or v.Color.Stroke.Default.Transparency

	v2.BorderSizePixel = 0
	v2[React.Tag] = "data-testid=--sdui-divider"
	return createElement("Frame", v2)
end

return React.memo(SduiDivider)
