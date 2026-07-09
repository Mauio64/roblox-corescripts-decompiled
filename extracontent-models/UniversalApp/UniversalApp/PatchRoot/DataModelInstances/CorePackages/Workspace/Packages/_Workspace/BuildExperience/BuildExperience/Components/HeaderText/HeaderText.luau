local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local FoundationText = Foundation.Text

local function HeaderText(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
		testId = "build-header-text",
		Text = t1.text,
		LayoutOrder = t1.LayoutOrder
	})
end

return HeaderText
