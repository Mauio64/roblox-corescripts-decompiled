local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Icon = require(Foundation.Components.Icon)
local View = require(Foundation.Components.View)
local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Components.Types)

local useRotation = require(Foundation.Utility.useRotation)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-loading",
	size = IconSize.Large
}

local function Loading(p1, p2) -- line: 27
	-- upvalues: withDefaults (copy), t1 (copy), useRotation (copy), useTokens (copy), React (copy), View (copy), withCommonProps (copy), Icon (copy)
	local v15 = withDefaults(p1, t1)
	local v16 = useRotation()
	local v17 = useTokens()
	local t2 = {
		name = "icons/graphic/loadingspinner",
		size = v15.size,
		style = v17.DarkMode.Content.Emphasis,
		Rotation = v16,
		ref = p2,
		testId = `{ v15.testId }--icon`
	}

	return React.createElement(View, withCommonProps(v15, {
		tag = "auto-xy"
	}), {
		Icon = React.createElement(Icon, t2)
	})
end

return React.memo(React.forwardRef(Loading))
