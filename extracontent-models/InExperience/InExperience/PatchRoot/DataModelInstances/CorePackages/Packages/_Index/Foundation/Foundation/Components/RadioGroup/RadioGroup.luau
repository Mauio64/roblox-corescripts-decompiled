local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InternalInputGroup = require(Foundation.Components.InternalInputGroup)
local RadioGroupContext = require(script.Parent.RadioGroupContext)

local InputSize = require(Foundation.Enums.InputSize)

local InputPlacement = require(Foundation.Enums.InputPlacement)

local v = {
	size = InputSize.Medium,
	placement = InputPlacement.Start,
	Selectable = true,
	testId = "--foundation-radio-group"
}

local function RadioGroup(p, ref)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(v2.value)

	React.useEffect(function()
		if v2.value ~= nil then
			setState(v2.value)
		end
	end, { v2.value })

	local onValueChanged = React.useCallback(function(p2: string)
		setState(p2)
		v2.onValueChanged(p2)
	end, { setState, v2.onValueChanged })

	local v3 = React.useMemo(function()
		return {
			value = state,
			onValueChanged = onValueChanged,
			Selectable = v2.Selectable,
			testId = v2.testId
		}
	end, { state, onValueChanged, v2.Selectable, v2.testId })
	return (React.createElement(
		InternalInputGroup,
		withCommonProps(v2, {
			size = v2.size,
			placement = v2.placement,
			legend = v2.legend,
			ref = ref
		}),
		{
			RadioGroupContext = React.createElement(RadioGroupContext.Provider, { value = v3 }, v2.children)
		}
	))
end

return React.memo(React.forwardRef(RadioGroup))
