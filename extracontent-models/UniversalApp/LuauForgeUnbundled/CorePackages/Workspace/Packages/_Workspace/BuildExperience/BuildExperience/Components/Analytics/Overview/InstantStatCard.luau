local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function InstantStatCard(props)
	local v5 = useTokens()
	local testId = props.testId or "InstantStatCard"
	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-none size-full-0 auto-y",
		testId = testId
	}

	local v8 = {
		Label = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.label,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			testId = `{testId}-label`
		}),
		Value = 0
	}

	local createElement2 = React.createElement

	local v11 = {
		Icon = React.createElement(icon, {
			LayoutOrder = 1,
			name = props.icon,
			size = iconSize.Large,
			tag = "content-emphasis",
			testId = `{testId}-icon`
		}),
		Number = 0
	}

	local v12 = if props.isLoading then React.createElement(skeleton, {
		LayoutOrder = 2,
		Size = UDim2.fromOffset(v5.Size.Size_1000, v5.Size.Size_500),
		radius = radius.Small,
		testId = `{testId}-loading`
	}) else React.createElement(text, {
		LayoutOrder = 2,
		Text = props.valueText,
		tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
		testId = `{testId}-value`
	})
	v11.Number = v12
	v8.Value = createElement2(
		view,
		{
			LayoutOrder = 2,
			tag = "row align-y-center gap-xsmall auto-xy padding-y-xxsmall"
		},
		v11
	)
	return createElement(view, v7, v8)
end

return InstantStatCard
