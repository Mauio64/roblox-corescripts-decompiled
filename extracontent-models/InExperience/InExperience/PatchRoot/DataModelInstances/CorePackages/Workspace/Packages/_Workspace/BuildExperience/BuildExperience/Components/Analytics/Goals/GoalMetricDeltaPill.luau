local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local IconName = Foundation.Enums.IconName
local IconPosition = Foundation.Enums.IconPosition
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant

local function GoalMetricDeltaPill(props)
	local v = useTokens()
	local testId = props.testId or "GoalMetricDeltaPill"
	local style

	if props.isPositive then
		style = v.Color.System.Success
	else
		style = v.Color.Content.Default
	end

	local name

	if props.isPositive then
		name = IconName.ArrowWideShortUp
	else
		name = IconName.ArrowWideShortDown
	end

	local v2 = (props.iconPosition or IconPosition.Left) == IconPosition.Left
	local backgroundStyle = props.isPositive
		and {
			Color3 = v.Color.System.Success.Color3,
			Transparency = v.Color.Shift.Shift_300.Transparency
		}
		or nil

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
			["bg-shift-200"] = not props.isPositive
		},
		backgroundStyle = backgroundStyle,
		testId = testId
	}

	local v4 = {
		Arrow = React.createElement(Icon, {
			LayoutOrder = 1,
			name = name,
			size = IconSize.XSmall,
			variant = IconVariant.Filled,
			style = style
		}),
		Icon = 0,
		Value = 0
	}
	local icon

	if props.icon then
		icon = React.createElement(Icon, {
			LayoutOrder = v2 and 2 or 3,
			name = props.icon,
			size = IconSize.XSmall,
			tag = "content-default",
			testId = `{testId}-icon`
		})
	end

	v4.Icon = icon

	v4.Value = React.createElement(Text, {
		LayoutOrder = v2 and 3 or 2,
		Text = props.text,
		tag = "auto-xy text-caption-small text-align-x-left content-default"
	})
	return createElement(View, v3, v4)
end

return GoalMetricDeltaPill
