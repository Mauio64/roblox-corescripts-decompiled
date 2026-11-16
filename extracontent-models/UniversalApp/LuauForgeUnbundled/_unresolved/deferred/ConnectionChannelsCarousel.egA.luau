local module = require("@luauforge/deferred/eeO")

local module2 = require("@luauforge/deferred/efi")
local module3 = require("@luauforge/deferred/egB")
local collectionCarousel = module3.CollectionCarousel
local collectionItemSize = module3.CollectionViewTypes.CollectionItemSize
local useCollectionLayoutParams = module3.useCollectionLayoutParams
local collectionLayoutCalculators = module3.CollectionLayoutCalculators
local calculateNumColumns = module3.calculateNumColumns

local useTokens = require("@luauforge/deferred/ege").Hooks.useTokens

local getPageMargin = require("@luauforge/deferred/egd").App.Container.getPageMargin
local useScreenSize = require("@luauforge/deferred/efV").useScreenSize
local useSelector = require("@luauforge/deferred/efh").Hooks.RoactRodux.useSelector
local fFlagAFPConnectionsChannelsHeader = require("@luauforge/deferred/efc").FFlagAFPConnectionsChannelsHeader
local fFlagConnectionChannelsTileSize = require("@luauforge/deferred/efc").FFlagConnectionChannelsTileSize

local function ConnectionChannelsCarousel(props)
	local layoutOrder = props.layoutOrder
	local items = props.items
	local renderItem = props.renderItem
	local contextualInfoHeight = props.contextualInfoHeight
	local headerComponent = if fFlagAFPConnectionsChannelsHeader then props.headerComponent else nil

	local v5 = useScreenSize()
	local v6 = useSelector(function(p2)
		return p2.GlobalGuiInset and p2.GlobalGuiInset.left or 0
	end)

	local vector2 = Vector2.new(v5.X - 2 * getPageMargin(v5.X) - v6, 1)

	local state, setState = module.useState(nil)

	local v7 = useTokens()
	local v8

	if fFlagConnectionChannelsTileSize then
		v8 = module.useMemo(function()
			return module2.Dictionary.join(collectionLayoutCalculators, {
				calculateNumColumns = function(p2, p3, p4, p5, p6)
					return calculateNumColumns(69 * v7.Config.UI.Scale, p4, 3, 20, p2 - 2 * p3)
				end
			})
		end, { v7.Config.UI.Scale })
	end

	local xSmall = collectionItemSize.XSmall

	if not fFlagConnectionChannelsTileSize then
		v8 = nil
	end

	local v12 = useCollectionLayoutParams(xSmall, state, true, { sideMargin = 0 }, v8, vector2)

	local state2, setState2 = module.useState(false)
	local v14 = module.useCallback(function()
		setState2(true)
	end, {})

	local createElement = module.createElement
	local v16 = {
		LayoutOrder = layoutOrder,
		containerRef = setState,
		items = not state2 and {} or items,
		numColumns = v12.numColumns,
		fractionalItemAmount = v12.fractionalItemAmount,
		columnGap = v12.columnGap,
		onContainerSizeChanged = v14,
		headerComponent = 0,
		renderItem = 0,
		getItemHeight = 0
	}

	if not fFlagAFPConnectionsChannelsHeader then
		headerComponent = nil
	end

	v16.headerComponent = headerComponent

	v16.renderItem = renderItem
	function v16.getItemHeight(p2)
		return p2 + contextualInfoHeight * v7.Config.UI.Scale
	end

	return createElement(collectionCarousel, v16)
end

return ConnectionChannelsCarousel
