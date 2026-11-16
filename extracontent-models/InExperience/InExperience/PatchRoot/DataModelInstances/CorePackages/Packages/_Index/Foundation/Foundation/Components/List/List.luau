local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Enums.InputSize)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local ListContext = require(script.Parent.ListContext)

local v = {
	hasDivider = { hasDivider = true, isInset = true },
	isContained = { isContained = false, hasMargin = true },
	testId = "--foundation-list"
}

local function List(p, ref)
	local v2 = withDefaults(p, v)
	local hasDivider

	if type(v2.hasDivider) == "boolean" then
		hasDivider = v2.hasDivider
	else
		hasDivider = v2.hasDivider.hasDivider
	end

	local maxLayoutOrder = 0

	if hasDivider then
		React.Children.forEach(v2.children, function(p2)
			if p2 and p2.props and p2.props.LayoutOrder then
				maxLayoutOrder = math.max(maxLayoutOrder, p2.props.LayoutOrder)
			end
		end)
	end

	local isContained

	if type(v2.isContained) == "boolean" then
		isContained = v2.isContained
	else
		isContained = v2.isContained.isContained
	end

	local hasMargin = isContained and true or type(v2.isContained) ~= "table" or v2.isContained.hasMargin
	local isInset

	if type(v2.hasDivider) == "boolean" then
		isInset = v2.hasDivider
	else
		isInset = v2.hasDivider.isInset
	end

	local v3 = React.useMemo(function()
		return {
			hasDivider = v2.hasDivider,
			isContained = isContained,
			isInset = isInset,
			hasMargin = hasMargin,
			lastLayoutOrder = maxLayoutOrder,
			size = v2.size,
			testId = v2.testId
		}
	end, { hasDivider, isContained, isInset, hasMargin, maxLayoutOrder, v2.size, v2.testId })

	return React.createElement(View, withCommonProps(v2, {
		tag = { ["col size-full-0 auto-y"] = true, ["stroke-default radius-large"] = isContained },
		ref = ref
	}), {
		ListContext = React.createElement(ListContext.Provider, { value = v3 }, v2.children)
	})
end

return React.memo(React.forwardRef(List))
