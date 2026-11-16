local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
local module3 = require("@luauforge/deferred/gpJ")

local module4 = require("@luauforge/deferred/gpK")

local grid = module3.GridComponents.Grid
local useTokens = module2.Hooks.useTokens
local useBreakpoint = module2.Hooks.useBreakpoint

local function getCardId(p2)
	return p2.id
end

local function getCardsPerRow(p2, p3)
	return (math.max(2, (math.min(math.ceil((p2 + p3) / (120 + p3)), (math.floor((p2 + p3) / (88 + p3)))))))
end

local function getCardWidth(p2, p3, p4)
	return (math.max(0, (math.floor((p2 + p4) / p3 - p4))))
end

local function PhotoboothMomentsCardPanelView(props)
	local v5 = useTokens()
	local small = v5.Gap.Small

	local xxSmall = v5.Padding.XXSmall

	local state, setState = module.useState(nil)

	local v6 = module.useCallback(function(p2)
		setState(p2)
	end, {})
	local v7, v8 = useBreakpoint(state)

	local v9 = math.max(0, v8.X - xxSmall * 2)
	local v10 = math.max(
		2,
		(math.min(math.ceil((v9 + small) / (120 + small)), (math.floor((v9 + small) / (88 + small)))))
	)

	local v11 = math.max(0, (math.floor((v9 + small) / v10 - small)))

	local hideCardTitles = props.hideCardTitles
	local cardAspectRatio = props.cardAspectRatio
	local v12 = module.useCallback(function(p2)
		local item = p2.item
		return module.createElement(module4, {
			itemId = item.id,
			itemName = item.itemName,
			thumbnailUrl = item.thumbnailUrl,
			itemWidth = v11,
			onActivated = item.onActivated,
			isSelected = item.isSelected,
			hideTitle = hideCardTitles,
			thumbnailAspectRatio = cardAspectRatio,
			tagText = item.tagText,
			LayoutOrder = p2.index
		})
	end, { v11, hideCardTitles, cardAspectRatio })

	local onEndReached = props.onEndReached
	local v13 = module.useCallback(function(data)
		if data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y - data.CanvasPosition.Y <= 200 then
			onEndReached()
		end
	end, { onEndReached })

	local hasMore = props.hasMore
	local v14 = module.useCallback(function(p2)
		if hasMore and p2.AbsoluteCanvasSize.Y <= p2.AbsoluteWindowSize.Y then
			onEndReached()
		end
	end, { hasMore, onEndReached })

	local testId = props.testId

	return module.createElement(module2.View, {
		tag = "col grow gap-small size-full-0",
		testId = testId
	}, {
		Header = module.createElement(
			module2.View,
			{
				tag = "row align-y-center gap-small size-full-0 auto-y padding-y-xsmall",
				LayoutOrder = 1,
				testId = `{testId}_Header`
			},
			{
				Title = module.createElement(module2.Text, {
					tag = "grow auto-y text-heading-small text-align-x-left content-emphasis",
					Text = props.title,
					LayoutOrder = 1,
					testId = `{testId}_Title`
				}),
				CloseButton = module.createElement(module2.IconButton, {
					icon = module2.Enums.IconName.X,
					onActivated = props.onClose,
					LayoutOrder = 2,
					testId = `{testId}_CloseButton`
				})
			}
		),
		List = module.createElement(module2.ScrollView, {
			tag = "grow size-full-0 padding-xxsmall",
			LayoutOrder = 2,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				CanvasSize = UDim2.fromScale(0, 0)
			},
			scrollingFrameRef = v6,
			onCanvasPositionChanged = v13,
			onAbsoluteCanvasSizeChanged = v14,
			onAbsoluteWindowSizeChanged = v14,
			testId = `{testId}_List`
		}, {
			Cards = module.createElement(grid, {
				items = props.cards,
				itemsPerRow = v10,
				getItemId = getCardId,
				renderItem = v12,
				gapVertical = small,
				gapHorizontal = small,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			})
		})
	})
end

return PhotoboothMomentsCardPanelView
