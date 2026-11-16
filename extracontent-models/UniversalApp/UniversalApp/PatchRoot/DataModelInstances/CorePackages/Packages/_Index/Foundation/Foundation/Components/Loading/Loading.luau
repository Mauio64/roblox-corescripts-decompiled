local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Icon = require(Foundation.Components.Icon)
local View = require(Foundation.Components.View)

local IconSize = require(Foundation.Enums.IconSize)

require(Foundation.Components.Types)
local useRotation = require(Foundation.Utility.useRotation)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { size = IconSize.Large, testId = "--foundation-loading" }

local function Loading(p, ref)
	local v2 = withDefaults(p, v)
	local rotation = useRotation()
	local v3 = useTokens()

	local v4 = {
		name = "icons/graphic/loadingspinner",
		size = v2.size,
		style = v3.DarkMode.Content.Emphasis,
		Rotation = rotation,
		ref = ref,
		testId = `{v2.testId}--icon`
	}

	return React.createElement(View, withCommonProps(v2, { tag = "auto-xy" }), {
		Icon = React.createElement(Icon, v4)
	})
end

return React.memo(React.forwardRef(Loading))
