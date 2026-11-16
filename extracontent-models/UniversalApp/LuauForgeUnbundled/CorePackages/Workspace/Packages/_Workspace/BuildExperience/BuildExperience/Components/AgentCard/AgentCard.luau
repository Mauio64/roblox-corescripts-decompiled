local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local text = Foundation.Text
local view = Foundation.View

local function AgentCard(props)
	local testId = props.testId or "agent-card"

	local v5 = {
		Header = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis"
		}),
		Content = React.createElement(text, {
			LayoutOrder = 2,
			RichText = true,
			Text = props.textContent,
			tag = props.fitToContent and "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis" or "size-full-2000 text-body-medium text-wrap text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			testId = `{testId}-text-content`
		}),
		Children = React.createElement(React.Fragment, nil, props.children)
	}

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large"] = true,
			["gap-large"] = props.footer ~= nil,
			["gap-xxsmall"] = props.footer == nil
		},
		testId = testId
	}

	local v9 = if props.footer == nil then React.createElement(React.Fragment, nil, v5) else React.createElement(
		view,
		{ LayoutOrder = 1, tag = "col gap-xxsmall size-full-0 auto-y" },
		v5
	)
	local v10 = if props.footer ~= nil then React.createElement(
		view,
		{ LayoutOrder = 2, tag = "col size-full-0 auto-y" },
		{ Content = props.footer }
	) else nil
	return createElement(view, v7, { Body = v9, Footer = v10 })
end

return AgentCard
