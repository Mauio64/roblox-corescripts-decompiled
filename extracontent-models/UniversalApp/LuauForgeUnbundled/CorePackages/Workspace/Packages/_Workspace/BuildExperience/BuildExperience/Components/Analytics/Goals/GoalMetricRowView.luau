local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local GoalMetricDeltaPill = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalMetricDeltaPill")

local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function GoalMetricRowView(props)
	local v5 = useTokens()
	local testId = props.testId or "GoalMetricRowView"

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = testId
	}

	local v8 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			testId = `{testId}-title`
		}),
		Value = 0
	}
	local v9

	if props.isLoading then
		v9 = React.createElement(skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_500),
			radius = radius.Small,
			testId = `{testId}-loading`
		})
	else
		local createElement2 = React.createElement

		local v13 = if props.icon then React.createElement(icon, {
			LayoutOrder = 1,
			name = props.icon,
			size = iconSize.Medium,
			tag = "content-emphasis",
			testId = `{testId}-icon`
		}) else nil
		local v12 = {
			Icon = v13,
			Value = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.valueText,
				tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
				testId = `{testId}-value`
			}),
			Delta = 0
		}

		local v14 = if props.deltaText ~= nil then React.createElement(GoalMetricDeltaPill, {
			layoutOrder = 3,
			text = props.deltaText,
			isPositive = props.isDeltaPositive == true,
			testId = `{testId}-delta`
		}) else nil
		v12.Delta = v14
		v9 = createElement2(
			view,
			{ LayoutOrder = 2, tag = "row align-y-center gap-small size-full-0 auto-y" },
			v12
		)
	end

	v8.Value = v9
	return createElement(view, v7, v8)
end

return GoalMetricRowView
