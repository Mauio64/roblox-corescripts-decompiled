local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.InputSize)
require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local ListContext = require(script.Parent.ListContext)
local t1 = {
	testId = "--foundation-list",
	hasDivider = {
		hasDivider = true,
		isInset = true
	},
	isContained = {
		isContained = false,
		hasMargin = true
	}
}

local function List(p1, p2) -- line: 31
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), View (copy), withCommonProps (copy), ListContext (copy)
	local v12 = withDefaults(p1, t1)
	local n1 = 0

	React.Children.forEach(v12.children, function(p3) -- line: 35
		-- upvalues: n1 (ref)
		if p3 and (p3.props and p3.props.LayoutOrder) then
			n1 = math.max(n1, p3.props.LayoutOrder)
		end
	end)

	local v14 = if type(v12.isContained) ~= "boolean" then v12.isContained.isContained else v12.isContained
	local v15 = not not v14 or (type(v12.isContained) ~= "table" or v12.isContained.hasMargin)
	local v16 = if type(v12.hasDivider) ~= "boolean" then v12.hasDivider.isInset else v12.hasDivider

	return React.createElement(View, withCommonProps(v12, {
		tag = {
			["col size-full-0 auto-y"] = true,
			["stroke-default radius-large"] = v14
		},
		ref = p2
	}), {
		ListContext = React.createElement(ListContext.Provider, {
			value = {
				hasDivider = v12.hasDivider,
				isContained = v14,
				isInset = v16,
				hasMargin = v15,
				lastLayoutOrder = n1,
				size = v12.size,
				testId = v12.testId
			}
		}, v12.children)
	})
end

return React.memo(React.forwardRef(List))
