local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local View = require(UserListParent.Foundation).View

require(UserList.Common.Types)

local Enums = require(UserList.Common.Enums)
local useCompactTileHeight = require(UserList.Common.useCompactTileHeight)
local Cryo = require(UserListParent.Cryo)
local CollectionViews = require(UserListParent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local usePageSideMargin = CollectionViews.usePageSideMargin
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local useEntities = require(UserList.Hooks.useEntities)
local useEntitySelectionHandler = require(UserList.Hooks.useEntitySelectionHandler)
local useRenderEntity = require(UserList.Hooks.useRenderEntity)
local useIsWideMode = require(UserListParent.SocialCommon).Hooks.useIsWideMode
local v17 = game:DefineFastFlag("AdjustHorizontalUserListSizeForMobile", false)
local FFlagLuaAppCompositionAlways = require(UserListParent.SharedFlags).FFlagLuaAppCompositionAlways

local function HorizontalUserList(t1: {[any]: any}) -- line: 50
	-- upvalues: FFlagLuaAppCompositionAlways (copy), React (copy), useIsWideMode (copy), v17 (copy), CollectionItemSize (copy), usePageSideMargin (copy), useCollectionLayoutParams (copy), useCompactTileHeight (copy), useEntities (copy), useEntitySelectionHandler (copy), useRenderEntity (copy), Enums (copy), Cryo (copy), View (copy), CollectionCarousel (copy)
	local v21 = FFlagLuaAppCompositionAlways or t1.appCompositionEnabled
	local v22, v23 = React.useState(nil)
	local v24 = React.useRef(nil)
	local v25 = t1.scrollingFrameRef or v24
	local v26 = useIsWideMode()
	local v27 = if not v17 then CollectionItemSize.Small else if not v26 then CollectionItemSize.Medium else CollectionItemSize.Small
	local v28 = if FFlagLuaAppCompositionAlways then nil else usePageSideMargin(v22)
	local v29 = useCollectionLayoutParams(v27, v22, true, {
		sideMargin = if not v21 then v28 else nil
	})
	local v30 = useCompactTileHeight()
	local v31 = React.useCallback(function(_: number) -- line: 67
		-- upvalues: v30 (copy)
		return v30
	end, { v30 })
	local v32 = useEntities(t1.entities)
	local v33 = useEntitySelectionHandler(t1.onRowSelected)
	local v34 = useRenderEntity({
		entitiesMap = v32.entitiesMap,
		onActivated = v33,
		renderRow = t1.renderRow,
		layoutMode = Enums.LayoutMode.Horizontal,
		configs = t1.listConfigs
	})
	local v35 = React.useCallback(function(s1: string, n2: number, uDim2: UDim2, _: number?) -- line: 82
		-- upvalues: v34 (copy)
		return v34(s1, n2, uDim2), s1
	end, { v34 })
	local v36 = React.useMemo(function() -- line: 89
		-- upvalues: t1 (copy)
		local t2 = {}

		for _, v45 in t1.entities do
			table.insert(t2, v45.id)
		end

		return t2
	end, { t1.entities })
	local v37 = Cryo.Dictionary.join({}, t1.collectionCarouselConfigs or {}, {
		title = t1.header and t1.header.title or nil,
		onActivateHeader = t1.header and t1.header.onTitleActivated or nil,
		containerRef = v23,
		scrollingFrameRef = v25,
		items = v36,
		renderItem = v35,
		getItemHeight = v31,
		collectionItemSize = if not v21 then nil else v27,
		numColumns = if not v21 then v29.numColumns else nil,
		fractionalItemAmount = if not v21 then v29.fractionalItemAmount else nil,
		columnGap = if not v21 then v29.columnGap else nil,
		sideMargin = if not v21 then v29.sideMargin else nil,
		maxItemsToShow = v29.maxTilesToShow,
		scrollingEnabledOverride = t1.scrollEnabled
	})

	return React.createElement(View, {
		tag = "size-0-full auto-x row",
		LayoutOrder = t1.layoutOrder
	}, { React.createElement(CollectionCarousel, v37) })
end

return HorizontalUserList
