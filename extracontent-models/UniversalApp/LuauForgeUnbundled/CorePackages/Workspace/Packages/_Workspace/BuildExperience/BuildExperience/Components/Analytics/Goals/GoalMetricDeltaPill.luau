local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens
local iconName = Foundation.Enums.IconName
local iconPosition = Foundation.Enums.IconPosition
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant

local function GoalMetricDeltaPill(props)
	local v5 = useTokens()
	local testId = props.testId or "GoalMetricDeltaPill"

	local v6 = if props.isPositive then v5.Color.System.Success else v5.Color.Content.Default
	local v7 = if props.isPositive then iconName.ArrowWideShortUp else iconName.ArrowWideShortDown
	local v8 = (props.iconPosition or iconPosition.Left) == iconPosition.Left
	local v9 = props.isPositive
		and {
			Color3 = v5.Color.System.Success.Color3,
			Transparency = v5.Color.Shift.Shift_300.Transparency
		}
		or nil

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["row align-y-center gap-xxsmall auto-xy padding-y-xxsmall padding-left-xsmall padding-right-small radius-small"] = true,
			["bg-shift-200"] = not props.isPositive
		},
		backgroundStyle = v9,
		testId = testId
	}

	local v12 = {
		Arrow = React.createElement(icon, {
			LayoutOrder = 1,
			name = v7,
			size = iconSize.XSmall,
			variant = iconVariant.Filled,
			style = v6
		}),
		Icon = 0,
		Value = 0
	}

	local v13 = if props.icon then React.createElement(icon, {
		LayoutOrder = v8 and 2 or 3,
		name = props.icon,
		size = iconSize.XSmall,
		tag = "content-default",
		testId = `{testId}-icon`
	}) else nil
	v12.Icon = v13

	v12.Value = React.createElement(text, {
		LayoutOrder = v8 and 3 or 2,
		Text = props.text,
		tag = "auto-xy text-caption-small text-align-x-left content-default"
	})
	return createElement(view, v11, v12)
end

return GoalMetricDeltaPill
