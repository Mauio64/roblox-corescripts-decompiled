local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local controlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local iconName = Foundation.Enums.IconName
local text = Foundation.Text

local function TextLink(props)
	local state, setState = React.useState(false)
	local iconRichText = getIconRichText(iconName.ArrowUpRightFromSquare)

	local v5 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover)
	end, {})

	local createElement = React.createElement
	local v8 = if state then `<u>{props.text}</u> {iconRichText}` else `{props.text} {iconRichText}`
	return createElement(text, {
		Text = v8,
		RichText = true,
		onActivated = props.onActivated,
		onStateChanged = v5,
		tag = props.tag or "auto-xy text-body-medium text-wrap text-align-x-left radius-small content-emphasis",
		LayoutOrder = props.layoutOrder
	})
end

return React.memo(TextLink)
