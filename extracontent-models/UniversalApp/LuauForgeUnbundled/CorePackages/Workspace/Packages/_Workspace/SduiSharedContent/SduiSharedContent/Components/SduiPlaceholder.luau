local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").Hooks.useTokens
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local function SduiPlaceholder(props)
	local v5 = useTokens()

	local backgroundStyle = props.backgroundStyle or v5.Color.Surface.Surface_200
	local cornerRadius = props.cornerRadius or UDim.new(0, v5.Radius.Medium)
	local v6 = cornerRadius.Offset > 0 or cornerRadius.Scale > 0

	local createElement = React.createElement
	local v8 = {
		["AnchorPoint"] = props.anchorPoint,
		AutomaticSize = props.automaticSize,
		BackgroundColor3 = backgroundStyle.Color3,
		BackgroundTransparency = props.transparencyBinding or 0,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Position = props.position,
		Size = props.size or UDim2.fromScale(1, 0),
		ZIndex = props.zIndex
	}
	local tag = React.Tag
	local v9 = if props.testId then `data-testid={props.testId}` else nil
	v8[tag] = v9

	local v11 = if v6 then React.createElement("UICorner", {
		CornerRadius = cornerRadius
	}) else nil
	return createElement("Frame", v8, { UICorner = v11 })
end

return React.memo(SduiPlaceholder)
