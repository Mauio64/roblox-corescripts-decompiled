local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Components = Foundation.Components
local Text = require(Components.Text)
require(Components.Types)
local View = require(Components.View)

local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InputPlacement = require(Foundation.Enums.InputPlacement)
local InputSize = require(Foundation.Enums.InputSize)

local InputGroupContext = require(script.Parent.InputGroupContext)
local useInputGroupVariants = require(script.Parent.useInputGroupVariants)

local v = {
	size = InputSize.Medium,
	placement = InputPlacement.Start,
	testId = "--foundation-internal-input-group"
}

local function InternalInputGroup(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useInputGroupVariants(useTokens(), v2.size)

	local v4 = React.useMemo(function()
		return { size = v2.size, placement = v2.placement }
	end, { v2.size, v2.placement })

	local createElement = React.createElement

	local v5 = withCommonProps(v2, { tag = v3.container.tag, ref = ref })

	local createElement2 = React.createElement
	local provider = InputGroupContext.Provider
	local groupLabel

	if not (v2.legend == nil or v2.legend == "") then
		groupLabel = React.createElement(Text, {
			Text = v2.legend,
			tag = v3.legend.tag,
			testId = `{v2.testId}--label`,
			LayoutOrder = 0
		})
	end

	return createElement(View, v5, {
		InputGroupContext = createElement2(provider, { value = v4 }, {
			GroupLabel = groupLabel,
			Children = React.createElement(View, { tag = v3.children.tag, LayoutOrder = 1 }, v2.children)
		})
	})
end

return React.memo(React.forwardRef(InternalInputGroup))
