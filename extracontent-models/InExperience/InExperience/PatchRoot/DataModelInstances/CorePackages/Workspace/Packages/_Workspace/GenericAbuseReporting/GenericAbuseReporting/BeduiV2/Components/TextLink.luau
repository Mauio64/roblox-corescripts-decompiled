local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ControlState = Foundation.Enums.ControlState
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text

local function TextLink(props)
	local state, setState = React.useState(false)
	local iconRichText = getIconRichText(IconName.ArrowUpRightFromSquare)

	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})

	local createElement = React.createElement
	local text

	if state then
		text = `<u>{props.text}</u> {iconRichText}`
	else
		text = `{props.text} {iconRichText}`
	end

	return createElement(Text, {
		Text = text,
		RichText = true,
		onActivated = props.onActivated,
		onStateChanged = onStateChanged,
		tag = props.tag or "auto-xy text-body-medium text-wrap text-align-x-left radius-small content-emphasis",
		LayoutOrder = props.layoutOrder
	})
end

return React.memo(TextLink)
