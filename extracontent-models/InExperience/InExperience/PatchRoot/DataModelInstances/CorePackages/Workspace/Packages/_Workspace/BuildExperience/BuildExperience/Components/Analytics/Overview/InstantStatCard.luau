local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function InstantStatCard(props)
	local v = useTokens()
	local testId = props.testId or "InstantStatCard"
	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-none size-full-0 auto-y",
		testId = testId
	}

	local v3 = {
		Label = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.label,
			tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end content-default",
			testId = `{testId}-label`
		}),
		Value = 0
	}

	local createElement2 = React.createElement

	local v4 = {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = props.icon,
			size = IconSize.Large,
			tag = "content-emphasis",
			testId = `{testId}-icon`
		}),
		Number = 0
	}
	local number

	if props.isLoading then
		number = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(v.Size.Size_1000, v.Size.Size_500),
			radius = Radius.Small,
			testId = `{testId}-loading`
		})
	else
		number = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.valueText,
			tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
			testId = `{testId}-value`
		})
	end

	v4.Number = number
	v3.Value = createElement2(
		View,
		{ LayoutOrder = 2, tag = "row align-y-center gap-xsmall auto-xy padding-y-xxsmall" },
		v4
	)
	return createElement(View, v2, v3)
end

return InstantStatCard
