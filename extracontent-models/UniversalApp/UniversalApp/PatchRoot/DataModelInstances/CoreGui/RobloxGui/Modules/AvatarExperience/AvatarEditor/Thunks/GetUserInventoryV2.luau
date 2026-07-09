local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Dash = require(CorePackages.Packages.Dash)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local InventorySorts = AvatarExperienceSlotBasedEditor.Enums.InventorySorts
local InventoryFilterToAvailabilityStatus = AvatarExperienceSlotBasedEditor.Constants.InventoryFilterToAvailabilityStatus
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SetOwnedItemIdsBySubtype = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOwnedItemIdsBySubtype)
local SetPageFinished = require(Modules.AvatarExperience.AvatarEditor.Actions.SetPageFinished)
local SetOutfitOrAsset = require(Modules.AvatarExperience.AvatarEditor.Actions.SetOutfitOrAsset)
local SetAssetInfoFromInventoryFetch = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAssetInfoFromInventoryFetch)
local GetOutfit = require(Modules.AvatarExperience.AvatarEditor.Thunks.GetOutfit)
local BatchGetOutfits = require(Modules.AvatarExperience.Common.Thunks.BatchGetOutfits)
local getStaleInventoryGrantStore = AvatarExperienceSlotBasedEditor.Stores.getStaleInventoryGrantStore

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local WebApi = require(Modules.AvatarExperience.AvatarEditor.Http.WebApi)
local FetchAssetOrBundleInfoBatched = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfoBatched)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local mutedError = require(Modules.LuaApp.mutedError)
local FFlagAXInventoryV2CombineGetOutfitDispatches = require(Modules.AvatarExperience.Flags.FFlagAXInventoryV2CombineGetOutfitDispatches)
local FIntAXDefaultInventoryPageSize = AvatarExperienceFlags.FIntAXDefaultInventoryPageSize
local GetFFlagAXRemoveAwaitUsageInThunks = require(Modules.AvatarExperience.Flags.GetFFlagAXRemoveAwaitUsageInThunks)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXPhotoboothIsStandalone = AvatarExperienceFlags.FFlagAXPhotoboothIsStandalone
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = AvatarExperienceFlags.FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXFixStaleModerationStatusFromGrant = AvatarExperienceFlags.FFlagAXFixStaleModerationStatusFromGrant
local FFlagAXFixIecModerationFromInventoryFetch = AvatarExperienceFlags.FFlagAXFixIecModerationFromInventoryFetch
local FFlagAXRefetchInventoryOnAssetGrant = AvatarExperienceFlags.FFlagAXRefetchInventoryOnAssetGrant
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones
local EditorInventoryTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).EditorInventoryTTIMilestoneManager

local function checkAndSendDuplicateItemCount(p1, s1: string, t1: {[any]: any}) -- line: 88
	-- upvalues: Dash (copy), sendAXCounterV2 (copy), Constants2 (copy)
	local v60 = p1.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[s1]

	if not v60 or #v60 == 0 then
		return
	end

	local v61 = Dash.keyBy(v60, function(p2) -- line: 97
		return p2
	end)

	for _, v63 in t1 do
		if v61[v63] then
			sendAXCounterV2(Constants2.Counter.AvatarInventory.ReceivedDuplicateItem)
		else
			v61[v63] = v63
		end
	end
end
local function getRequestItemCategoriesFromInfo(p3) -- line: 109
	-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy), AvatarEditorCategories (copy), Constants (copy), Constants2 (copy)
	local t2 = {}

	if GetFFlagAXEnableNewInventoryItemsList() and p3.NavigationKey == AvatarEditorCategories.All then
		return {}
	end

	if p3.AssetTypeIdStrings then
		for _, v67 in p3.AssetTypeIdStrings do
			table.insert(t2, {
				itemType = string.lower(Constants.OutfitOrAsset.Asset or "asset"),
				itemSubType = tonumber(v67)
			})
		end
	end

	if GetFFlagAXEnableNewInventoryItemsList() then
		if p3.BundleTypeIdStrings then
			for _, v69 in p3.BundleTypeIdStrings do
				local v70 = Constants2.BundleTypeIdStringsForBackend[v69]

				if v70 then
					table.insert(t2, {
						itemType = string.lower(Constants.OutfitOrAsset.Outfit or "outfit"),
						itemSubType = tonumber(v70)
					})
				end
			end

			return t2
		end
	elseif p3.OutfitTypeIdStrings then
		for _, v72 in p3.OutfitTypeIdStrings do
			local v73 = Constants2.BundleTypeIdStringsForBackend[v72]

			if v73 then
				table.insert(t2, {
					itemType = string.lower(Constants.OutfitOrAsset.Outfit or "outfit"),
					itemSubType = tonumber(v73)
				})
			end
		end
	end

	return t2
