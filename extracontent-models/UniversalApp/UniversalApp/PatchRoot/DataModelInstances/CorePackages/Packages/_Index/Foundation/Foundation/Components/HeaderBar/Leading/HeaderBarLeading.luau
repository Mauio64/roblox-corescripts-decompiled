local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Flags = require(Foundation.Utility.Flags)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)

local function HeaderBarLeading(p)
	local v = useHeaderBarContext()

	if not Flags.FoundationHeaderBarSlotSizing then
		return React.createElement(
			HeaderBarContext.Provider,
			{ testId = v.testId, slot = HeaderBarSlot.Leading },
			React.createElement(
				View,
				{
					tag = "row align-y-center shrink gap-small size-full",
					LayoutOrder = constants.LEADING_LAYOUT_ORDER,
					testId = `{v.testId}--leading`
				},
				p.children
			)
		)
	end

	local onSideWidthChanged = v.onSideWidthChanged

	React.useLayoutEffect(function()
		return function()
			if onSideWidthChanged then
				onSideWidthChanged(HeaderBarSlot.Leading, 0)
			end
		end
	end, { onSideWidthChanged })

	return React.createElement(HeaderBarContext.Provider, {
		testId = v.testId,
		slot = HeaderBarSlot.Leading,
		leadingWidth = v.leadingWidth,
		trailingWidth = v.trailingWidth,
		onSideWidthChanged = onSideWidthChanged
	}, React.createElement(
		View,
		{
			tag = "row align-x-left align-y-center size-full",
			LayoutOrder = constants.LEADING_LAYOUT_ORDER,
			ZIndex = 2,
			testId = `{v.testId}--leading`
		},
		{
			Content = React.createElement(View, {
				tag = "row align-y-center gap-small size-0-full auto-x",
				LayoutOrder = 1,
				onAbsoluteSizeChanged = function(p2)
					if onSideWidthChanged then
						onSideWidthChanged(HeaderBarSlot.Leading, p2.AbsoluteSize.X)
					end
				end,
				testId = `{v.testId}--leading--content`
			}, p.children)
		}
	))
end

return HeaderBarLeading
