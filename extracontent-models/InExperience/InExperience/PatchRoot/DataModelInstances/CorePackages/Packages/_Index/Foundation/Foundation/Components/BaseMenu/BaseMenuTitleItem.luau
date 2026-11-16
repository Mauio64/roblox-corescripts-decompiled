local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Text = require(Foundation.Components.Text)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local useTokens = require(Foundation.Providers.Style.useTokens)

local withCommonProps = require(Foundation.Utility.withCommonProps)

require(Foundation.Enums.ControlState)

require(Foundation.Enums.InputSize)

local useBaseMenuItemVariants = require(script.Parent.useBaseMenuItemVariants)

local function BaseMenuTitleItem(props, ref)
	local v = useBaseMenuItemVariants(useTokens(), props.size, false)
	local v2

	if props.menuHasCheck == true then
		v2 = (v.container.paddingLeftWithCheck or 0) + (v.title.checkColumnWidth or 0)
	else
		v2 = v.container.paddingLeftWithoutCheck or 0
	end

	local paddingRight = v.container.paddingRight or 0

	return React.createElement(View, withCommonProps(props, {
		tag = `row align-y-center {v.container.tag}`,
		padding = { left = UDim.new(0, v2), right = UDim.new(0, paddingRight) },
		ref = ref
	}), React.createElement(Text, { Text = props.text, tag = v.title.tag }))
end

return React.memo(React.forwardRef(BaseMenuTitleItem))
