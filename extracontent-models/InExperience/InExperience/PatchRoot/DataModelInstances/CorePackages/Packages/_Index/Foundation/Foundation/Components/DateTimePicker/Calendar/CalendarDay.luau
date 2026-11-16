local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local StateLayerMode = require(Foundation.Enums.StateLayerMode)
local Text = require(Foundation.Components.Text)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function CalendarDay(props)
	local v = useTokens()
	local color3

	if props.isSelected then
		color3 = v.Inverse.Content.Emphasis.Color3
	elseif props.isSelectable and props.emphasizeText then
		color3 = v.Color.Content.Emphasis.Color3
	else
		color3 = v.Color.Content.Muted.Color3
	end

	local transparency = (props.isSelected or props.isSelectable and props.emphasizeText) and 0 or 0.5

	local createElement = React.createElement
	local backgroundStyle

	if props.isSelected then
		backgroundStyle = v.Color.System.Contrast
	elseif props.highlight then
		backgroundStyle = v.Color.ActionStandard.Background
	end

	local v2 = {
		textStyle = { Color3 = color3, Transparency = transparency },
		backgroundStyle = backgroundStyle,
		LayoutOrder = props.LayoutOrder,
		onActivated = 0,
		RichText = 0,
		stateLayer = 0,
		Text = 0,
		tag = "auto-xy text-title-small text-align-x-center text-align-y-center",
		testId = 0
	}
	local onActivated

	if props.isSelectable then
		onActivated = props.onActivated
	end

	v2.onActivated = onActivated
	v2.RichText = not props.isSelectable
	local mode

	if props.isSelected then
		mode = StateLayerMode.Inverse
	else
		mode = StateLayerMode.Default
	end

	v2.stateLayer = { mode = mode }
	local text

	if props.isSelectable then
		text = props.Text
	else
		text = `<s>{props.Text}</s>`
	end

	v2.Text = text

	v2.testId = props.testId
	return createElement(Text, v2)
end

return CalendarDay
