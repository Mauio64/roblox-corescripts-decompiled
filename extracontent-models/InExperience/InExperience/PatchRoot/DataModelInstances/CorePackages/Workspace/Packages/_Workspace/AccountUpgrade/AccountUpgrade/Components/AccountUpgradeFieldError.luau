local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Text = Foundation.Text

local function AccountUpgradeFieldError(props)
	if props.text == nil or props.text == "" then
		return nil
	end

	return React.createElement(Text, {
		Text = props.text,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-system-alert",
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return AccountUpgradeFieldError
