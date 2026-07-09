local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent
local React = require(GameCollectionsParent.React)
local GameTileConstants = require(GameCollectionsParent.GameTile).GameTileConstants
local Responsive = require(GameCollectionsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useAppPolicy = require(GameCollectionsParent.UniversalAppPolicy).useAppPolicy
local CollectionViews = require(GameCollectionsParent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid
local useCollectionLayout = CollectionViews.useCollectionLayout
local useGetGameTileHeight = require(GameCollections.useGetGameTileHeight)
local useGameCollectionLayoutParams = require(GameCollections.useGameCollectionLayoutParams)
local getGameTileCollectionItemSize = require(GameCollectionsParent.GameTile).getGameTileCollectionItemSize
local FFlagLuaAppCompositionAlways = require(GameCollectionsParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppSearchPlaceholderGrid = require(GameCollectionsParent.SharedFlags).FFlagLuaAppSearchPlaceholderGrid
local t1 = {}

local function renderItem(_, _, _, _) -- line: 42
	return nil, "placeholder"
end
local function PlaceholderGameGrid(t2: {[any]: any}) -- line: 49
	-- upvalues: useAppPolicy (copy), usePreferredInput (copy), Responsive (copy), FFlagLuaAppCompositionAlways (copy), getGameTileCollectionItemSize (copy), React (copy), useGameCollectionLayoutParams (copy), useCollectionLayout (copy), GameTileConstants (copy), useGetGameTileHeight (copy), t1 (copy), CollectionGrid (copy), FFlagLuaAppSearchPlaceholderGrid (copy), renderItem (copy)
	local v24 = useAppPolicy(function(p5) -- line: 51
		return p5.useGridPageLayout()
	end)
	local v25 = usePreferredInput()
	local v26 = t2.isHoverSupportEnabled and (v24 and v25 == Responsive.Input.Pointer)
	local v27 = t2.gameTileLayoutType or "Narrow"
	local v28 = FFlagLuaAppCompositionAlways or t2.appCompositionEnabled
	local v29 = if not v28 then nil else getGameTileCollectionItemSize(v27)
	local v30, v31 = React.useState(nil)

	React.useRef(v30).current = v30

	local v32 = if not v24 then {
		sideMargin = t2.sideMargin
	} else nil
	local v33 = useGameCollectionLayoutParams(v27, v30, false, v32)
	local itemsPerRow = useCollectionLayout(v29).itemsPerRow
	local v35 = if not v28 then v33.numColumns else itemsPerRow
	local v36 = t2.shouldHideTileTitle or false
	local v37 = t2.shouldHideTileMetadata or false
	local v38 = t2.containedTile or false
	local v39 = GameTileConstants.TileTextLines[v27] and GameTileConstants.TileTextLines[v27].titleTextLines
	local v40 = useGetGameTileHeight(v26, v27, v38, v37, v36, nil, nil, v39)

	if not FFlagLuaAppCompositionAlways then
		local v41 = React.useRef(0)

		React.useEffect(function() -- line: 102
			-- upvalues: v28 (copy), v33 (copy), v41 (copy), t2 (copy)
			if not v28 and v33.numColumns ~= v41.current then
				v41.current = v33.numColumns

				if t2.onItemsPerRowChanged then
					t2.onItemsPerRowChanged(v33.numColumns)
				end
			end
		end, {
			v33.numColumns,
			t2.onItemsPerRowChanged,
			v41,
			v28
		})
	end

	local v42 = math.clamp(t2.numRows, 0, 4)
	local v43 = React.useMemo(function() -- line: 125
		-- upvalues: v35 (copy), v42 (copy), t1 (copy)
		local t3 = {}

		for _ = 1, v35 * v42 do
			table.insert(t3, t1)
		end

		return t3
	end, {
		v35,
		v42
	})

	return React.createElement(React.Fragment, nil, {
		GameGrid = React.createElement(CollectionGrid, {
			hideHeaderButton = true,
			collectionItemSize = if not v28 then nil else v29,
			title = if not (v42 > 0) then nil else t2.title,
			headerComponent = if not FFlagLuaAppSearchPlaceholderGrid then nil else t2.headerComponent,
			containerRef = v31,
			verticalScrollingFrameRef = t2.verticalScrollingFrameRef,
			items = v43,
			renderItem = renderItem,
			getItemHeight = v40,
			numColumns = if not v28 then v33.numColumns else nil,
			columnGap = if not v28 then v33.columnGap else nil,
			sideMargin = if not v28 then v33.sideMargin else nil
		})
	})
end

return React.memo(PlaceholderGameGrid)
