local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent

local React = require(parent.React)
local GameTile = require(parent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local useCollectionLayout = CollectionViews.useCollectionLayout
local useGetGameTileHeight = require(GameCollections.useGetGameTileHeight)
local useGameCollectionLayoutParams = require(GameCollections.useGameCollectionLayoutParams)
local GameTile2 = require(parent.GameTile)
local getGameTileCollectionItemSize = GameTile2.getGameTileCollectionItemSize
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways

local v = {}

local function renderItem(_, _, _, _): (nil, string)
	return nil, "placeholder"
end

local function PlaceholderGameGrid(props)
	local v2 = useAppPolicy(function(p)
		return p.useGridPageLayout()
	end)

	local v3 = usePreferredInput()
	local v4 = props.isHoverSupportEnabled and v2 and v3 == Responsive.Input.Pointer

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v5 = FFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local collectionItemSize

	if v5 then
		collectionItemSize = getGameTileCollectionItemSize(gameTileLayoutType)
	end

	local state, setState = React.useState(nil)
	local useRef = React.useRef(state)
	useRef.current = state

	local v6 = useGameCollectionLayoutParams(
		gameTileLayoutType,
		state,
		false,
		not v2 and { sideMargin = props.sideMargin } or nil
	)

	local v7 = useCollectionLayout(collectionItemSize).itemsPerRow

	if not v5 then
		v7 = v6.numColumns
	end

	local shouldHideTileTitle = props.shouldHideTileTitle or false
	local shouldHideTileMetadata = props.shouldHideTileMetadata or false
	local containedTile = props.containedTile or false
	local titleTextLines = GameTileConstants.TileTextLines[gameTileLayoutType]
		and GameTileConstants.TileTextLines[gameTileLayoutType].titleTextLines

	local getItemHeight = useGetGameTileHeight(
		v4,
		gameTileLayoutType,
		containedTile,
		shouldHideTileMetadata,
		shouldHideTileTitle,
		nil,
		nil,
		titleTextLines
	)

	if not FFlagLuaAppCompositionAlways then
		local ref = React.useRef(0)
		React.useEffect(function()
			if not v5 and v6.numColumns ~= ref.current then
				ref.current = v6.numColumns

				if props.onItemsPerRowChanged then
					props.onItemsPerRowChanged(v6.numColumns)
				end
			end
		end, { v6.numColumns, props.onItemsPerRowChanged, ref, v5 })
	end

	local v8 = math.clamp(props.numRows, 0, 4)

	local items = React.useMemo(function()
		local result = {}

		for _ = 1, v7 * v8 do
			table.insert(result, v)
		end

		return result
	end, { v7, v8 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement

	if not v5 then
		collectionItemSize = nil
	end

	local title

	if v8 > 0 then
		title = props.title
	end

	local v9 = {
		collectionItemSize = collectionItemSize,
		title = title,
		headerComponent = props.headerComponent,
		containerRef = setState,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		hideHeaderButton = true,
		items = items,
		renderItem = renderItem,
		getItemHeight = getItemHeight,
		numColumns = 0,
		columnGap = 0,
		sideMargin = 0
	}
	local numColumns

	if not v5 then
		numColumns = v6.numColumns
	end

	v9.numColumns = numColumns
	local columnGap

	if not v5 then
		columnGap = v6.columnGap
	end

	v9.columnGap = columnGap
	local sideMargin

	if not v5 then
		sideMargin = v6.sideMargin
	end

	v9.sideMargin = sideMargin
	return createElement(fragment, nil, {
		GameGrid = createElement2(CollectionGrid, v9)
	})
end

return React.memo(PlaceholderGameGrid)
