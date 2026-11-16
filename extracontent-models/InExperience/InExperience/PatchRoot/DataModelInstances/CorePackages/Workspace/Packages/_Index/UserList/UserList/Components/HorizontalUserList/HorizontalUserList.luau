local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
require(UserList.Common.Types)
local Enums = require(UserList.Common.Enums)
local useCompactTileHeight = require(UserList.Common.useCompactTileHeight)
local Cryo = require(parent.Cryo)

local CollectionViews = require(parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useCollectionLayoutParams = CollectionViews.useCollectionLayoutParams
local usePageSideMargin = CollectionViews.usePageSideMargin
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize

local useEntities = require(UserList.Hooks.useEntities)
local useEntitySelectionHandler = require(UserList.Hooks.useEntitySelectionHandler)
local useRenderEntity = require(UserList.Hooks.useRenderEntity)

local SocialCommon = require(parent.SocialCommon)
local useIsWideMode = SocialCommon.Hooks.useIsWideMode

local defineFastFlag = game:DefineFastFlag("AdjustHorizontalUserListSizeForMobile", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagUserListRowSelectionOriginSource = require(UserList.Flags.FFlagUserListRowSelectionOriginSource)

local function HorizontalUserList(props)
	local v = FFlagLuaAppCompositionAlways or props.appCompositionEnabled
	local state, setState = React.useState(nil)
	local ref = React.useRef(nil)
	local scrollingFrameRef = props.scrollingFrameRef or ref

	local v2 = useIsWideMode()
	local collectionItemSize

	if defineFastFlag then
		if v2 then
			collectionItemSize = CollectionItemSize.Small
		else
			collectionItemSize = CollectionItemSize.Medium
		end
	else
		collectionItemSize = CollectionItemSize.Small
	end

	local sideMargin

	if not FFlagLuaAppCompositionAlways then
		sideMargin = usePageSideMargin(state)
	end

	if v then
		sideMargin = nil
	end

	local v3 = useCollectionLayoutParams(collectionItemSize, state, true, {
		sideMargin = sideMargin
	})

	local v4 = useCompactTileHeight()
	local getItemHeight = React.useCallback(function(_: number)
		return v4
	end, { v4 })

	local v5 = useEntities(props.entities)

	local onRowSelected = props.onRowSelected
	local v6

	if FFlagUserListRowSelectionOriginSource then
		v6 = props.rowSelectionConfig
	end

	local onActivated = useEntitySelectionHandler(onRowSelected, v6)

	local v7 = useRenderEntity({
		entitiesMap = v5.entitiesMap,
		onActivated = onActivated,
		renderRow = props.renderRow,
		layoutMode = Enums.LayoutMode.Horizontal,
		configs = props.listConfigs
	})

	local renderItem = React.useCallback(function(p: string, p2: number, udim: UDim2, _: number?)
		return v7(p, p2, udim), p
	end, { v7 })

	local items = React.useMemo(function()
		local ids = {}

		for _, entity in props.entities do
			table.insert(ids, entity.id)
		end

		return ids
	end, { props.entities })

	local join = Cryo.Dictionary.join
	local collectionCarouselConfigs = props.collectionCarouselConfigs or {}
	local title

	if props.header then
		title = props.header.title or nil
	end

	local onActivateHeader

	if props.header then
		onActivateHeader = props.header.onTitleActivated or nil
	end

	if not v then
		collectionItemSize = nil
	end

	local numColumns

	if not v then
		numColumns = v3.numColumns
	end

	local fractionalItemAmount

	if not v then
		fractionalItemAmount = v3.fractionalItemAmount
	end

	local columnGap

	if not v then
		columnGap = v3.columnGap
	end

	local sideMargin2

	if not v then
		sideMargin2 = v3.sideMargin
	end

	local v8 = join({}, collectionCarouselConfigs, {
		title = title,
		onActivateHeader = onActivateHeader,
		containerRef = setState,
		scrollingFrameRef = scrollingFrameRef,
		items = items,
		renderItem = renderItem,
		getItemHeight = getItemHeight,
		collectionItemSize = collectionItemSize,
		numColumns = numColumns,
		fractionalItemAmount = fractionalItemAmount,
		columnGap = columnGap,
		sideMargin = sideMargin2,
		maxItemsToShow = v3.maxTilesToShow,
		scrollingEnabledOverride = props.scrollEnabled
	})

	return React.createElement(View, {
		tag = "size-0-full auto-x row",
		LayoutOrder = props.layoutOrder
	}, {
		React.createElement(CollectionCarousel, v8)
	})
end

return HorizontalUserList
