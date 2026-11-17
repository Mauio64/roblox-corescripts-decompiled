local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local HeaderBarContext = require(Foundation.Components.HeaderBar.HeaderBarContext)
local HeaderBarSlot = require(Foundation.Enums.HeaderBarSlot)
local View = require(Foundation.Components.View)
local constants = require(Foundation.Components.HeaderBar.constants)
local useHeaderBarContext = require(Foundation.Components.HeaderBar.useHeaderBarContext)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function HeaderBarContent(p)
	local v = useHeaderBarContext()

	if not Flags.FoundationHeaderBarSlotSizing then
		return React.createElement(
			HeaderBarContext.Provider,
			{ testId = v.testId, slot = HeaderBarSlot.Content },
			React.createElement(
				View,
				{
					tag = "align-y-center grow size-0-full auto-x",
					LayoutOrder = constants.CONTENT_LAYOUT_ORDER,
					testId = `{v.testId}--content`
				},
				p.children
			)
		)
	end

	local v2 = useTokens()
	local leadingWidth = v.leadingWidth or 0
	local trailingWidth = v.trailingWidth or 0
	local v3 = not (leadingWidth > 0) and 0 or leadingWidth + v2.Gap.Small
	local v4 = not (trailingWidth > 0) and 0 or trailingWidth + v2.Gap.Small

	local xSmall = v2.Padding.XSmall

	local v5 = v4 - v3

	local createElement = React.createElement
	local provider = HeaderBarContext.Provider
	local v6 = {
		testId = v.testId,
		slot = HeaderBarSlot.Content,
		leadingWidth = v.leadingWidth,
		trailingWidth = v.trailingWidth,
		onSideWidthChanged = v.onSideWidthChanged
	}

	local createElement2 = React.createElement
	local v7 = {
		tag = "size-full",
		LayoutOrder = constants.CONTENT_LAYOUT_ORDER,
		ZIndex = 1,
		testId = `{v.testId}--content`
	}

	local createElement3 = React.createElement
	local v8 = {
		tag = "row align-x-center align-y-center padding-x-xsmall clip",
		Position = UDim2.fromOffset(v3 - xSmall, 0),
		Size = UDim2.new(1, 2 * xSmall - v3 - v4, 1, 0),
		LayoutOrder = 1,
		testId = `{v.testId}--content--content`
	}

	local createElement4 = React.createElement
	local v9 = {
		tag = "shrink",
		Size = UDim2.fromOffset(math.abs(v5), 0),
		LayoutOrder = 0
	}
	local layoutOrder

	if v5 > 0 then
		layoutOrder = Constants.MIN_LAYOUT_ORDER
	else
		layoutOrder = Constants.MAX_LAYOUT_ORDER - 1
	end

	v9.LayoutOrder = layoutOrder
	return createElement(provider, v6, createElement2(View, v7, {
		Content = createElement3(View, v8, {
			CenteringSpacer = createElement4(View, v9),
			Children = React.createElement(React.Fragment, nil, p.children)
		})
	}))
end

return HeaderBarContent
