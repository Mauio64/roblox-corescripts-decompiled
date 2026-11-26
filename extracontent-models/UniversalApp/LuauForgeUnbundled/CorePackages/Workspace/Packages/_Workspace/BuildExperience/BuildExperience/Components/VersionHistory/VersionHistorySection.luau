local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local text = Foundation.Text
local view = Foundation.View

local function VersionHistorySection(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y"
	}

	local createElement2 = React.createElement
	local v8 = {
		LayoutOrder = 1,
		Text = props.title,
		tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
		testId = 0
	}

	local v9 = if props.testId then `{props.testId}-heading` else nil
	v8.testId = v9
	local children = { Heading = createElement2(text, v8), Content = 0 }

	local createElement3 = React.createElement

	local v12 = if props.testId then `{props.testId}-content` else nil
	children.Content = createElement3(
		view,
		{ LayoutOrder = 2, tag = "col gap-medium size-full-0 auto-y", testId = v12 },
		props.children
	)
	return createElement(view, v6, children)
end

return VersionHistorySection
