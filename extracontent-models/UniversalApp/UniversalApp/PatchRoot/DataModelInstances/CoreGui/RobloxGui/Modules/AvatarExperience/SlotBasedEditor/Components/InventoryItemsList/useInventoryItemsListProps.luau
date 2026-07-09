local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.Hooks.useAvatarRoute
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local InventoryFilters = AvatarExperienceSlotBasedEditor.Enums.InventoryFilters
local InventoryItemType = AvatarExperienceSlotBasedEditor.Enums.InventoryItemType
local useSlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.useSlotBasedEditorContext
local useAvatarEditorStores = AvatarExperienceSlotBasedEditor.Context.useAvatarEditorStores
local useAvatarSaveContext = require(CorePackages.Workspace.Packages.AvatarExperienceSave).Context.useAvatarSaveContext
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)
local GetUserInventoryV2 = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUserInventoryV2)
local GetUprankedItems = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetUprankedItems)
local Constants2 = require(Modules.LuaApp.Constants)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local SendShopForMoreAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendShopForMoreAnalytics)
local selectOwnedItemIdToIsWearing = require(Modules.AvatarExperience.AvatarEditor.Selectors.selectOwnedItemIdToIsWearing)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local FFlagAXAvatarEditorStoresContext = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext

require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)

local InventoryItemCardContainer = require(script.Parent.Parent.InventoryItemCard.InventoryItemCardContainer)
local CatalogItemCardContainer = require(Modules.AvatarExperience.Catalog.Components.ItemsList.CatalogItemCardContainer)

require(script.Parent.InventoryItemsList)

local useInventoryItems = require(script.Parent.useInventoryItems)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local CatalogItemCardStatusIconTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum
local useAdaptiveScrolling = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useAdaptiveScrolling
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps
local FIntAXDefaultInventoryPageSize = AvatarExperienceFlags.FIntAXDefaultInventoryPageSize
local FFlagAXUprankBundles = require(Modules.AvatarExperience.Flags.FFlagAXUprankBundles)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local FFlagAXRefetchInventoryOnAssetGrant = AvatarExperienceFlags.FFlagAXRefetchInventoryOnAssetGrant
local useRefetchStaleInventoryCategory = require(script.Parent.Parent.Parent.Hooks.useRefetchStaleInventoryCategory)

local function selectCurrentOwnedItemIdToIsWearing(p1) -- line: 99
	-- upvalues: Utils (copy), selectOwnedItemIdToIsWearing (copy)
	local v55 = Utils.selectAssetTypeKey(p1)

	return selectOwnedItemIdToIsWearing(p1, v55)
end
local function selectAnalyticsMetadata(p2) -- line: 104
	return p2.AvatarExperience.AnalyticsMetadata
