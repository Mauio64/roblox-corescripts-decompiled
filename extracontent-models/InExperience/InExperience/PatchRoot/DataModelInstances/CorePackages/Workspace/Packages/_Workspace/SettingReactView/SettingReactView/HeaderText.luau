local parent = script.Parent.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text

local function HeaderText(p)
	return React.createElement(Text, {
		tag = "auto-xy content-emphasis text-heading-small",
		Text = p.text,
		testId = "settings-header-text"
	})
end

return React.memo(HeaderText)
