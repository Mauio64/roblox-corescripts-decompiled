local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local GoalMetricDeltaPill = require(script.Parent.GoalMetricDeltaPill)

local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function GoalMetricRowView(props)
	local v = useTokens()
	local testId = props.testId or "GoalMetricRowView"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-xsmall size-full-0 auto-y",
		testId = testId
	}

	local v3 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			testId = `{testId}-title`
		}),
		Value = 0
	}
	local v4

	if props.isLoading then
		v4 = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v.Size.Size_500),
			radius = Radius.Small,
			testId = `{testId}-loading`
		})
	else
		local createElement2 = React.createElement
		local icon

		if props.icon then
			icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = props.icon,
				size = IconSize.Medium,
				tag = "content-emphasis",
				testId = `{testId}-icon`
			})
		end

		local v5 = {
			Icon = icon,
			Value = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.valueText,
				tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
				testId = `{testId}-value`
			}),
			Delta = 0
		}
		local delta

		if props.deltaText ~= nil then
			delta = React.createElement(GoalMetricDeltaPill, {
				layoutOrder = 3,
				text = props.deltaText,
				isPositive = props.isDeltaPositive == true,
				testId = `{testId}-delta`
			})
		end

		v5.Delta = delta
		v4 = createElement2(View, {
			LayoutOrder = 2,
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, v5)
	end

	v3.Value = v4
	return createElement(View, v2, v3)
end

return GoalMetricRowView
