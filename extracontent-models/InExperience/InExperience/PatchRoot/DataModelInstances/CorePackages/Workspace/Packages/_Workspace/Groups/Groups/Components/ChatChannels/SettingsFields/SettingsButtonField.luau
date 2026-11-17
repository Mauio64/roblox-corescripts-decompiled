local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SettingsFieldBase = require(script.Parent.SettingsFieldBase)

local function SettingsButtonField(props)
	local createElement = React.createElement
	local v = {
		title = props.title,
		description = props.description,
		trailing = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local createElement2 = React.createElement
	local view = Foundation.View

	local createElement3 = React.createElement
	local button = Foundation.Button
	local v2 = {
		text = props.buttonText,
		variant = props.buttonVariant,
		onActivated = props.onClick,
		size = Foundation.Enums.InputSize.Medium,
		testId = 0
	}
	local testId

	if props.testId then
		testId = `{props.testId}--button`
	end

	v2.testId = testId
	v.trailing = createElement2(view, { tag = "auto-xy" }, { Button = createElement3(button, v2) })

	v.LayoutOrder = props.LayoutOrder
	v.testId = props.testId
	return createElement(SettingsFieldBase, v)
end

return SettingsButtonField