end
local function useInventoryItemsListProps(t1: {[any]: any}?) -- line: 108
	-- upvalues: React (copy), RoactGamepad (copy), useDispatch (copy), useNavigation (copy), useAvatarRoute (copy), useRoactService (copy), RoactNetworking (copy), Analytics (copy), useAvatarSaveContext (copy), SignalsReact (copy), useAdaptiveScrolling (copy), FFlagAXAvatarEditorStoresContext (copy), useAvatarEditorStores (copy), useSlotBasedEditorContext (copy), Constants2 (copy), useAppPolicy (copy), Signal (copy), useSelector (copy), Utils2 (copy), FFlagAXAddInventoryItemsListProps (copy), selectCurrentOwnedItemIdToIsWearing (copy), selectAnalyticsMetadata (copy), PerformFetch (copy), FFlagAXInventoryDurablesExpiredFilter (copy), useInventoryItems (copy), useSignalState (copy), FFlagAXUprankBundles (copy), GetUprankedItems (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), GetUserInventoryV2 (copy), FFlagAXTTIEditorEnableMilestones (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), useRefetchStaleInventoryCategory (copy), InventoryFilters (copy), InventoryItemType (copy), Constants3 (copy), CatalogItemCardContainer (copy), FIntAXDefaultInventoryPageSize (copy), CatalogConstants (copy), CatalogItemCardStatusIconTypeEnum (copy), InventoryItemCardContainer (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), SendShopForMoreAnalytics (copy), Constants (copy), RetrievalStatus (copy)
	local v58 = React.useRef(nil)
	local v59 = RoactGamepad.useRefCache()
	local v60 = useDispatch()
	local v61 = useNavigation()
	local v62 = useAvatarRoute()
	local v63 = useRoactService(RoactNetworking)
	local v64 = useRoactService(Analytics)
	local v65 = useAvatarSaveContext()
	local v66 = SignalsReact.useSignalState(v65.getLastSuccessfullySavedStateSignal)
	local v67 = useAdaptiveScrolling()
	local v68 = not v67 or (not v67.scrollingEnabledBinding or v67.scrollingEnabledBinding)
	local v69 = nil
	local v70 = nil

	if FFlagAXAvatarEditorStoresContext then
		v69 = useAvatarEditorStores()
	else
		v70 = useSlotBasedEditorContext()
		assert(v70, "InventoryItemsList must be used within a SlotBasedEditorContextProvider")
	end

	local key = v62.current.key
	local v72 = Constants2.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))
	local v73 = useAppPolicy(function(p3) -- line: 137
		return p3.getEnableContinuousLoad()
	end)
	local v74 = React.useMemo(function() -- line: 141
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local u75 = useSelector(Utils2.getAvatarEditorCategoryInfoFromState)
	local u76 = useSelector(Utils2.getAvatarEditorSubcategoryFilterFromState)

	if FFlagAXAddInventoryItemsListProps then
		u75 = t1.categoryInfo
		u76 = t1.subcategoryFilter
	end

	local v77 = u76 or u75
	local v78 = useSelector(selectCurrentOwnedItemIdToIsWearing)
	local v79 = useSelector(selectAnalyticsMetadata)
	local v80 = React.useCallback(function(p4) -- line: 156
		-- upvalues: PerformFetch (copy), v77 (copy)
		return PerformFetch.GetStatus(p4, v77.SearchUuid)
	end, { v77.SearchUuid })
	local v81 = useSelector(v80)
	local v82 = if not FFlagAXAvatarEditorStoresContext then v70.categoryInventoryStores[v77.NavigationKey] else v69.categoryInventoryStores[v77.NavigationKey]
	local v83 = if not FFlagAXInventoryDurablesExpiredFilter then nil else if not FFlagAXAvatarEditorStoresContext then v70.sortAndFiltersStore else v69.sortAndFiltersStore
	local v84 = useInventoryItems(v82, v77, if not FFlagAXInventoryDurablesExpiredFilter then if not FFlagAXAvatarEditorStoresContext then v70.sortAndFiltersStore else v69.sortAndFiltersStore else v83)
	local v85 = useSignalState(v82.getHasReachedLastPage)
	local v86 = useSignalState(v82.getSearchUuid)
	local v87 = React.useCallback(function(p5) -- line: 183
		-- upvalues: v74 (copy), t1 (copy), v67 (copy)
		v74:fire()

		if t1 and t1.onContentScroll then
			t1.onContentScroll(p5)
		end

		if v67 and v67.onCanvasYChanged then
			v67.onCanvasYChanged(p5.CanvasPosition.Y)
		end
	end, {
		v67,
		t1
	})

	if FFlagAXUprankBundles() then
		React.useEffect(function() -- line: 197
			-- upvalues: v60 (copy), GetUprankedItems (copy), v63 (copy)
			v60(GetUprankedItems(v63))
		end, {
			v66,
			v60
		})
	end

	local v88 = if not GetFFlagAXEnableInventorySortsAndFilters() then React.useCallback(function() -- line: 222
		-- upvalues: v82 (copy), v60 (copy), GetUserInventoryV2 (copy), v63 (copy), v77 (copy), FFlagAXTTIEditorEnableMilestones (copy)
		if not v82.getHasReachedLastPage(false) then
			v60(GetUserInventoryV2(v63, v77, nil, v82, nil, not not FFlagAXTTIEditorEnableMilestones or nil))
		end
	end, {
		v60,
		v63,
		v77,
		v82
	}) else React.useCallback(function() -- line: 204
		-- upvalues: v82 (copy), v60 (copy), GetUserInventoryV2 (copy), v63 (copy), v77 (copy), FFlagAXAddInventoryItemsListProps (copy), t1 (copy), v83 (copy), FFlagAXTTIEditorEnableMilestones (copy)
		if not v82.getHasReachedLastPage(false) then
			v60(GetUserInventoryV2(v63, v77, nil, v82, if not FFlagAXAddInventoryItemsListProps or (not t1 or not t1.disableSortsAndFilters) then v83 else nil, not not FFlagAXTTIEditorEnableMilestones or nil))
		end
	end, {
		v60,
		v63,
		v77,
		v82,
		v83
	})

	if FFlagAXRefetchInventoryOnAssetGrant then
		useRefetchStaleInventoryCategory(v77.SearchUuid, v82, v88)
	end

	local v89 = if not FFlagAXInventoryDurablesExpiredFilter then nil else useSignalState(v83.getSortAndFilters)
	local v90 = if not FFlagAXInventoryDurablesExpiredFilter then nil else v89.filter == InventoryFilters.Expired
	local v91 = React.useCallback(function() -- line: 313
		-- upvalues: v60 (copy), SendShopForMoreAnalytics (copy), v64 (copy)
		v60(SendShopForMoreAnalytics(v64))
	end, {
		v60,
		v64
	})
	local v92 = React.useCallback(function() -- line: 317
		-- upvalues: key (copy), v61 (copy)
		return key == v61.state.key
	end, {
		key,
		v61.state.key
	})
	local v93 = ((if not FFlagAXAddInventoryItemsListProps then u75.RecommendationsType and (u75.RecommendationsType ~= Constants.RecommendationsType.None and v85) else t1 and (t1.showRecommendedItems and (u75.RecommendationsType and (u75.RecommendationsType ~= Constants.RecommendationsType.None and v85))))) or false
	local v94 = not v73 and (not v85 and v81 ~= RetrievalStatus.Fetching)
	local v95 = if not v73 or (v85 or v81 == RetrievalStatus.Fetching) then nil else v88
	local v96 = if not FFlagAXInventoryDurablesExpiredFilter or (not v90 or (not v84 or (not (#v84 > 0) or v84[1].itemId == nil))) then nil else Constants3.ItemTileType.CatalogItemTile

	return {
		items = v84,
		scrollingEnabled = v68,
		showLoadMoreButton = v94,
		showRecommendedItems = v93,
		fetchStatus = v81,
		impressionsTag = v72,
		searchUuid = v86,
		categoryInfo = u75,
		subcategoryFilter = u76,
		analyticsMetadata = v79,
		requestImpressionsSignal = v74,
		itemDetailsPeekViewRefs = v59,
		fetchUserInventory = v88,
		sendShopForMoreAnalytics = v91,
		onCanvasPositionChanged = v87,
		renderItem = function(p6) -- line: 254
			-- upvalues: FFlagAXAddInventoryItemsListProps (copy), t1 (copy), v78 (copy), v58 (copy), v59 (copy), v72 (copy), FFlagAXInventoryDurablesExpiredFilter (copy), v90 (copy), InventoryItemType (copy), Constants3 (copy), React (copy), CatalogItemCardContainer (copy), FIntAXDefaultInventoryPageSize (copy), CatalogConstants (copy), u75 (ref), u76 (ref), CatalogItemCardStatusIconTypeEnum (copy), InventoryItemCardContainer (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy)
			if FFlagAXAddInventoryItemsListProps and (t1 and t1.renderItem) then
				return t1.renderItem(p6, {
					ownedItemIdToIsWearing = v78,
					gridRef = v58,
					itemDetailsPeekViewRefs = v59,
					impressionsTag = v72
				})
			end

			if FFlagAXInventoryDurablesExpiredFilter and v90 and p6.item.itemId then
				local v101 = if not p6.gridInformation then nil else {
					gridPositionRow = p6.gridInformation.row,
					gridPositionColumn = p6.gridInformation.column
				}
				local v102 = if p6.item.inventoryItemType ~= InventoryItemType.Asset then Constants3.ItemType.Bundle else Constants3.ItemType.Asset

				return React.createElement(CatalogItemCardContainer, {
					impressionsSchema = "defaultItem",
					isTitleVisible = true,
					isPriceVisible = true,
					isCreatorNameVisible = true,
					isOrganic = true,
					itemId = p6.item.itemId,
					itemType = v102,
					index = p6.index,
					analyticsItemCountPerPage = FIntAXDefaultInventoryPageSize,
					analyticsContext = CatalogConstants.AnalyticsContext.AvatarEditorExpiredItem,
					itemDetailsPeekViewRefs = v59,
					resultsListRef = v58,
					gridInformation = v101,
					impressionsTag = v72,
					impressionsId = p6.item.itemId,
					impressionsCategory = u75.Name,
					impressionsSubcategory = if not u76 then nil else u76.Name,
					itemStatusOverride = {
						type = "icon",
						iconType = CatalogItemCardStatusIconTypeEnum.Durable
					}
				})
			end

			return React.createElement(InventoryItemCardContainer, {
				impressionsSchema = "defaultItem",
				inventoryItemType = p6.item.inventoryItemType,
				itemId = p6.item.itemId,
				isSelected = p6.item.itemId ~= nil and v78[p6.item.itemId],
				resultsListRef = v58,
				itemDetailsPeekViewRefs = v59,
				gridInformation = p6.gridInformation,
				impressionsTag = v72,
				hideName = not u75.ShowName or false,
				availabilityStatus = if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else p6.item.availabilityStatus
			})
		end,
		impressionsPageFilter = v92,
		onListEndReached = v95,
		itemTileType = if not FFlagAXInventoryDurablesExpiredFilter then nil else v96
	}
end

return useInventoryItemsListProps
