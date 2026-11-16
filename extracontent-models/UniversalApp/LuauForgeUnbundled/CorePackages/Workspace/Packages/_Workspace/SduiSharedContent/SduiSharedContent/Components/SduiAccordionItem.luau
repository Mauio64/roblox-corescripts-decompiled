local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local accordion = Foundation.Accordion

local function SduiAccordionItem(props)
	local v5 = React.useMemo(function()
		if props.icon and props.iconVariant then
			return { name = props.icon, variant = props.iconVariant }
		end

		return props.icon
	end, { props.icon, props.iconVariant })

	return React.createElement(accordion.Item, {
		id = props.index or props.layoutOrder or 1,
		text = props.text or "",
		description = props.description,
		icon = v5,
		hasDivider = props.hasDivider,
		isExpanded = props.isExpanded,
		LayoutOrder = props.layoutOrder
	}, props.content)
end

return React.memo(SduiAccordionItem)
