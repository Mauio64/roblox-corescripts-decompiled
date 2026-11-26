local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation").Text

local function AccountUpgradeFieldError(props)
	if props.text == nil or props.text == "" then
		return nil
	end

	return React.createElement(text, {
		Text = props.text,
		tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-system-alert",
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	})
end

return AccountUpgradeFieldError