end
local function getNextPageCursor(s2: string?) -- line: 164
	-- upvalues: MemStorageService (copy)
	if not s2 then
		return nil
	end

	return MemStorageService:GetItem(s2)
end
local function assetExists(p4, s3: string) -- line: 171
	local v77 = p4.AvatarExperience.Common.AssetInfos[s3]

	if v77 and v77.receivedFromInventoryFetch then
		return true
	end

	return false
end
local function outfitExists(p5, s4: string) -- line: 179
	return p5.AvatarExperience.AvatarEditor.OutfitInfos[s4] ~= nil
end

local t3 = {
	PendingReview = Enum.ModerationStatus.NotReviewed,
	Unavailable = Enum.ModerationStatus.ReviewedRejected
}
local v54 = if not FFlagAXInventoryDurablesExpiredFilter then nil else function(p6, p7, t4: {[any]: any}) -- line: 191
	-- upvalues: Constants2 (copy), FetchAssetOrBundleInfoBatched (copy)
	local t5 = {}

	for _, v85 in t4 do
		local Asset = nil

		if v85.itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
			Asset = Constants2.ItemType.Asset
		elseif v85.itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
			Asset = Constants2.ItemType.Bundle
		end

		if Asset then
			table.insert(t5, {
				id = tostring(v85.itemId),
				itemType = Asset
			})
		end
	end

	if #t5 > 0 then
		p7:dispatch(FetchAssetOrBundleInfoBatched(p6, nil, t5, true))
	end
end

