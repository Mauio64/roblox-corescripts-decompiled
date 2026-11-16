local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens

local fFlagSduiDividerThemeAwareStroke = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiDividerThemeAwareStroke

local function SduiDivider(props)
	local v5 = if fFlagSduiDividerThemeAwareStroke then useTokens() else nil
	local size = props.size
	local layoutOrder = props.layoutOrder
	local position = props.position
	local anchorPoint = props.anchorPoint
	local backgroundColor3 = props.backgroundColor3
	local backgroundTransparency = props.backgroundTransparency

	local createElement = React.createElement
	local v7 = {}
	v7.Size = size or UDim2.new(1, 0, 0, 1)
	v7.LayoutOrder = layoutOrder
	v7.Position = position
	v7.AnchorPoint = anchorPoint
	local v8 = if fFlagSduiDividerThemeAwareStroke then backgroundColor3 or v5.Color.Stroke.Default.Color3 else backgroundColor3 or Color3.new(1, 1, 1)
	v7.BackgroundColor3 = v8

	v7.BackgroundTransparency = not fFlagSduiDividerThemeAwareStroke and (backgroundTransparency or 0.85)
		or backgroundTransparency
		or v5.Color.Stroke.Default.Transparency

	v7.BorderSizePixel = 0
	v7[React.Tag] = "data-testid=--sdui-divider"
	return createElement("Frame", v7)
end

return React.memo(SduiDivider)
