local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local InternalInputGroup = require(Foundation.Components.InternalInputGroup)
require(Foundation.Components.Types)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { testId = "--foundation-toggle-group" }

local function ToggleGroup(p, ref)
	local v2 = withDefaults(p, v)

	return React.createElement(
		InternalInputGroup,
		withCommonProps(v2, {
			legend = v2.legend,
			size = v2.size,
			placement = v2.placement,
			ref = ref
		}),
		v2.children
	)
end

return React.memo(React.forwardRef(ToggleGroup))
