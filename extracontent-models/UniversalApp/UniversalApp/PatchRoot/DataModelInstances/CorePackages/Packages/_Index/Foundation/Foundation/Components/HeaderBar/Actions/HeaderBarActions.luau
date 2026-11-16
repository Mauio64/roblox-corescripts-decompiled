local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.BuilderIcons)
local React = require(parent.React)

local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local IconButton = require(Foundation.Components.IconButton)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function HeaderBarActions(p)
	local v = useHeaderBarContext()
	local v2 = useTokens()

	local layoutOrder, padding = React.useMemo(function()
		if v.slot == HeaderBarSlot.Leading then
			return constants.LEADING_ACTIONS_LAYOUT_ORDER, {
				left = UDim.new(0, -v2.Size.Size_200)
			}
		end

		if v.slot == HeaderBarSlot.Trailing then
			return constants.TRAILING_ACTIONS_LAYOUT_ORDER, {
				right = UDim.new(0, -v2.Size.Size_200)
			}
		end

		return nil, nil
	end, { v.slot, v2.Size.Size_200 })

	local children = {}

	for k, action in p.actions do
		children[tostring(action.id)] = React.createElement(IconButton, {
			icon = action.icon,
			onActivated = action.onActivated,
			LayoutOrder = k,
			testId = `{v.testId}--actions--{action.id}`
		})
	end

	return React.createElement(
		View,
		{
			tag = "row align-y-center shrink gap-small auto-xy",
			padding = padding,
			LayoutOrder = layoutOrder,
			testId = `{v.testId}--actions`
		},
		children
	)
end

return React.memo(HeaderBarActions)
