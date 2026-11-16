local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local function VersionHistorySection(props)
	local createElement = React.createElement
	local v = { LayoutOrder = props.layoutOrder, tag = "col gap-large size-full-0 auto-y" }

	local createElement2 = React.createElement
	local v2 = {
		LayoutOrder = 1,
		Text = props.title,
		tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
		testId = 0
	}
	local testId

	if props.testId then
		testId = `{props.testId}-heading`
	end

	v2.testId = testId
	local children = { Heading = createElement2(Text, v2), Content = 0 }

	local createElement3 = React.createElement
	local testId2

	if props.testId then
		testId2 = `{props.testId}-content`
	end

	children.Content = createElement3(
		View,
		{ LayoutOrder = 2, tag = "col gap-medium size-full-0 auto-y", testId = testId2 },
		props.children
	)
	return createElement(View, v, children)
end

return VersionHistorySection
