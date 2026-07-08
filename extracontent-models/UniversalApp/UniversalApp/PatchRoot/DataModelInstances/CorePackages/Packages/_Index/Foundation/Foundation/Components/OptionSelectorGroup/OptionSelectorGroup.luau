local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Orientation = require(Foundation.Enums.Orientation)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local OptionSelectorGroupContext = require(script.Parent.OptionSelectorGroupContext)
local t1 = {
	Selectable = true,
	testId = "--foundation-option-selector-group",
	orientation = Orientation.Vertical
}

local function OptionSelectorGroup(p1, p2) -- line: 32
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), Orientation (copy), OptionSelectorGroupContext (copy)
	local v13 = withDefaults(p1, t1)
	local v14, v15 = React.useState(v13.value)

	React.useEffect(function() -- line: 36
		-- upvalues: v13 (copy), v15 (copy)
		if v13.value ~= nil then
			v15(v13.value)
		end
	end, { v13.value })

	local v16 = React.useCallback(function(s1: string) -- line: 42
		-- upvalues: v15 (copy), v13 (copy)
		v15(s1)
		v13.onValueChanged(s1)
	end, {
		v15,
		v13.onValueChanged
	})

	return React.createElement(View, withCommonProps(v13, {
		tag = {
			["col size-full-0 auto-y"] = v13.orientation == Orientation.Vertical,
			["row auto-x"] = v13.orientation == Orientation.Horizontal,
			["gap-small"] = true
		},
		ref = p2
	}), {
		OptionSelectorGroupContext = React.createElement(OptionSelectorGroupContext.Provider, {
			value = {
				value = v14,
				onValueChanged = v16,
				orientation = v13.orientation,
				Selectable = v13.Selectable,
				testId = v13.testId
			}
		}, v13.children)
	})
end

return React.memo(React.forwardRef(OptionSelectorGroup))
