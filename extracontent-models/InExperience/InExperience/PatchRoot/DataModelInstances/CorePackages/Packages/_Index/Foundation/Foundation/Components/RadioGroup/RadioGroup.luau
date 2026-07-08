local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local RadioGroupContext = require(script.Parent.RadioGroupContext)
local t1 = {
	Selectable = true,
	testId = "--foundation-radio-group"
}

local function RadioGroup(p1, p2) -- line: 26
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), RadioGroupContext (copy)
	local v12 = withDefaults(p1, t1)
	local v13, v14 = React.useState(v12.value)

	React.useEffect(function() -- line: 30
		-- upvalues: v12 (copy), v14 (copy)
		if v12.value ~= nil then
			v14(v12.value)
		end
	end, { v12.value })

	local v15 = React.useCallback(function(s1: string) -- line: 36
		-- upvalues: v14 (copy), v12 (copy)
		v14(s1)
		v12.onValueChanged(s1)
	end, {
		v14,
		v12.onValueChanged
	})

	return React.createElement(View, withCommonProps(v12, {
		tag = "col gap-medium auto-xy",
		ref = p2
	}), {
		RadioGroupContext = React.createElement(RadioGroupContext.Provider, {
			value = {
				value = v13,
				onValueChanged = v15,
				Selectable = v12.Selectable,
				testId = v12.testId
			}
		}, v12.children)
	})
end

return React.memo(React.forwardRef(RadioGroup))
