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
local module = require("@luauforge/bundled/fuM")
local inventoryFilters = module.Enums.InventoryFilters
local inventoryItemType = module.Enums.InventoryItemType
local useSlotBasedEditorContext = module.Context.useSlotBasedEditorContext
local useAvatarEditorStores = module.Context.useAvatarEditorStores
local useAvatarSaveContext = require("@luauforge/bundled/gfT").Context.useAvatarSaveContext

local recommendationsType = require("@luauforge/bundled/dMd").Enums.RecommendationsType
local module2 = require("@luauforge/bundled/geT")
local module3 = require("@luauforge/bundled/fvh")
local module4 = require("@luauforge/bundled/fuD")
local module5 = require("@luauforge/deferred/gOP")
local module6 = require("@luauforge/deferred/gRZ")
local module7 = require("@luauforge/bundled/dwA")
local module8 = require("@luauforge/bundled/eda")
local module9 = require("@luauforge/deferred/gQA")

local module10 = require("@luauforge/deferred/gQz")
local module11 = require("@luauforge/bundled/dxy")
local module12 = require("@luauforge/bundled/eeH")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local module14 = require("@luauforge/deferred/gOR")

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext
require("@luauforge/deferred/gkN")

local module15 = require("@luauforge/deferred/gSa")
local module16 = require("@luauforge/deferred/gPx")
require("@luauforge/deferred/gQC")
require("@luauforge/deferred/gRV")
local module17 = require("@luauforge/deferred/gSe")
local module18 = require("@luauforge/deferred/gSg")
local module19 = require("@luauforge/bundled/dME")
local module20 = require("@luauforge/bundled/dMx")

local catalogItemCardStatusIconTypeEnum = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCardStatusIconTypeEnum

local useAdaptiveScrolling = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useAdaptiveScrolling
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps
local fIntAXDefaultInventoryPageSize = AvatarExperienceFlags.FIntAXDefaultInventoryPageSize
local module22 = require("@luauforge/bundled/dPy")
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate
local fFlagAXEditorEnableThumbnailLatencyStore = AvatarExperienceFlags.FFlagAXEditorEnableThumbnailLatencyStore
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXBackgroundGenerationAnalytics = AvatarExperienceFlags.FFlagAXBackgroundGenerationAnalytics

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = AvatarExperienceFlags.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled
local module23 = require("@luauforge/deferred/gPc")
local module24 = require("@luauforge/deferred/gQm")
local module25 = require("@luauforge/deferred/gOO")

local module26 = require("@luauforge/deferred/gOS")

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/ggZ").EditorInventoryTTIMilestoneManager
local module27 = require("@luauforge/deferred/gQI")

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

