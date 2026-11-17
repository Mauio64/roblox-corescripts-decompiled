local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function escapeRichText(description: string) -- 1 equivalent call inferred from this helper
	return (description:gsub("[&<>]", { ["&"] = "&amp;", ["<"] = "&lt;", [">"] = "&gt;" }))
end

local function SettingsFieldBase(props)
	local createElement = React.createElement
	local item = Foundation.List.Item
	local v = {
		title = props.title,
		description = 0,
		trailing = 0,
		onActivated = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local description

	if props.description then
		description = escapeRichText(props.description) -- inferred equivalent call
	end

	v.description = description

	v.trailing = props.trailing
	v.onActivated = props.onClick
	v.LayoutOrder = props.LayoutOrder
	v.testId = props.testId
	return createElement(item, v)
end

return SettingsFieldBase
