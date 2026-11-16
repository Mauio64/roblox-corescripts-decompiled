local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
require(parent.SduiCompat)

local function SduiPlaceholder(props)
	local v = useTokens()

	local backgroundStyle = props.backgroundStyle or v.Color.Surface.Surface_200
	local cornerRadius = props.cornerRadius or UDim.new(0, v.Radius.Medium)
	local v2 = cornerRadius.Offset > 0 or cornerRadius.Scale > 0

	local createElement = React.createElement
	local v3 = {
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
	local v4

	if props.testId then
		v4 = `data-testid={props.testId}`
	end

	v3[tag] = v4
	local uiCorner

	if v2 then
		uiCorner = React.createElement("UICorner", { CornerRadius = cornerRadius })
	end

	return createElement("Frame", v3, { UICorner = uiCorner })
end

return React.memo(SduiPlaceholder)
