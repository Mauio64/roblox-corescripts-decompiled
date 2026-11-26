local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SignalsReact2 = require(CorePackages.Packages.SignalsReact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local module = require("@luauforge/bundled/fCn")
local inventoryFilters = module.Enums.InventoryFilters
local inventoryItemType = module.Enums.InventoryItemType
local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module.Context.useAvatarEditorStores
local useAvatarSaveContext = require("@luauforge/bundled/gKz").Context.useAvatarSaveContext

local recommendationsType = require("@luauforge/bundled/dPt").Enums.RecommendationsType
local module2 = require("@luauforge/bundled/gJz")
local module3 = require("@luauforge/bundled/fCI")
local module4 = require("@luauforge/bundled/fCe")
local module5 = require("@luauforge/deferred/haS")
local module6 = require("@luauforge/deferred/hel")
local module7 = require("@luauforge/bundled/dzD")
local module8 = require("@luauforge/bundled/egx")
local module9 = require("@luauforge/deferred/hcG")

local module10 = require("@luauforge/deferred/hcF")
local module11 = require("@luauforge/bundled/dAB")
local module12 = require("@luauforge/bundled/eie")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local module14 = require("@luauforge/deferred/haU")

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext
require("@luauforge/deferred/gPt")

local module15 = require("@luauforge/deferred/hem")
local module16 = require("@luauforge/deferred/hbA")
require("@luauforge/deferred/hcI")
require("@luauforge/deferred/heh")
local module17 = require("@luauforge/deferred/heq")
local module18 = require("@luauforge/deferred/hes")
local module19 = require("@luauforge/bundled/dPU")
local module20 = require("@luauforge/bundled/dPN")

local catalogItemCardStatusIconTypeEnum = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

local useAdaptiveScrolling = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useAdaptiveScrolling
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps
local fIntAXDefaultInventoryPageSize = AvatarExperienceFlags.FIntAXDefaultInventoryPageSize
local module22 = require("@luauforge/bundled/dSO")
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = AvatarExperienceFlags.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled

local fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement = AvatarExperienceFlags.FFlagAXBackgroundsHideCreateTileWithoutAiEntitlement
local module23 = require("@luauforge/deferred/hbf")
local module24 = require("@luauforge/deferred/hcs")
local module25 = require("@luauforge/deferred/haR")

local module26 = require("@luauforge/deferred/haV")

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/gLF").EditorInventoryTTIMilestoneManager
local module27 = require("@luauforge/deferred/hcO")

local frozen = table.freeze({
	module27.BackgroundsPlusAnalytics.reportVisibleUpsellImpression,
	module27.BackgroundGenerationAnalytics.reportVisibleCreateTileImpression
})

local function selectCurrentOwnedItemIdToIsWearing(p2)
	return module10(p2, (module3.selectAssetTypeKey(p2)))
end

local function selectAnalyticsMetadata(p2)
	return p2.AvatarExperience.AnalyticsMetadata
end

local function useInventoryItemsListProps(data, showExclusiveWithPlusSection, p2)
	local ref = React.useRef(nil)
	local v5 = RoactGamepad.useRefCache()
	local v6 = useDispatch()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()
	local v9 = module12(module8)
	local v10 = module12(module2)
	local v11 = useAvatarSaveContext()

	local v12 = SignalsReact2.useSignalState(v11.getLastSuccessfullySavedStateSignal)

	local v13 = useAdaptiveScrolling()
	local v14 = not (v13 and v13.scrollingEnabledBinding) or v13.scrollingEnabledBinding

	local v15 = nil
	local v16 = nil

	if fFlagAXAvatarEditorStoresContext then
		v15 = useAvatarEditorStores()
	else
		v16 = useSlotBasedEditorContext()
		assert(v16, "InventoryItemsList must be used within a SlotBasedEditorContextProvider")
	end

	local key = v8.current.key
	local v17 = module7.ImpressionsEvents.AvatarItems .. (not key and "" or string.gsub(key, "[-{}]", ""))

	local v18 = useAppPolicy(function(p3)
		return p3.getEnableContinuousLoad()
	end)

	local v19 = React.useMemo(function()
		return signal.new()
	end, {})

	local v20 = useSelector(module4.getAvatarEditorCategoryInfoFromState)
	local v21 = useSelector(module4.getAvatarEditorSubcategoryFilterFromState)

	if fFlagAXAddInventoryItemsListProps then
		v20 = data.categoryInfo
		v21 = data.subcategoryFilter
	end

	local v22 = v21 or v20

	local v23 = if module23 then module24(v20, v21) else nil

	local v24 = useSelector(selectCurrentOwnedItemIdToIsWearing)
	local v25 = useSelector(selectAnalyticsMetadata)

	local v27 = useSelector((React.useCallback(function(p3)
		return performFetch.GetStatus(p3, v22.SearchUuid)
	end, { v22.SearchUuid })))
	local v28

	if fFlagAXAvatarEditorStoresContext then
		v28 = v15.categoryInventoryStores[v22.NavigationKey]
	else
		v28 = v16.categoryInventoryStores[v22.NavigationKey]
	end

	local sortAndFiltersStore

	if fFlagAXInventoryDurablesExpiredFilter then
		if fFlagAXAvatarEditorStoresContext then
			sortAndFiltersStore = v15.sortAndFiltersStore
		else
			sortAndFiltersStore = v16.sortAndFiltersStore
		end
	else
		sortAndFiltersStore = nil
	end

	local v29 = nil

	if fFlagAXAvatarEditorStoresContext and fFlagAXEditorEnableThumbnailLatencyStore then
		local thumbnailLatencyStores = v15.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v29 = thumbnailLatencyStores[v22.NavigationKey]
		end
	elseif fFlagAXEditorEnableThumbnailLatencyStore and not fFlagAXAvatarEditorStoresContext and v16 then
		local thumbnailLatencyStores = v16.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v29 = thumbnailLatencyStores[v22.NavigationKey]
		end
	end

	if fFlagAXEditorEnableThumbnailLatencyStore then
		module26(v29)
	end

	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		showExclusiveWithPlusSection = nil
	end

	if not fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then
		p2 = nil
	end

	local v31

	if fFlagAXInventoryDurablesExpiredFilter then
		v31 = sortAndFiltersStore
	elseif fFlagAXAvatarEditorStoresContext then
		v31 = v15.sortAndFiltersStore
	else
		v31 = v16.sortAndFiltersStore
	end

	local v32 = module17(v28, v22, v31, showExclusiveWithPlusSection, p2)

	if fFlagAXBackgroundGeneration then
		local v33 = useSelector(function(p3)
			return p3.AvatarExperience.Common.AssetInfos
		end)

		local v34 = React.useMemo(function()
			return module18.getDetailsFetchKeyForCategory(v22.NavigationKey, v32, v33)
		end, { v32, v33, v22.NavigationKey })
		local v35 = React.useMemo(function()
			return module18.getItemsFromDetailsFetchKey(v34)
		end, { v34 })

		React.useEffect(function()
			module18.dispatchDetailsFetchIfNeeded(v6, v9, v35)
		end, { v35, v6, v9 })
	end

	local v33 = useSignalState(v28.getHasReachedLastPage)
	local v34 = useSignalState(v28.getSearchUuid)

	local v35 = React.useCallback(function(p3)
		v19:fire()

		if data and data.onContentScroll then
			data.onContentScroll(p3)
		end

		if v13 and v13.onCanvasYChanged then
			v13.onCanvasYChanged(p3.CanvasPosition.Y)
		end
	end, { v13, data })

	if module22() then
		React.useEffect(function()
			v6(module6(v9))
		end, { v12, v6 })
	end

	local v36

	if module14() then
		local useCallback = React.useCallback
		local function fn()
			if not v28.getHasReachedLastPage(false) then
				local v43 = if not (fFlagAXAddInventoryItemsListProps and data and data.disableSortsAndFilters) then sortAndFiltersStore else nil
				v6(module5(v9, v22, nil, v28, v43, fFlagAXTTIEditorEnableMilestones and true or nil))

				if fFlagAXTTIEditorEnableMilestones and editorInventoryTTIMilestoneManager then
					local v44 = not (v20.Subcategory == nil) and v20.Category ~= nil

					local name = if v44 then module4.getAvatarEditorCategoryInfo(v20.Category, nil).Name else v20.Name
					local updateMetadata = editorInventoryTTIMilestoneManager.updateMetadata

					local v46 = if v44 then v20.Name else nil
					updateMetadata({
						category = name,
						subcategory = v46,
						page = v8.current.name,
						opaquePage = v8.opaque.name
					})
				end
			end
		end

		local v38 = if fFlagAXEditorEnableThumbnailLatencyStore then v29 else nil
		local v39 = if fFlagAXEditorEnableThumbnailLatencyStore then data else nil
		local name = if fFlagAXTTIEditorEnableMilestones then v20.Name else nil
		local category = if fFlagAXTTIEditorEnableMilestones then v20.Category else nil
		local v40 = if fFlagAXTTIEditorEnableMilestones then v20.Subcategory else nil
		v36 = useCallback(fn, {
			v6,
			v9,
			v22,
			v28,
			sortAndFiltersStore,
			v38,
			v39,
			name,
			category,
			v40
		})
	else
		local useCallback = React.useCallback
		local function fn()
			if not v28.getHasReachedLastPage(false) then
				v6(module5(v9, v22, nil, v28, nil, fFlagAXTTIEditorEnableMilestones and true or nil))

				if fFlagAXTTIEditorEnableMilestones and editorInventoryTTIMilestoneManager then
					local v37 = not (v20.Subcategory == nil) and v20.Category ~= nil

					local name = if v37 then module4.getAvatarEditorCategoryInfo(v20.Category, nil).Name else v20.Name
					local updateMetadata = editorInventoryTTIMilestoneManager.updateMetadata

					local v39 = if v37 then v20.Name else nil
					updateMetadata({
						category = name,
						subcategory = v39,
						page = v8.current.name,
						opaquePage = v8.opaque.name
					})
				end
			end
		end

		local v38 = if fFlagAXEditorEnableThumbnailLatencyStore then v29 else nil
		local name = if fFlagAXTTIEditorEnableMilestones then v20.Name else nil
		local category = if fFlagAXTTIEditorEnableMilestones then v20.Category else nil
		local v39 = if fFlagAXTTIEditorEnableMilestones then v20.Subcategory else nil
		v36 = useCallback(fn, { v6, v9, v22, v28, v38, name, category, v39 })
	end

	if fFlagAXRefetchInventoryOnUpdate then
		module25(v22.SearchUuid, v28, v36)
	end

	local v37

	if fFlagAXInventoryDurablesExpiredFilter then
		v37 = useSignalState(sortAndFiltersStore.getSortAndFilters)
	end

	local v38

	if fFlagAXInventoryDurablesExpiredFilter then
		v38 = v37.filter == inventoryFilters.Expired
	else
		v38 = nil
	end

	local ref2 = if fFlagAXEditorEnableThumbnailLatencyStore then React.useRef({}) else nil
	local v39

	if fFlagAXEditorEnableThumbnailLatencyStore and ref2 then
		v39 = React.useCallback(function(p3)
			if v29 == nil then
				return nil
			end

			local current = ref2.current
			local v40 = current[p3]

			if v40 then
				return v40
			end

			local v41 = v29
			local function fn(p4)
				v41.setThumbnailLoaded(p3)
			end
			current[p3] = fn
			return fn
		end, { v29 })
	else
		v39 = nil
	end

	local function renderItem(props, p3)
		if fFlagAXAddInventoryItemsListProps and data and data.renderItem then
			return data.renderItem(props, {
				ownedItemIdToIsWearing = v24,
				gridRef = ref,
				itemDetailsPeekViewRefs = v5,
				impressionsTag = v17
			})
		end

		if fFlagAXInventoryDurablesExpiredFilter and v38 and props.item.itemId then
			local v40 = props.gridInformation
				and {
					gridPositionRow = props.gridInformation.row,
					gridPositionColumn = props.gridInformation.column
				}
				or nil
			local v41

			if props.item.inventoryItemType == inventoryItemType.Asset then
				v41 = module20.ItemType.Asset
			else
				v41 = module20.ItemType.Bundle
			end

			local createElement = React.createElement
			local v43 = {
				itemId = props.item.itemId,
				itemType = v41,
				index = props.index,
				analyticsItemCountPerPage = fIntAXDefaultInventoryPageSize,
				analyticsContext = module19.AnalyticsContext.AvatarEditorExpiredItem,
				itemDetailsPeekViewRefs = v5,
				resultsListRef = ref,
				gridInformation = v40,
				impressionsTag = v17,
				impressionsSchema = "defaultItem",
				impressionsId = props.item.itemId,
				impressionsCategory = v20.Name,
				impressionsSubcategory = 0,
				isTitleVisible = true,
				isPriceVisible = true,
				itemStatusOverride = 0,
				isCreatorNameVisible = true,
				isOrganic = true
			}
			local v44 = if v21 then v21.Name else nil
			v43.impressionsSubcategory = v44

			v43.itemStatusOverride = {
				type = "icon",
				iconType = catalogItemCardStatusIconTypeEnum.Durable
			}
			return createElement(module16, v43)
		else
			local itemId = props.item.itemId

			if fFlagAXEditorEnableThumbnailLatencyStore and v29 and itemId then
				v29.appendThumbnail(itemId)
			end

			local createElement = React.createElement
			local v41 = {
				inventoryItemType = props.item.inventoryItemType,
				itemId = itemId,
				isSelected = itemId ~= nil and v24[itemId],
				resultsListRef = ref,
				itemDetailsPeekViewRefs = v5,
				gridInformation = props.gridInformation,
				impressionsTag = v17,
				hideName = not v20.ShowName,
				impressionsSchema = "defaultItem",
				unifiedCategoryFields = if module23 then v23 else nil,
				availabilityStatus = props.item.availabilityStatus,
				onThumbnailLoaded = 0,
				onPlusExclusiveActivated = 0,
				plus = 0
			}

			local v44 = if fFlagAXEditorEnableThumbnailLatencyStore and itemId and v39 then v39(itemId) else nil
			v41.onThumbnailLoaded = v44

			local v45 = if fFlagAXBackgroundGeneration and p3 then p3.onPlusExclusiveActivated else nil
			v41.onPlusExclusiveActivated = v45

			local v46 = if fFlagAXBackgroundGenerationAnalytics and fFlagAXBackgroundGeneration and p3 then p3.plus else nil
			v41.plus = v46
			return createElement(module15, v41)
		end
	end

	local v40 = React.useCallback(function()
		v6(module9(v10))
	end, { v6, v10 })

	local v41 = React.useCallback(function(): boolean
		return key == v7.state.key
	end, { key, v7.state.key })
	local v42

	if fFlagAXAddInventoryItemsListProps then
		v42 = data and data.showRecommendedItems and v20.RecommendationsType
	else
		v42 = v20.RecommendationsType
	end

	if v42 then
		v42 = not (v20.RecommendationsType == recommendationsType.None) and v33
	end

	local v44 = not v18 and not v33 and v27 ~= module11.Fetching

	local v45 = if v18 and not v33 and v27 ~= module11.Fetching then v36 else nil
	local catalogItemTile

	if fFlagAXInventoryDurablesExpiredFilter and v38 and v32 and #v32 > 0 and v32[1].itemId ~= nil then
		catalogItemTile = module20.ItemTileType.CatalogItemTile
	end

	local v46 = if fFlagAXBackgroundGenerationAnalytics then frozen else nil
	local v47 = {
		items = v32,
		scrollingEnabled = v14,
		showLoadMoreButton = v44,
		showRecommendedItems = v42 or false,
		fetchStatus = v27,
		impressionsTag = v17,
		searchUuid = v34,
		categoryInfo = v20,
		subcategoryFilter = v21,
		analyticsMetadata = v25,
		requestImpressionsSignal = v19,
		itemDetailsPeekViewRefs = v5,
		fetchUserInventory = v36,
		sendShopForMoreAnalytics = v40,
		onCanvasPositionChanged = v35,
		renderItem = renderItem,
		impressionsPageFilter = v41,
		onListEndReached = v45,
		itemTileType = nil,
		thumbnailLatencyStore = nil,
		extraImpressionsDetectorExtensions = nil,
		showExclusiveWithPlusSection = nil,
		scrollPerformanceIntervalName = 0
	}

	if not fFlagAXInventoryDurablesExpiredFilter then
		catalogItemTile = nil
	end

	v47.itemTileType = catalogItemTile
	v47.thumbnailLatencyStore = if fFlagAXEditorEnableThumbnailLatencyStore then v29 else nil

	if not fFlagAXBackgroundGenerationAnalytics then
		v46 = nil
	end

	v47.extraImpressionsDetectorExtensions = v46

	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		showExclusiveWithPlusSection = nil
	end

	v47.showExclusiveWithPlusSection = showExclusiveWithPlusSection

	local v49 = if data then data.scrollPerformanceIntervalName else nil
	v47.scrollPerformanceIntervalName = v49
	return v47
end

return useInventoryItemsListProps