local function v55(t6: {[any]: any}) -- line: 216
	-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXPhotoboothIsStandalone (copy), FFlagAXTTIEditorEnableMilestones (copy), EditorInventoryTTIMilestoneManager (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), FFlagAXFixIecModerationFromInventoryFetch (copy), t3 (copy), FFlagAXFixStaleModerationStatusFromGrant (copy), Utils (copy), Constants2 (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXInventoryV2CombineGetOutfitDispatches (copy), GetOutfit (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), SetAssetInfoFromInventoryFetch (copy), checkAndSendDuplicateItemCount (copy), BatchGetOutfits (copy), SetOutfitOrAsset (copy), Constants (copy), SetOwnedItemIdsBySubtype (copy), getStaleInventoryGrantStore (copy), FFlagAXInventoryDurablesExpiredFilter (copy), v54 (copy), MemStorageService (copy), SetPageFinished (copy)
	if (GetFFlagAXEnableNewInventoryItemsList() or FFlagAXPhotoboothIsStandalone) and t6.categoryInventoryStore then
		t6.categoryInventoryStore.addResultsPage(t6.results)
	end

	local store = t6.store
	local searchUuid = t6.searchUuid
	local results = t6.results
	local resolve = t6.resolve
	local v92 = FFlagAXTTIEditorEnableMilestones and (t6.shouldTrackTTI == true and (t6.ttiSessionGeneration ~= nil and (EditorInventoryTTIMilestoneManager ~= nil and t6.ttiSessionGeneration == EditorInventoryTTIMilestoneManager.getSessionGeneration())))
	local v93 = store:getState()
	local v94 = if not FFlagAXRefetchInventoryOnAssetGrant then nil else t6.isStaleCategoryRefetch == true
	local v95 = results.avatarInventoryItems or {}

	if FFlagAXTTIEditorEnableMilestones and v92 and EditorInventoryTTIMilestoneManager then
		EditorInventoryTTIMilestoneManager.L2.primaryDataReady()
		EditorInventoryTTIMilestoneManager.L3.getInventoryV2Completed()
	end

	local t7 = {}
	local t8 = {}
	local t9 = {}
	local t10 = {}

	for _, v101 in v95 do
		local str = tostring(v101.itemId)
		local itemCategory = v101.itemCategory

		t9[#t9 + 1] = str

		if itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
			if not v94 then
				local v104 = v93.AvatarExperience.Common.AssetInfos[str]

				if v104 and v104.receivedFromInventoryFetch then
					continue
				end
			end

			local v105 = nil
			local str2 = nil
			local availabilityStatus = v101.availabilityStatus

			if availabilityStatus then
				v105 = if not FFlagAXFixIecModerationFromInventoryFetch or not v101.creatingUniverseId then if not FFlagAXFixStaleModerationStatusFromGrant then t3[availabilityStatus] else Utils.getModerationStatusFromAvailabilityStatus(availabilityStatus) else t3[availabilityStatus]
			end

			if v101.creatingUniverseId then
				str2 = tostring(v101.creatingUniverseId)
			end

			t7[#t7 + 1] = {
				assetId = v101.itemId,
				name = v101.itemName,
				assetType = Constants2.AssetTypeIdStringToName[tostring(itemCategory.itemSubType)],
				moderationStatus = v105,
				creatingUniverseId = str2,
				expirationTime = if not FFlagAXInventoryDurablesSupport then nil else v101.expirationTime
			}

			continue
		end

		if itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
			t8[#t8 + 1] = str

			if v93.AvatarExperience.AvatarEditor.OutfitInfos[str] == nil then
				if FFlagAXInventoryV2CombineGetOutfitDispatches then
					table.insert(t10, str)
				else
					store:dispatch(GetOutfit(str, nil, nil, if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else t6.networkImpl))
				end
			end
		end
	end

	if FFlagAXTTIEditorEnableMilestones and v92 and EditorInventoryTTIMilestoneManager then
		EditorInventoryTTIMilestoneManager.L2.dataProcessingStarted()
	end

	if #t7 > 0 then
		store:dispatch(SetAssetInfoFromInventoryFetch(t7))
	end

	checkAndSendDuplicateItemCount(v93, searchUuid, t9)

	if FFlagAXInventoryV2CombineGetOutfitDispatches then
		store:dispatch(BatchGetOutfits(t10, if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then nil else t6.networkImpl))
	end

	store:dispatch(SetOutfitOrAsset(t8, Constants.OutfitOrAsset.Outfit))
	store:dispatch(SetOwnedItemIdsBySubtype(searchUuid, t9))

	if FFlagAXRefetchInventoryOnAssetGrant and v94 then
		getStaleInventoryGrantStore().clearSearchUuidStale(searchUuid)
	end

	if FFlagAXTTIEditorEnableMilestones and v92 and EditorInventoryTTIMilestoneManager then
		EditorInventoryTTIMilestoneManager.L2.dataProcessingCompleted()
	end

	if FFlagAXInventoryDurablesExpiredFilter and t6.shouldFetchItemDetails then
		v54(t6.networkImpl, store, v95)
	end

	local ReachedLastPage = nil

	if results then
		local nextPageToken = results.nextPageToken

		if nextPageToken and nextPageToken ~= "" then
			MemStorageService:SetItem(searchUuid, nextPageToken)
		else
			store:dispatch(SetPageFinished(searchUuid, true))
			MemStorageService:SetItem(searchUuid, Constants.ReachedLastPage)
			ReachedLastPage = Constants.ReachedLastPage
		end
	end

	resolve(ReachedLastPage)
end
local function fetchItems(t11: {[any]: any}) -- line: 381
	-- upvalues: FIntAXDefaultInventoryPageSize (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), InventorySorts (copy), FFlagAXInventoryDurablesExpiredFilter (copy), InventoryFilterToAvailabilityStatus (copy), FFlagAXTTIEditorEnableMilestones (copy), GetFFlagAXRemoveAwaitUsageInThunks (copy), EditorInventoryTTIMilestoneManager (copy), WebApi (copy), getRequestItemCategoriesFromInfo (copy), v55 (copy), GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXPhotoboothIsStandalone (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), FFlagAXRootSlotBasedEditorFlag (copy)
	local v111 = FIntAXDefaultInventoryPageSize
	local v112 = if not GetFFlagAXEnableInventorySortsAndFilters() or not t11.sortAndFiltersStore then nil else t11.sortAndFiltersStore.getSortAndFilters(false)
	local v113 = (not GetFFlagAXEnableInventorySortsAndFilters() or (not v112 or v112.sort ~= InventorySorts.RecentlyWorn)) and "recentAdded" or "recentEquipped"
	local u114 = nil
	local v115 = nil

	if FFlagAXInventoryDurablesExpiredFilter and (GetFFlagAXEnableInventorySortsAndFilters() and v112) then
		v115 = InventoryFilterToAvailabilityStatus[v112.filter]
		u114 = v115 ~= nil
	end

	local v116 = FFlagAXTTIEditorEnableMilestones and (t11.nextPageCursor ~= nil and t11.nextPageCursor ~= "")
	local v117 = FFlagAXTTIEditorEnableMilestones and (t11.trackTTI == true and not v116)
	local u118 = nil

	if GetFFlagAXRemoveAwaitUsageInThunks() then
		if FFlagAXTTIEditorEnableMilestones and v117 and EditorInventoryTTIMilestoneManager then
			EditorInventoryTTIMilestoneManager.startTracking()
			u118 = EditorInventoryTTIMilestoneManager.getSessionGeneration()
			EditorInventoryTTIMilestoneManager.L2.primaryDataStarted()
			EditorInventoryTTIMilestoneManager.L3.networkFetch()
			EditorInventoryTTIMilestoneManager.L3.getInventoryV2Started()
		end

		return WebApi.GetUserAvatarInventory(t11.networkImpl, getRequestItemCategoriesFromInfo(t11.categoryInfo), v113, v111, t11.nextPageCursor, (if not FFlagAXInventoryDurablesExpiredFilter then nil else v115)):andThen(function(p8) -- line: 441
			-- upvalues: v55 (copy), t11 (copy), GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXPhotoboothIsStandalone (copy), FFlagAXInventoryDurablesExpiredFilter (copy), u114 (ref), FFlagAXTTIEditorEnableMilestones (copy), v117 (copy), u118 (ref), FFlagAXRefetchInventoryOnAssetGrant (copy)
			local responseBody = p8.responseBody

			v55({
				networkImpl = t11.networkImpl,
				results = responseBody,
				searchUuid = t11.searchUuid,
				store = t11.store,
				resolve = t11.resolve,
				categoryInventoryStore = if not GetFFlagAXEnableNewInventoryItemsList() and not FFlagAXPhotoboothIsStandalone then nil else t11.categoryInventoryStore,
				shouldFetchItemDetails = if not FFlagAXInventoryDurablesExpiredFilter then nil else u114,
				shouldTrackTTI = if not FFlagAXTTIEditorEnableMilestones then nil else v117,
				ttiSessionGeneration = if not FFlagAXTTIEditorEnableMilestones then nil else u118,
				isStaleCategoryRefetch = if not FFlagAXRefetchInventoryOnAssetGrant then nil else t11.isStaleCategoryRefetch
			})
		end):catch(function(p9) -- line: 463
			-- upvalues: t11 (copy)
			warn("GetUserInventoryV2 failure: ", p9)

			return t11.reject()
		end)
	end

	local v119, v120 = WebApi.GetUserAvatarInventory(t11.networkImpl, getRequestItemCategoriesFromInfo(t11.categoryInfo), v113, v111, t11.nextPageCursor, (if not FFlagAXInventoryDurablesExpiredFilter then nil else v115)):await()

	if not v119 then
		warn("GetUserInventoryV2 failure: ", v120)

		return t11.reject(if not FFlagAXRootSlotBasedEditorFlag then nil else v120)
	end

	local responseBody = v120.responseBody

	v55({
		networkImpl = t11.networkImpl,
		results = responseBody,
		searchUuid = t11.searchUuid,
		store = t11.store,
		resolve = t11.resolve,
		categoryInventoryStore = if not GetFFlagAXEnableNewInventoryItemsList() and not FFlagAXPhotoboothIsStandalone then nil else t11.categoryInventoryStore,
		shouldFetchItemDetails = if not FFlagAXInventoryDurablesExpiredFilter then nil else u114,
		shouldTrackTTI = if not FFlagAXTTIEditorEnableMilestones then nil else v117,
		ttiSessionGeneration = if not FFlagAXTTIEditorEnableMilestones then nil else u118,
		isStaleCategoryRefetch = if not FFlagAXRefetchInventoryOnAssetGrant then nil else t11.isStaleCategoryRefetch
	})
end

return function(p10, p11, _, p13, p14, b1: boolean?) -- line: 502
	-- upvalues: ArgCheck (copy), FFlagAXCustomizeBackgrounds (copy), FFlagAXBackgroundsCustomizeHydration (copy), AvatarEditorCategories (copy), SetPageFinished (copy), MemStorageService (copy), Constants (copy), Promise (copy), Utils2 (copy), FFlagAXEditorSubcategoryFilters (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), getStaleInventoryGrantStore (copy), PerformFetch (copy), GetFFlagAXEnableNewInventoryItemsList (copy), fetchItems (copy), FFlagAXPhotoboothIsStandalone (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), FFlagAXTTIEditorEnableMilestones (copy), mutedError (copy)
	ArgCheck.isType(p11, "table", "GetUserInventoryV2 thunk expects categoryInfo to be a table")

	return function(p15) -- line: 517
		-- upvalues: FFlagAXCustomizeBackgrounds (copy), FFlagAXBackgroundsCustomizeHydration (copy), p11 (copy), AvatarEditorCategories (copy), SetPageFinished (copy), MemStorageService (copy), Constants (copy), p13 (copy), Promise (copy), Utils2 (copy), FFlagAXEditorSubcategoryFilters (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), getStaleInventoryGrantStore (copy), PerformFetch (copy), GetFFlagAXEnableNewInventoryItemsList (copy), fetchItems (copy), p10 (copy), FFlagAXPhotoboothIsStandalone (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), p14 (copy), FFlagAXTTIEditorEnableMilestones (copy), b1 (copy), mutedError (copy)
		if FFlagAXCustomizeBackgrounds and (not FFlagAXBackgroundsCustomizeHydration and p11.NavigationKey == AvatarEditorCategories.Backgrounds) then
			p15:dispatch(SetPageFinished(p11.SearchUuid, true))
			MemStorageService:SetItem(p11.SearchUuid, Constants.ReachedLastPage)

			if p13 then
				p13.addResultsPage({
					avatarInventoryItems = {}
				})
			end

			return Promise.resolve(Constants.ReachedLastPage)
		end

		local v133 = p15:getState()
		local v134 = Utils2.getSearchUuidAndAssetTypes(p11, v133.AvatarExperience.AvatarEditor.Categories.subButton, if not FFlagAXEditorSubcategoryFilters then nil else v133.AvatarExperience.AvatarEditor.Categories.subcategoryFilter)

		if not v134 then
			return Promise.resolve("No SearchUuid")
		end

		local v135 = if not FFlagAXRefetchInventoryOnAssetGrant then nil else getStaleInventoryGrantStore().isSearchUuidStale(v134)

		return PerformFetch.Single((if not FFlagAXRefetchInventoryOnAssetGrant or not v135 then v134 else v134 .. "-stale"), function() -- line: 556
			-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy), p13 (copy), Promise (copy), Constants (copy), v134 (copy), MemStorageService (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), v135 (copy), fetchItems (copy), p10 (copy), p11 (copy), p15 (copy), FFlagAXPhotoboothIsStandalone (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), p14 (copy), FFlagAXTTIEditorEnableMilestones (copy), b1 (copy)
			local nextPageCursor

			if GetFFlagAXEnableNewInventoryItemsList() and p13 then
				nextPageCursor = p13.nextPageCursor

				if p13.getHasReachedLastPage(false) then
					return Promise.resolve(Constants.ReachedLastPage)
				end
			else
				local v137 = v134

				nextPageCursor = if v137 then MemStorageService:GetItem(v137) else nil

				if nextPageCursor == Constants.ReachedLastPage then
					return Promise.resolve(Constants.ReachedLastPage)
				end
			end

			local v138 = if not FFlagAXRefetchInventoryOnAssetGrant then nil else nextPageCursor == nil and v135

			return Promise.new(function(resolve, reject) -- line: 574
				-- upvalues: fetchItems (copy), p10 (copy), v134 (copy), p11 (copy), p15 (copy), nextPageCursor (ref), GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXPhotoboothIsStandalone (copy), p13 (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), p14 (copy), FFlagAXTTIEditorEnableMilestones (copy), b1 (copy), FFlagAXRefetchInventoryOnAssetGrant (copy), v138 (copy)
				fetchItems({
					networkImpl = p10,
					searchUuid = v134,
					categoryInfo = p11,
					store = p15,
					resolve = resolve,
					reject = reject,
					nextPageCursor = nextPageCursor,
					categoryInventoryStore = if not GetFFlagAXEnableNewInventoryItemsList() and not FFlagAXPhotoboothIsStandalone then nil else p13,
					sortAndFiltersStore = if not GetFFlagAXEnableInventorySortsAndFilters() then nil else p14,
					trackTTI = if not FFlagAXTTIEditorEnableMilestones then nil else b1,
					isStaleCategoryRefetch = if not FFlagAXRefetchInventoryOnAssetGrant then nil else v138
				})
			end)
		end)(p15):catch(function(p16) -- line: 597
			-- upvalues: mutedError (copy)
			mutedError("GetUserInventoryV2 fetch failed: ", p16)
		end)
	end
end
