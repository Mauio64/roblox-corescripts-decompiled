local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local AccordionContext = require(script.Parent.AccordionContext)
require(script.Parent.useAccordion)

local InputPlacement = require(Foundation.Enums.InputPlacement)
local InputSize = require(Foundation.Enums.InputSize)

local v = {
	chevronPosition = InputPlacement.End,
	isContained = false,
	size = InputSize.Medium,
	width = UDim.new(1, 0),
	testId = "--foundation-accordion"
}

local function Accordion(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = React.useMemo(function()
		return {
			onAccordionItemActivated = v2.onActivated,
			itemSize = v2.size,
			isContained = v2.isContained,
			chevronPosition = v2.chevronPosition,
			testId = v2.testId
		}
	end, { v2.onActivated, v2.size, v2.isContained, v2.chevronPosition, v2.testId })

	return React.createElement(
		View,
		withCommonProps(v2, {
			tag = "col flex-y-evenly auto-y",
			Size = UDim2.new(v2.width, UDim.new(0, 0)),
			ref = ref
		}),
		{
			AccordionContext = React.createElement(AccordionContext.Provider, { value = v3 }, v2.children)
		}
	)
end

return React.memo(React.forwardRef(Accordion))
