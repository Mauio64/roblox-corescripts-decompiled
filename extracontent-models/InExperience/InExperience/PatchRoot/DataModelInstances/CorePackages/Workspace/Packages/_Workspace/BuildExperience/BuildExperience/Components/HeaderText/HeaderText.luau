local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text

local function HeaderText(p)
	return React.createElement(Text, {
		Text = p.text,
		tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
		LayoutOrder = p.LayoutOrder,
		testId = "build-header-text"
	})
end

return HeaderText
