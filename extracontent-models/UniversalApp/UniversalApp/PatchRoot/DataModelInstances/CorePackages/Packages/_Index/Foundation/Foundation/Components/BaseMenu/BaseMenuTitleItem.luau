local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Text = require(Foundation.Components.Text)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)

require(Foundation.Enums.ControlState)
require(Foundation.Enums.InputSize)

local Flags = require(Foundation.Utility.Flags)
local useBaseMenuItemVariants = require(script.Parent.useBaseMenuItemVariants)

local function BaseMenuTitleItem(p1, p2) -- line: 32
	-- upvalues: useTokens (copy), useBaseMenuItemVariants (copy), Flags (copy), React (copy), View (copy), withCommonProps (copy), Text (copy)
	local v13 = useTokens()
	local v14 = useBaseMenuItemVariants(v13, p1.size, false, false)

	if Flags.FoundationBaseMenuBeta then
		local v15 = if p1.menuHasCheck ~= true then v14.container.paddingLeftWithoutCheck or 0 else (v14.container.paddingLeftWithCheck or 0) + (v14.title.checkColumnWidth or 0)
		local v16 = v14.container.paddingRight or 0

		return React.createElement(View, withCommonProps(p1, {
			tag = `row align-y-center { v14.container.tag }`,
			padding = {
				left = UDim.new(0, v15),
				right = UDim.new(0, v16)
			},
			ref = p2
		}), React.createElement(Text, {
			Text = p1.text,
			tag = v14.title.tag
		}))
	end

	return React.createElement(View, withCommonProps(p1, {
		tag = v14.container.tag,
		ref = p2
	}), React.createElement(Text, {
		Text = p1.text,
		tag = v14.title.tag
	}))
end

return React.memo(React.forwardRef(BaseMenuTitleItem))
