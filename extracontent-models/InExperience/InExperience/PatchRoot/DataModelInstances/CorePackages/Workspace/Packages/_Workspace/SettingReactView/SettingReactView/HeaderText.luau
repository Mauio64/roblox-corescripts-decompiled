local ParentParent = script.Parent.Parent
local Foundation = require(ParentParent.Foundation)
local React = require(ParentParent.React)
local FoundationText = Foundation.Text

local function HeaderText(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		tag = "auto-xy content-emphasis text-heading-small",
		testId = "settings-header-text",
		Text = t1.text
	})
end

return React.memo(HeaderText)
