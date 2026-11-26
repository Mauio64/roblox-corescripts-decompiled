local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local gameTileConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").GameTileConstants
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UniversalAppPolicy").useAppPolicy

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/CollectionViews")
local collectionGrid = CollectionViews.CollectionGrid
local useCollectionLayout = CollectionViews.useCollectionLayout
local useGetGameTileHeight = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGetGameTileHeight")
local useGameCollectionLayoutParams = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameCollectionLayoutParams")
local getGameTileCollectionItemSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").getGameTileCollectionItemSize
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppCompositionAlways

local v5 = {}

local function renderItem(p2, p3, p4, p5): (nil, string)
	return nil, "placeholder"
end

local function PlaceholderGameGrid(props)
	local v6 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local v7 = usePreferredInput()
	local v8 = props.isHoverSupportEnabled and v6 and v7 == Responsive.Input.Pointer

	local gameTileLayoutType = props.gameTileLayoutType or "Narrow"
	local v9 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled

	local v10 = if v9 then getGameTileCollectionItemSize(gameTileLayoutType) else nil

	local state, setState = React.useState(nil)
	local useRef = React.useRef(state)
	useRef.current = state

	local v12 = useGameCollectionLayoutParams(
		gameTileLayoutType,
		state,
		false,
		not v6 and { sideMargin = props.sideMargin } or nil
	)

	local v13 = useCollectionLayout(v10).itemsPerRow

	if not v9 then
		v13 = v12.numColumns
	end

	local shouldHideTileTitle = props.shouldHideTileTitle or false
	local shouldHideTileMetadata = props.shouldHideTileMetadata or false
	local containedTile = props.containedTile or false
	local titleTextLines = gameTileConstants.TileTextLines[gameTileLayoutType]
		and gameTileConstants.TileTextLines[gameTileLayoutType].titleTextLines

	local v14 = useGetGameTileHeight(
		v8,
		gameTileLayoutType,
		containedTile,
		shouldHideTileMetadata,
		shouldHideTileTitle,
		nil,
		nil,
		titleTextLines
	)

	if not fFlagLuaAppCompositionAlways then
		local ref = React.useRef(0)
		React.useEffect(function()
			if not v9 and v12.numColumns ~= ref.current then
				ref.current = v12.numColumns

				if props.onItemsPerRowChanged then
					props.onItemsPerRowChanged(v12.numColumns)
				end
			end
		end, { v12.numColumns, props.onItemsPerRowChanged, ref, v9 })
	end

	local v15 = math.clamp(props.numRows, 0, 4)

	local v16 = React.useMemo(function()
		local result = {}

		for i = 1, v13 * v15 do
			table.insert(result, v5)
		end

		return result
	end, { v13, v15 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement

	if not v9 then
		v10 = nil
	end

	local v21 = if v15 > 0 then props.title else nil
	local v20 = {
		collectionItemSize = v10,
		title = v21,
		headerComponent = props.headerComponent,
		containerRef = setState,
		verticalScrollingFrameRef = props.verticalScrollingFrameRef,
		hideHeaderButton = true,
		items = v16,
		renderItem = renderItem,
		getItemHeight = v14,
		numColumns = 0,
		columnGap = 0,
		sideMargin = 0
	}

	local v22 = if not v9 then v12.numColumns else nil
	v20.numColumns = v22
	local v23 = if not v9 then v12.columnGap else nil
	v20.columnGap = v23
	local v24 = if not v9 then v12.sideMargin else nil
	v20.sideMargin = v24
	return createElement(fragment, nil, {
		GameGrid = createElement2(collectionGrid, v20)
	})
end

return React.memo(PlaceholderGameGrid)
