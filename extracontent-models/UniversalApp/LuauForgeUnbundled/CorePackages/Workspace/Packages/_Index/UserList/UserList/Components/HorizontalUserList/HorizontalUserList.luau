local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").View
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local useCompactTileHeight = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/useCompactTileHeight")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Cryo")

local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/CollectionViews")
local collectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local usePageSideMargin = CollectionViews.usePageSideMargin
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize

local useEntities = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntities")
local useEntitySelectionHandler = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useEntitySelectionHandler")
local useRenderEntity = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Hooks/useRenderEntity")

local useIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SocialCommon").Hooks.useIsWideMode

local defineFastFlag = game:DefineFastFlag("AdjustHorizontalUserListSizeForMobile", false)
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagLuaAppCompositionAlways
local FFlagUserListRowSelectionOriginSource = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowSelectionOriginSource")

local function HorizontalUserList(props)
	local v5 = fFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref

	local v6 = useIsWideMode()
	local v7

	if defineFastFlag then
		v7 = if v6 then collectionItemSize.Small else collectionItemSize.Medium
	else
		v7 = collectionItemSize.Small
	end

	local v8 = if not fFlagLuaAppCompositionAlways then usePageSideMargin(state) else nil

	if v5 then
		v8 = nil
	end

	local v9 = useCollectionLayoutParams(v7, state, true, { sideMargin = v8 })

	local v10 = useCompactTileHeight()
	local v11 = React.useCallback(function(p2)
		return v10
	end, { v10 })

	local v12 = useEntities(props.entities)

	local onRowSelected = props.onRowSelected
	local v14 = if FFlagUserListRowSelectionOriginSource then props.rowSelectionConfig else nil
	local v15 = useEntitySelectionHandler(onRowSelected, v14)

	local v16 = useRenderEntity({
		entitiesMap = v12.entitiesMap,
		onActivated = v15,
		renderRow = props.renderRow,
		layoutMode = Enums.LayoutMode.Horizontal,
		configs = props.listConfigs
	})

	local v17 = React.useCallback(function(p2, p3, p4, p5)
		return v16(p2, p3, p4), p2
	end, { v16 })

	local v18 = React.useMemo(function()
		local ids = {}

		for k, entity in props.entities do
			table.insert(ids, entity.id)
		end

		return ids
	end, { props.entities })

	local join = Cryo.Dictionary.join
	local collectionCarouselConfigs = props.collectionCarouselConfigs or {}
	local v21 = if props.header then props.header.title or nil else nil
	local v22 = if props.header then props.header.onTitleActivated or nil else nil

	if not v5 then
		v7 = nil
	end

	local v23 = if not v5 then v9.numColumns else nil
	local v24 = if not v5 then v9.fractionalItemAmount else nil
	local v25 = if not v5 then v9.columnGap else nil
	local v26 = if not v5 then v9.sideMargin else nil
	local v27 = join({}, collectionCarouselConfigs, {
		title = v21,
		onActivateHeader = v22,
		containerRef = setState,
		scrollingFrameRef = scrollingFrameRef,
		items = v18,
		renderItem = v17,
		getItemHeight = v11,
		collectionItemSize = v7,
		numColumns = v23,
		fractionalItemAmount = v24,
		columnGap = v25,
		sideMargin = v26,
		maxItemsToShow = v9.maxTilesToShow,
		scrollingEnabledOverride = props.scrollEnabled
	})

	return React.createElement(view, {
		tag = "size-0-full auto-x row",
		LayoutOrder = props.layoutOrder
	}, {
		React.createElement(collectionCarousel, v27)
	})
end

return HorizontalUserList
