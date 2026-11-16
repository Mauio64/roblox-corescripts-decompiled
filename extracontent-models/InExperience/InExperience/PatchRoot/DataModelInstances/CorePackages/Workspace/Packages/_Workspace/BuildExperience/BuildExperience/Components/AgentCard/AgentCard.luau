local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View

local function AgentCard(props)
	local testId = props.testId or "agent-card"

	local v = {
		Header = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis"
		}),
		Content = React.createElement(Text, {
			LayoutOrder = 2,
			RichText = true,
			Text = props.textContent,
			tag = props.fitToContent and "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis" or "size-full-2000 text-body-medium text-wrap text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			testId = `{testId}-text-content`
		}),
		Children = React.createElement(React.Fragment, nil, props.children)
	}

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col size-full-0 auto-y padding-large stroke-standard stroke-default radius-large"] = true,
			["gap-large"] = props.footer ~= nil,
			["gap-xxsmall"] = props.footer == nil
		},
		testId = testId
	}
	local body

	if props.footer == nil then
		body = React.createElement(React.Fragment, nil, v)
	else
		body = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y"
		}, v)
	end

	local footer

	if props.footer ~= nil then
		footer = React.createElement(View, { LayoutOrder = 2, tag = "col size-full-0 auto-y" }, {
			Content = props.footer
		})
	end

	return createElement(View, v2, { Body = body, Footer = footer })
end

return AgentCard
