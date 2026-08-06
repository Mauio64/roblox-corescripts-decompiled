local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Orientation = require(Foundation.Enums.Orientation)
local Flags = require(Foundation.Utility.Flags)

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

local function OptionSelectorGroup(p1, p2) -- line: 33
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), Orientation (copy), Flags (copy), OptionSelectorGroupContext (copy)
	local v14 = withDefaults(p1, t1)
	local v15, v16 = React.useState(v14.value)

	React.useEffect(function() -- line: 37
		-- upvalues: v14 (copy), v16 (copy)
		if v14.value ~= nil then
			v16(v14.value)
		end
	end, { v14.value })

	local v17 = React.useCallback(function(s1: string) -- line: 43
		-- upvalues: v16 (copy), v14 (copy)
		v16(s1)
		v14.onValueChanged(s1)
	end, {
		v16,
		v14.onValueChanged
	})

	return React.createElement(View, withCommonProps(v14, {
		tag = {
			["col size-full-0 auto-y"] = v14.orientation == Orientation.Vertical,
			["row size-full-0 auto-y"] = Flags.FoundationOptionSelectorGroupFixes and v14.orientation == Orientation.Horizontal,
			["row auto-x"] = not Flags.FoundationOptionSelectorGroupFixes and v14.orientation == Orientation.Horizontal,
			["gap-small"] = true
		},
		ref = p2
	}), {
		OptionSelectorGroupContext = React.createElement(OptionSelectorGroupContext.Provider, {
			value = {
				value = v15,
				onValueChanged = v17,
				orientation = v14.orientation,
				Selectable = v14.Selectable,
				testId = v14.testId
			}
		}, v14.children)
	})
end

return React.memo(React.forwardRef(OptionSelectorGroup))
