local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local AccordionContext = require(script.Parent.AccordionContext)

require(script.Parent.useAccordion)

local InputSize = require(Foundation.Enums.InputSize)
local t1 = {
	testId = "--foundation-accordion",
	size = InputSize.Medium,
	width = UDim.new(1, 0)
}

local function Accordion(p1, p2) -- line: 35
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), AccordionContext (copy)
	local v13 = withDefaults(p1, t1)

	return React.createElement(View, withCommonProps(v13, {
		tag = "col flex-y-evenly auto-y",
		Size = UDim2.new(v13.width, UDim.new(0, 0)),
		ref = p2
	}), {
		AccordionContext = React.createElement(AccordionContext.Provider, {
			value = {
				onAccordionItemActivated = v13.onActivated,
				itemSize = v13.size,
				testId = v13.testId
			}
		}, v13.children)
	})
end

return React.memo(React.forwardRef(Accordion))