local function useInventoryItemsListProps(data, showExclusiveWithPlusSection)
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

	local v18 = useAppPolicy(function(p2)
		return p2.getEnableContinuousLoad()
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

	local v26 = useSelector((React.useCallback(function(p2)
		return performFetch.GetStatus(p2, v22.SearchUuid)
	end, { v22.SearchUuid })))
	local v27

	if fFlagAXAvatarEditorStoresContext then
		v27 = v15.categoryInventoryStores[v22.NavigationKey]
	else
		v27 = v16.categoryInventoryStores[v22.NavigationKey]
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

	local v28 = nil

	if fFlagAXAvatarEditorStoresContext and fFlagAXEditorEnableThumbnailLatencyStore then
		local thumbnailLatencyStores = v15.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v28 = thumbnailLatencyStores[v22.NavigationKey]
		end
	elseif fFlagAXEditorEnableThumbnailLatencyStore and not fFlagAXAvatarEditorStoresContext and v16 then
		local thumbnailLatencyStores = v16.thumbnailLatencyStores

		if thumbnailLatencyStores then
			v28 = thumbnailLatencyStores[v22.NavigationKey]
		end
	end

	if fFlagAXEditorEnableThumbnailLatencyStore then
		module26(v28)
	end

	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		showExclusiveWithPlusSection = nil
	end

	local v30

	if fFlagAXInventoryDurablesExpiredFilter then
		v30 = sortAndFiltersStore
	elseif fFlagAXAvatarEditorStoresContext then
		v30 = v15.sortAndFiltersStore
	else
		v30 = v16.sortAndFiltersStore
	end

	local v31 = module17(v27, v22, v30, showExclusiveWithPlusSection)

	if fFlagAXBackgroundGeneration then
		local v32 = useSelector(function(p2)
			return p2.AvatarExperience.Common.AssetInfos
		end)

		local v33 = React.useMemo(function()
			return module18.getDetailsFetchKeyForCategory(v22.NavigationKey, v31, v32)
		end, { v31, v32, v22.NavigationKey })
		local v34 = React.useMemo(function()
			return module18.getItemsFromDetailsFetchKey(v33)
		end, { v33 })

		React.useEffect(function()
			module18.dispatchDetailsFetchIfNeeded(v6, v9, v34)
		end, { v34, v6, v9 })
	end

	local v32 = useSignalState(v27.getHasReachedLastPage)
	local v33 = useSignalState(v27.getSearchUuid)

	local v34 = React.useCallback(function(p2)
		v19:fire()

		if data and data.onContentScroll then
			data.onContentScroll(p2)
		end

		if v13 and v13.onCanvasYChanged then
			v13.onCanvasYChanged(p2.CanvasPosition.Y)
		end
	end, { v13, data })

	if module22() then
		React.useEffect(function()
			v6(module6(v9))
		end, { v12, v6 })
	end

	local v35

	if module14() then
		local useCallback = React.useCallback
		local function fn()
			if not v27.getHasReachedLastPage(false) then
				local v42 = if not (fFlagAXAddInventoryItemsListProps and data and data.disableSortsAndFilters) then sortAndFiltersStore else nil
				v6(module5(v9, v22, nil, v27, v42, fFlagAXTTIEditorEnableMilestones and true or nil))

				if fFlagAXTTIEditorEnableMilestones and editorInventoryTTIMilestoneManager then
					local v43 = not (v20.Subcategory == nil) and v20.Category ~= nil

					local name = if v43 then module4.getAvatarEditorCategoryInfo(v20.Category, nil).Name else v20.Name
					local updateMetadata = editorInventoryTTIMilestoneManager.updateMetadata

					local v45 = if v43 then v20.Name else nil
					updateMetadata({
						category = name,
						subcategory = v45,
						page = v8.current.name,
						opaquePage = v8.opaque.name
					})
				end
			end
		end

		local v37 = if fFlagAXEditorEnableThumbnailLatencyStore then v28 else nil
		local v38 = if fFlagAXEditorEnableThumbnailLatencyStore then data else nil
		local name = if fFlagAXTTIEditorEnableMilestones then v20.Name else nil
		local category = if fFlagAXTTIEditorEnableMilestones then v20.Category else nil
		local v39 = if fFlagAXTTIEditorEnableMilestones then v20.Subcategory else nil
		v35 = useCallback(fn, {
			v6,
			v9,
			v22,
			v27,
			sortAndFiltersStore,
			v37,
			v38,
			name,
			category,
			v39
		})
	else
		local useCallback = React.useCallback
		local function fn()
			if not v27.getHasReachedLastPage(false) then
				v6(module5(v9, v22, nil, v27, nil, fFlagAXTTIEditorEnableMilestones and true or nil))

				if fFlagAXTTIEditorEnableMilestones and editorInventoryTTIMilestoneManager then
					local v36 = not (v20.Subcategory == nil) and v20.Category ~= nil

					local name = if v36 then module4.getAvatarEditorCategoryInfo(v20.Category, nil).Name else v20.Name
					local updateMetadata = editorInventoryTTIMilestoneManager.updateMetadata

					local v38 = if v36 then v20.Name else nil
					updateMetadata({
						category = name,
						subcategory = v38,
						page = v8.current.name,
						opaquePage = v8.opaque.name
					})
				end
			end
		end

		local v37 = if fFlagAXEditorEnableThumbnailLatencyStore then v28 else nil
		local name = if fFlagAXTTIEditorEnableMilestones then v20.Name else nil
		local category = if fFlagAXTTIEditorEnableMilestones then v20.Category else nil
		local v38 = if fFlagAXTTIEditorEnableMilestones then v20.Subcategory else nil
		v35 = useCallback(fn, { v6, v9, v22, v27, v37, name, category, v38 })
	end

	if fFlagAXRefetchInventoryOnUpdate then
		module25(v22.SearchUuid, v27, v35)
	end

	local v36

	if fFlagAXInventoryDurablesExpiredFilter then
		v36 = useSignalState(sortAndFiltersStore.getSortAndFilters)
	end

	local v37

	if fFlagAXInventoryDurablesExpiredFilter then
		v37 = v36.filter == inventoryFilters.Expired
	else
		v37 = nil
	end

	local ref2 = if fFlagAXEditorEnableThumbnailLatencyStore then React.useRef({}) else nil
	local v38

	if fFlagAXEditorEnableThumbnailLatencyStore and ref2 then
		v38 = React.useCallback(function(p2)
			if v28 == nil then
				return nil
			end

			local current = ref2.current
			local v39 = current[p2]

			if v39 then
				return v39
			end

			local v40 = v28
			local function fn(p3)
				v40.setThumbnailLoaded(p2)
			end
			current[p2] = fn
			return fn
		end, { v28 })
	else
		v38 = nil
	end

	local function renderItem(props, p2)
		if fFlagAXAddInventoryItemsListProps and data and data.renderItem then
			return data.renderItem(props, {
				ownedItemIdToIsWearing = v24,
				gridRef = ref,
				itemDetailsPeekViewRefs = v5,
				impressionsTag = v17
			})
		end

		if fFlagAXInventoryDurablesExpiredFilter and v37 and props.item.itemId then
			local v39 = props.gridInformation
				and {
					gridPositionRow = props.gridInformation.row,
					gridPositionColumn = props.gridInformation.column
				}
				or nil
			local v40

			if props.item.inventoryItemType == inventoryItemType.Asset then
				v40 = module20.ItemType.Asset
			else
				v40 = module20.ItemType.Bundle
			end

			local createElement = React.createElement
			local v42 = {
				itemId = props.item.itemId,
				itemType = v40,
				index = props.index,
				analyticsItemCountPerPage = fIntAXDefaultInventoryPageSize,
				analyticsContext = module19.AnalyticsContext.AvatarEditorExpiredItem,
				itemDetailsPeekViewRefs = v5,
				resultsListRef = ref,
				gridInformation = v39,
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
			local v43 = if v21 then v21.Name else nil
			v42.impressionsSubcategory = v43

			v42.itemStatusOverride = {
				type = "icon",
				iconType = catalogItemCardStatusIconTypeEnum.Durable
			}
			return createElement(module16, v42)
		else
			local itemId = props.item.itemId

			if fFlagAXEditorEnableThumbnailLatencyStore and v28 and itemId then
				v28.appendThumbnail(itemId)
			end

			local createElement = React.createElement
			local v40 = {
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

			local v43 = if fFlagAXEditorEnableThumbnailLatencyStore and itemId and v38 then v38(itemId) else nil
			v40.onThumbnailLoaded = v43

			local v44 = if fFlagAXBackgroundGeneration and p2 then p2.onPlusExclusiveActivated else nil
			v40.onPlusExclusiveActivated = v44

			local v45 = if fFlagAXBackgroundGenerationAnalytics and fFlagAXBackgroundGeneration and p2 then p2.plus else nil
			v40.plus = v45
			return createElement(module15, v40)
		end
	end

	local v39 = React.useCallback(function()
		v6(module9(v10))
	end, { v6, v10 })

	local v40 = React.useCallback(function(): boolean
		return key == v7.state.key
	end, { key, v7.state.key })
	local v41

	if fFlagAXAddInventoryItemsListProps then
		v41 = data and data.showRecommendedItems and v20.RecommendationsType
	else
		v41 = v20.RecommendationsType
	end

	if v41 then
		v41 = not (v20.RecommendationsType == recommendationsType.None) and v32
	end

	local v43 = not v18 and not v32 and v26 ~= module11.Fetching

	local v44 = if v18 and not v32 and v26 ~= module11.Fetching then v35 else nil
	local catalogItemTile

	if fFlagAXInventoryDurablesExpiredFilter and v37 and v31 and #v31 > 0 and v31[1].itemId ~= nil then
		catalogItemTile = module20.ItemTileType.CatalogItemTile
	end

	local v45 = if fFlagAXBackgroundGenerationAnalytics then frozen else nil
	local v46 = {
		items = v31,
		scrollingEnabled = v14,
		showLoadMoreButton = v43,
		showRecommendedItems = v41 or false,
		fetchStatus = v26,
		impressionsTag = v17,
		searchUuid = v33,
		categoryInfo = v20,
		subcategoryFilter = v21,
		analyticsMetadata = v25,
		requestImpressionsSignal = v19,
		itemDetailsPeekViewRefs = v5,
		fetchUserInventory = v35,
		sendShopForMoreAnalytics = v39,
		onCanvasPositionChanged = v34,
		renderItem = renderItem,
		impressionsPageFilter = v40,
		onListEndReached = v44,
		itemTileType = nil,
		thumbnailLatencyStore = nil,
		extraImpressionsDetectorExtensions = nil,
		showExclusiveWithPlusSection = nil,
		scrollPerformanceIntervalName = 0
	}

	if not fFlagAXInventoryDurablesExpiredFilter then
		catalogItemTile = nil
	end

	v46.itemTileType = catalogItemTile
	v46.thumbnailLatencyStore = if fFlagAXEditorEnableThumbnailLatencyStore then v28 else nil

	if not fFlagAXBackgroundGenerationAnalytics then
		v45 = nil
	end

	v46.extraImpressionsDetectorExtensions = v45

	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		showExclusiveWithPlusSection = nil
	end

	v46.showExclusiveWithPlusSection = showExclusiveWithPlusSection

	local v48 = if data then data.scrollPerformanceIntervalName else nil
	v46.scrollPerformanceIntervalName = v48
	return v46
end

return useInventoryItemsListProps
