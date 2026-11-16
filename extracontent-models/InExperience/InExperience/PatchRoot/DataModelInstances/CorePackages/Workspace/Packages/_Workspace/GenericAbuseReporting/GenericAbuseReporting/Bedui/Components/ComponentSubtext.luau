local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ComponentSubtext(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		Text = props.requirementMessage,
		textStyle = 0,
		fontStyle = 0,
		tag = "auto-xy",
		Visible = 0,
		LayoutOrder = 0
	}
	local textStyle

	if props.isOptional then
		textStyle = v.Color.Content.Muted
	else
		textStyle = v.Color.System.Alert
	end

	v2.textStyle = textStyle
	v2.fontStyle = v.Typography.CaptionMedium

	v2.Visible = (props.isOptional or props.isErrorState) and true or false
	v2.LayoutOrder = props.layoutOrder
	return createElement(Text, v2)
end

return React.memo(ComponentSubtext)
