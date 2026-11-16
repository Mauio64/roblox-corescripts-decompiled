local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Accordion = Foundation.Accordion

local function SduiAccordionItem(props)
	local icon = React.useMemo(function()
		if props.icon and props.iconVariant then
			return { name = props.icon, variant = props.iconVariant }
		end

		return props.icon
	end, { props.icon, props.iconVariant })

	return React.createElement(Accordion.Item, {
		id = props.index or props.layoutOrder or 1,
		text = props.text or "",
		description = props.description,
		icon = icon,
		hasDivider = props.hasDivider,
		isExpanded = props.isExpanded,
		LayoutOrder = props.layoutOrder
	}, props.content)
end

return React.memo(SduiAccordionItem)
