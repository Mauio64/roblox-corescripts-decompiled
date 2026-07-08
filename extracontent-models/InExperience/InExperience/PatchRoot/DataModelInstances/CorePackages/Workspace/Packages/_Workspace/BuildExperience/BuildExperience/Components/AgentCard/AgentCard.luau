local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text
local View = Foundation.View

local function AgentCard(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), View (copy), FoundationText (copy)
	local v8 = t1.testId or "agent-card"

	return React.createElement(View, {
		tag = "col gap-xxsmall size-full-0 auto-y padding-large stroke-standard stroke-default radius-large",
		LayoutOrder = t1.layoutOrder,
		testId = v8
	}, {
		Header = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-title-medium text-align-x-left text-truncate-end content-emphasis",
			Text = t1.title
		}),
		Content = React.createElement(FoundationText, {
			LayoutOrder = 2,
			RichText = true,
			tag = "size-full-2000 text-body-medium text-wrap text-align-x-left text-align-y-top text-truncate-end content-emphasis",
			Text = t1.textContent,
			testId = `{ v8 }-text-content`
		}),
		Children = React.createElement(React.Fragment, nil, t1.children)
	})
end

return AgentCard
