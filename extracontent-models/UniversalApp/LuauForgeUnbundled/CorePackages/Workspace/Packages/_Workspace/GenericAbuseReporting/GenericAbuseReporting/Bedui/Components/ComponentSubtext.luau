local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function ComponentSubtext(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		Text = props.requirementMessage,
		textStyle = 0,
		fontStyle = 0,
		tag = "auto-xy",
		Visible = 0,
		LayoutOrder = 0
	}

	local v8 = if props.isOptional then v5.Color.Content.Muted else v5.Color.System.Alert
	v7.textStyle = v8
	v7.fontStyle = v5.Typography.CaptionMedium

	v7.Visible = (props.isOptional or props.isErrorState) and true or false
	v7.LayoutOrder = props.layoutOrder
	return createElement(text, v7)
end

return React.memo(ComponentSubtext)
