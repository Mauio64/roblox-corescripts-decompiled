local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SettingsFieldBase = require(script.Parent.SettingsFieldBase)

local function SettingsToggleField(props)
	local createElement = React.createElement
	local v = {
		title = props.title,
		description = props.description,
		trailing = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local createElement2 = React.createElement
	local toggle = Foundation.Toggle
	local v2 = {
		label = "",
		isChecked = props.value,
		onActivated = props.onChange,
		size = Foundation.Enums.InputSize.Medium,
		testId = 0
	}
	local testId

	if props.testId then
		testId = `{props.testId}--toggle`
	end

	v2.testId = testId
	v.trailing = createElement2(toggle, v2)

	v.LayoutOrder = props.LayoutOrder
	v.testId = props.testId
	return createElement(SettingsFieldBase, v)
end

return SettingsToggleField
