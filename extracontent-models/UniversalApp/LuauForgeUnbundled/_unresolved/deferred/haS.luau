local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")

local Promise = require(CorePackages.Packages.Promise)
local Http = require("@game/CorePackages/Workspace/Packages/Http")
local performFetch = Http.PerformFetch
local retrievalStatus = Http.Enum.RetrievalStatus
local module2 = require("@luauforge/bundled/dzP")
local Dash = require(CorePackages.Packages.Dash)
local module3 = require("@luauforge/bundled/fCn")
local module4 = require("@luauforge/bundled/dPt")
local inventorySorts = module3.Enums.InventorySorts

local inventoryFilterToAvailabilityStatus = module3.Constants.InventoryFilterToAvailabilityStatus
local avatarEditorCategories = module4.Enums.AvatarEditorCategories
local inventoryItemAvailability = module3.Enums.InventoryItemAvailability
local getInventorySearchKey = module3.Utils.getInventorySearchKey
local toSearchableItemCategories = module3.Utils.toSearchableItemCategories
local inventorySearchConstants = module3.InventorySearchConstants
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local fFlagAXBackgroundsOutfitPersistence = AvatarExperienceFlags.FFlagAXBackgroundsOutfitPersistence
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing

local fFlagAXReturnModeratedPlusExclusiveBackgrounds = AvatarExperienceFlags.FFlagAXReturnModeratedPlusExclusiveBackgrounds
local fFlagAXKeepHeadShapeInInventoryOutfitMeta = AvatarExperienceFlags.FFlagAXKeepHeadShapeInInventoryOutfitMeta
local module6 = require("@luauforge/bundled/fCe")

local module7 = require("@luauforge/bundled/dRo")
local module8 = require("@luauforge/bundled/dSq")
local module9 = require("@luauforge/bundled/dSd")
local module10 = require("@luauforge/bundled/dSj")

local module11 = require("@luauforge/bundled/dPX")

local module12 = require("@luauforge/bundled/dPZ")
local module13 = require("@luauforge/bundled/fDC")
local module14 = require("@luauforge/bundled/fDB")
local module15 = require("@luauforge/bundled/gLE")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dPs")
local module16 = require("@luauforge/bundled/dRg")
local module17 = require("@luauforge/bundled/dPN")
local module18 = require("@luauforge/bundled/fCI")
local module19 = require("@luauforge/bundled/fDG")
local module20 = require("@luauforge/deferred/gTo")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")
local module21 = require("@luauforge/bundled/dFs")

local module22 = require("@luauforge/deferred/haT")
local fIntAXDefaultInventoryPageSize = AvatarExperienceFlags.FIntAXDefaultInventoryPageSize

local module23 = require("@luauforge/bundled/dRr")

local module24 = require("@luauforge/deferred/haU")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate

local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local fFlagAXTTIEditorEnableMilestones = AvatarExperienceFlags.FFlagAXTTIEditorEnableMilestones

local editorInventoryTTIMilestoneManager = require("@luauforge/bundled/gLF").EditorInventoryTTIMilestoneManager
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXEnableInventorySearch = AvatarExperienceFlags.FFlagAXEnableInventorySearch
local fFlagAXInventorySearchSendAllTabCategories = AvatarExperienceFlags.FFlagAXInventorySearchSendAllTabCategories

local inventoryOutfitType = module4.Enums.InventoryOutfitType

local function checkAndSendDuplicateItemCount(state, searchUuid, itemIds)
	local ownedItemId = state.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[searchUuid]

	if not ownedItemId or #ownedItemId == 0 then
		return
	end

	local key = Dash.keyBy(ownedItemId, function(p2)
		return p2
	end)

	for k, item in itemIds do
		if key[item] then
			sendAXCounterV2(module17.Counter.AvatarInventory.ReceivedDuplicateItem)
		else
			key[item] = item
		end
	end
end

local function getRequestItemCategoriesFromInfo(categoryInfo)
	local result = {}

	if module23() and categoryInfo.NavigationKey == avatarEditorCategories.All then
		return {}
	end

	if fFlagAXMigrateOutfitsToUserInventory and categoryInfo.InventoryOutfitTypes then
		for k, inventoryOutfitType2 in categoryInfo.InventoryOutfitTypes do
			local v5 = module17.InventoryOutfitTypeToInventoryTypeId[inventoryOutfitType2]

			if v5 then
				table.insert(result, {
					itemType = string.lower(module16.OutfitOrAsset.Outfit or "outfit"),
					itemSubType = v5
				})
			end
		end
	end

	if categoryInfo.AssetTypeIdStrings then
		for k, assetTypeIdString in categoryInfo.AssetTypeIdStrings do
			table.insert(result, {
				itemType = string.lower(module16.OutfitOrAsset.Asset or "asset"),
				itemSubType = tonumber(assetTypeIdString)
			})
		end
	end

	if fFlagAXMigrateOutfitsToUserInventory then
		return result
	end

	if module23() then
		if categoryInfo.BundleTypeIdStrings then
			for k, bundleTypeIdString in categoryInfo.BundleTypeIdStrings do
				local v5 = module17.BundleTypeIdStringsForBackend[bundleTypeIdString]

				if v5 then
					table.insert(result, {
						itemType = string.lower(module16.OutfitOrAsset.Outfit or "outfit"),
						itemSubType = tonumber(v5)
					})
				end
			end

			return result
		end
	elseif categoryInfo.OutfitTypeIdStrings then
		for k, outfitTypeIdString in categoryInfo.OutfitTypeIdStrings do
			local v5 = module17.BundleTypeIdStringsForBackend[outfitTypeIdString]

			if v5 then
				table.insert(result, {
					itemType = string.lower(module16.OutfitOrAsset.Outfit or "outfit"),
					itemSubType = tonumber(v5)
				})
			end
		end
	end

	return result
end

local function getNextPageCursor(p2)
	if p2 then
		return MemStorageService:GetItem(p2)
	end

	return nil
end

local function assetExists(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromInventoryFetch then
		return true
	end

	return false
end

local function outfitExists(p2, p3): boolean
	local outfitInfo = p2.AvatarExperience.AvatarEditor.OutfitInfos[p3]

	if not fFlagAXMigrateOutfitsToUserInventory then
		return outfitInfo ~= nil
	end

	if outfitInfo and outfitInfo.receivedFromInventoryFetch then
		return true
	end

	return false
end

local v5 = {
	["PendingReview"] = Enum.ModerationStatus.NotReviewed,
	Unavailable = Enum.ModerationStatus.ReviewedRejected
}

local function normalizeOutfitDetailVector3(data)
	if data == nil then
		return nil
	end

	return { x = data.X, y = data.Y, z = data.Z }
end

local function normalizeOutfitDetailAsset(asset)
	local meta = asset.meta
	local v6

	if meta ~= nil then
		v6 = {
			order = meta.order,
			puffiness = meta.puffiness,
			position = 0,
			rotation = 0,
			scale = 0,
			version = 0,
			headShape = 0,
			staticFacialAnimation = 0
		}
		local position = meta.position
		v6.position = position ~= nil and {
			x = position.X,
			y = position.Y,
			z = position.Z
		} or nil
		local rotation = meta.rotation
		v6.rotation = rotation ~= nil and {
			x = rotation.X,
			y = rotation.Y,
			z = rotation.Z
		} or nil
		local scale = meta.scale
		v6.scale = scale ~= nil and { x = scale.X, y = scale.Y, z = scale.Z } or nil
		v6.version = meta.version
		local v7 = if fFlagAXKeepHeadShapeInInventoryOutfitMeta then meta.headShape else nil
		v6.headShape = v7

		local v8 = if fFlagAXKeepHeadShapeInInventoryOutfitMeta then meta.staticFacialAnimation else nil
		v6.staticFacialAnimation = v8
	end

	return {
		id = asset.id,
		assetType = asset.assetType,
		meta = v6,
		supportsHeadShapes = asset.supportsHeadShapes
	}
end

local function collectHeadShapeSupportingAssets(outfitDetail, list)
	for k, asset in outfitDetail.assets do
		if asset.supportsHeadShapes ~= nil then
			table.insert(list, {
				id = asset.id,
				assetType = asset.assetType,
				supportsHeadShapes = asset.supportsHeadShapes
			})
		end
	end
end

local function getIsEditableOutfit(p2): boolean
	return p2 == inventoryOutfitType.Avatar or p2 == inventoryOutfitType.CreatedMakeup
end

local function getOutfitInfoFromInventoryItem(avatarInventoryItem, itemId)
	if not fFlagAXMigrateOutfitsToUserInventory then
		return nil
	end

	local outfitDetail = avatarInventoryItem.outfitDetail

	if outfitDetail == nil then
		return nil
	end

	local inventoryOutfitType2 = module17.InventoryTypeIdToInventoryOutfitType[tostring(avatarInventoryItem.itemCategory.itemSubType)]

	local v6 = {}

	for k, asset in outfitDetail.assets do
		table.insert(v6, normalizeOutfitDetailAsset(asset))
	end

	local background = outfitDetail.background
	local backgroundAsset = if background ~= nil then background.backgroundAsset else nil

	local v7 = fFlagAXBackgroundsOutfitPersistence
		and backgroundAsset ~= nil
		and backgroundAsset.id ~= nil
		and { backgroundAssetId = backgroundAsset.id }
		or nil
	local v8 = {
		playerAvatarType = outfitDetail.playerAvatarType,
		bodyColor3s = outfitDetail.bodyColor3s,
		scale = outfitDetail.scales,
		assets = v6,
		name = avatarInventoryItem.itemName,
		outfitType = inventoryOutfitType2 and module17.InventoryOutfitTypeToOutfitType[inventoryOutfitType2] or module17.OutfitTypes.Avatar,
		inventoryType = inventoryOutfitType2,
		isEditable = inventoryOutfitType2 == inventoryOutfitType.Avatar or inventoryOutfitType2 == inventoryOutfitType.CreatedMakeup,
		bundleId = 0,
		universeId = 0,
		profileConfiguration = 0
	}

	local v9 = if outfitDetail.linkedEntityType == "Bundle" then outfitDetail.linkedEntityId else nil
	v8.bundleId = v9
	v8.universeId = avatarInventoryItem.creatingUniverseId
	v8.profileConfiguration = v7

	local v10 = module13.fromWebApi(itemId, nil, v8)

	if v10.bundleId == "nil" then
		v10.bundleId = nil
	end

	v10.availabilityStatus = avatarInventoryItem.availabilityStatus or v10.availabilityStatus

	v10.receivedFromInventoryFetch = true
	return v10
end

local fn = fFlagAXInventoryDurablesExpiredFilter and function(p2, object, items)
	local v6 = {}

	for k, item in items do
		local v7 = nil

		if item.itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
			v7 = module17.ItemType.Asset
		elseif item.itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
			v7 = module17.ItemType.Bundle
		end

		if v7 then
			table.insert(v6, { id = tostring(item.itemId), itemType = v7 })
		end
	end

	if #v6 > 0 then
		object:dispatch(module20(p2, nil, v6, true))
	end
end or nil

local function filterModeratedPlusExclusiveBackgrounds(results)
	local avatarBackground = module17.AssetTypeIdStrings.AvatarBackground

	local v6 = {}

	for k, v7 in results.avatarInventoryItems or {} do
		local v8

		if v7.itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
			v8 = tostring(v7.itemCategory.itemSubType) == avatarBackground
		else
			v8 = false
		end

		local v9 = not (v7.creatingUniverseId == nil) and v7.creatingUniverseId > 0

		if
			not v8
			or v7.availabilityStatus == nil
			or v7.availabilityStatus == inventoryItemAvailability.Available
			or v7.isPlusExclusive == true
			or v9
		then
			table.insert(v6, v7)
		end
	end

	local clone = table.clone(results)
	clone.avatarInventoryItems = v6
	return clone
end

local function fn2(state)
	if fFlagAXReturnModeratedPlusExclusiveBackgrounds then
		state.results = filterModeratedPlusExclusiveBackgrounds(state.results)
	end

	local v6 = nil

	if module23() and state.categoryInventoryStore then
		if fFlagAXRefetchInventoryOnUpdate then
			v6 = state.categoryInventoryStore.isRefreshPending()
			state.categoryInventoryStore.addResultsPage(state.results, state.searchGeneration)
		else
			state.categoryInventoryStore.addResultsPage(state.results)
		end
	end

	local store = state.store
	local searchUuid = state.searchUuid
	local results = state.results
	local resolve = state.resolve

	local v7 = fFlagAXTTIEditorEnableMilestones

	if v7 then
		if
			state.shouldTrackTTI == true
			and state.ttiSessionGeneration ~= nil
			and editorInventoryTTIMilestoneManager ~= nil
		then
			v7 = state.ttiSessionGeneration == editorInventoryTTIMilestoneManager.getSessionGeneration()
		else
			v7 = false
		end
	end

	local state2 = store:getState()

	local avatarInventoryItems = results.avatarInventoryItems or {}

	if fFlagAXTTIEditorEnableMilestones and v7 and editorInventoryTTIMilestoneManager then
		editorInventoryTTIMilestoneManager.L2.primaryDataReady()
		editorInventoryTTIMilestoneManager.L3.getInventoryV2Completed()
	end

	local v8 = fFlagAXMigrateOutfitsToUserInventory and {} or nil
	local itemIds = {}
	local v9 = {}

	local itemIds2 = {}

	local outfitInfoFromInventoryItems = {}

	local itemIds3 = {}

	for k, avatarInventoryItem in avatarInventoryItems do
		local itemId = tostring(avatarInventoryItem.itemId)
		local itemCategory = avatarInventoryItem.itemCategory
		itemIds[#itemIds + 1] = itemId

		if itemCategory.itemType == Enum.AvatarItemType.Asset.Value then
			if not v6 then
				local assetInfo = state2.AvatarExperience.Common.AssetInfos[itemId]

				if assetInfo and assetInfo.receivedFromInventoryFetch then
					continue
				end
			end

			local creatingUniverseId = nil
			local availabilityStatus = avatarInventoryItem.availabilityStatus
			local v10

			if availabilityStatus then
				if avatarInventoryItem.creatingUniverseId then
					v10 = v5[availabilityStatus]
				else
					v10 = module6.getModerationStatusFromAvailabilityStatus(availabilityStatus)
				end
			end

			if avatarInventoryItem.creatingUniverseId then
				creatingUniverseId = tostring(avatarInventoryItem.creatingUniverseId)
			end

			local v11 = #v9 + 1
			local v12 = {
				assetId = avatarInventoryItem.itemId,
				name = avatarInventoryItem.itemName,
				assetType = module17.AssetTypeIdStringToName[tostring(itemCategory.itemSubType)],
				moderationStatus = v10,
				creatingUniverseId = creatingUniverseId,
				expirationTime = 0,
				isPlusExclusive = 0,
				license = 0
			}

			local v13 = if fFlagAXInventoryDurablesSupport then avatarInventoryItem.expirationTime else nil
			v12.expirationTime = v13
			local v14 = if fFlagAXBackgroundGeneration then avatarInventoryItem.isPlusExclusive else nil
			v12.isPlusExclusive = v14
			local v15 = if fFlagAXMarketplaceLicensing then avatarInventoryItem.license else nil
			v12.license = v15
			v9[v11] = v12
		elseif itemCategory.itemType == Enum.AvatarItemType.Bundle.Value then
			itemIds2[#itemIds2 + 1] = itemId
			local outfitInfo = state2.AvatarExperience.AvatarEditor.OutfitInfos[itemId]
			local v10

			if fFlagAXMigrateOutfitsToUserInventory then
				v10 = outfitInfo and outfitInfo.receivedFromInventoryFetch and true or false
			else
				v10 = outfitInfo ~= nil
			end

			if not v10 then
				if fFlagAXMigrateOutfitsToUserInventory then
					local outfitInfoFromInventoryItem = getOutfitInfoFromInventoryItem(avatarInventoryItem, itemId)

					if outfitInfoFromInventoryItem then
						table.insert(outfitInfoFromInventoryItems, outfitInfoFromInventoryItem)
						collectHeadShapeSupportingAssets(avatarInventoryItem.outfitDetail, v8)
					end
				elseif module22 then
					table.insert(itemIds3, itemId)
				else
					store:dispatch(module14(itemId, nil, nil, state.networkImpl))
				end
			end
		end
	end

	if fFlagAXTTIEditorEnableMilestones and v7 and editorInventoryTTIMilestoneManager then
		editorInventoryTTIMilestoneManager.L2.dataProcessingStarted()
	end

	if #v9 > 0 then
		store:dispatch(module11(v9))
	end

	checkAndSendDuplicateItemCount(state2, searchUuid, itemIds)

	if fFlagAXMigrateOutfitsToUserInventory then
		for k, v10 in outfitInfoFromInventoryItems do
			store:dispatch(module10(v10))
		end

		if #v8 > 0 then
			store:dispatch(module12(v8))
		end
	elseif module22 then
		store:dispatch(module15(itemIds3, state.networkImpl))
	end

	store:dispatch(module9(itemIds2, module16.OutfitOrAsset.Outfit))
	store:dispatch(module7(searchUuid, itemIds))

	if fFlagAXTTIEditorEnableMilestones and v7 and editorInventoryTTIMilestoneManager then
		editorInventoryTTIMilestoneManager.L2.dataProcessingCompleted()
	end

	if fFlagAXInventoryDurablesExpiredFilter and state.shouldFetchItemDetails then
		fn(state.networkImpl, store, avatarInventoryItems)
	end

	local reachedLastPage = nil

	if results then
		local nextPageToken = results.nextPageToken

		if nextPageToken and nextPageToken ~= "" then
			MemStorageService:SetItem(searchUuid, nextPageToken)
		else
			store:dispatch(module8(searchUuid, true))
			MemStorageService:SetItem(searchUuid, module16.ReachedLastPage)
			reachedLastPage = module16.ReachedLastPage
		end
	end

	resolve(reachedLastPage)
end

local function fetchItems(data)
	local v6 = {}

	if fFlagAXEnableInventorySearch and data.query ~= nil then
		local requestItemCategoriesFromInfo = getRequestItemCategoriesFromInfo(data.categoryInfo)

		if
			fFlagAXInventorySearchSendAllTabCategories
			and data.categoryInfo.NavigationKey == avatarEditorCategories.All
		then
			v6 = inventorySearchConstants.AllTabItemCategories
		elseif #requestItemCategoriesFromInfo > 0 then
			v6 = toSearchableItemCategories(requestItemCategoriesFromInfo)

			if #v6 == 0 then
				local v8 = {
					networkImpl = data.networkImpl,
					results = { avatarInventoryItems = {} },
					searchUuid = data.searchUuid,
					store = data.store,
					resolve = data.resolve,
					categoryInventoryStore = 0,
					searchGeneration = 0
				}
				local v9 = if module23() then data.categoryInventoryStore else nil
				v8.categoryInventoryStore = v9

				local v10 = if fFlagAXRefetchInventoryOnUpdate then data.searchGeneration else nil
				v8.searchGeneration = v10
				fn2(v8)

				return
			end
		end
	end

	local v7 = fIntAXDefaultInventoryPageSize
	local v8

	if module24() and data.sortAndFiltersStore then
		v8 = data.sortAndFiltersStore.getSortAndFilters(false)
	end

	local v9 = module24() and v8 and v8.sort == inventorySorts.RecentlyWorn and "recentEquipped"
		or "recentAdded"
	local v10, v11

	if fFlagAXInventoryDurablesExpiredFilter and module24() and v8 then
		v10 = inventoryFilterToAvailabilityStatus[v8.filter]
		v11 = not (v10 == nil)
	else
		v11 = nil
	end

	local v12 = fFlagAXTTIEditorEnableMilestones

	if v12 then
		v12 = not (data.nextPageCursor == nil) and data.nextPageCursor ~= ""
	end

	local v13 = fFlagAXTTIEditorEnableMilestones

	if v13 then
		v13 = data.trackTTI == true and not v12
	end

	local v14

	if fFlagAXTTIEditorEnableMilestones and v13 and editorInventoryTTIMilestoneManager then
		editorInventoryTTIMilestoneManager.startTracking({
			category = data.categoryInfo.Name
		})
		v14 = editorInventoryTTIMilestoneManager.getSessionGeneration()
		editorInventoryTTIMilestoneManager.L2.primaryDataStarted()
		editorInventoryTTIMilestoneManager.L3.networkFetch()
		editorInventoryTTIMilestoneManager.L3.getInventoryV2Started()
	else
		v14 = nil
	end

	local v15

	if fFlagAXEnableInventorySearch and data.query ~= nil then
		local searchUserAvatarInventory = module19.SearchUserAvatarInventory
		local networkImpl = data.networkImpl
		local v16 = {
			query = data.query,
			itemCategories = 0,
			sortOption = 0,
			pageLimit = 0,
			pageToken = 0
		}

		if not (#v6 > 0) then
			v6 = nil
		end

		v16.itemCategories = v6
		v16.sortOption = v9
		v16.pageLimit = v7
		v16.pageToken = data.nextPageCursor
		v15 = searchUserAvatarInventory(networkImpl, v16)
	else
		local getUserAvatarInventory = module19.GetUserAvatarInventory
		local networkImpl = data.networkImpl
		local requestItemCategoriesFromInfo = getRequestItemCategoriesFromInfo(data.categoryInfo)

		local nextPageCursor = data.nextPageCursor

		if not fFlagAXInventoryDurablesExpiredFilter then
			v10 = nil
		end

		v15 = getUserAvatarInventory(
			networkImpl,
			requestItemCategoriesFromInfo,
			v9,
			v7,
			nextPageCursor,
			v10
		)
	end

	return v15:andThen(function(p2)
		local responseBody = p2.responseBody
		local v17 = {
			networkImpl = data.networkImpl,
			results = responseBody,
			searchUuid = data.searchUuid,
			store = data.store,
			resolve = data.resolve,
			categoryInventoryStore = 0,
			shouldFetchItemDetails = 0,
			shouldTrackTTI = 0,
			ttiSessionGeneration = 0,
			searchGeneration = 0
		}
		local v18 = if module23() then data.categoryInventoryStore else nil
		v17.categoryInventoryStore = v18

		v17.shouldFetchItemDetails = if fFlagAXInventoryDurablesExpiredFilter then v11 else nil
		v17.shouldTrackTTI = if fFlagAXTTIEditorEnableMilestones then v13 else nil
		v17.ttiSessionGeneration = if fFlagAXTTIEditorEnableMilestones then v14 else nil
		local v22 = if fFlagAXRefetchInventoryOnUpdate then data.searchGeneration else nil
		v17.searchGeneration = v22
		fn2(v17)
	end):catch(function(p2)
		warn("GetUserInventoryV2 failure: ", p2)
		return data.reject()
	end)
end

return function(p2, p3, p4, data, p5, p6, p7)
	module2.isType(p3, "table", "GetUserInventoryV2 thunk expects categoryInfo to be a table")
	return function(object)
		if
			fFlagAXCustomizeBackgrounds
			and not fFlagAXBackgroundsCustomizeHydration
			and p3.NavigationKey == avatarEditorCategories.Backgrounds
		then
			object:dispatch(module8(p3.SearchUuid, true))
			MemStorageService:SetItem(p3.SearchUuid, module16.ReachedLastPage)

			if data then
				data.addResultsPage({ avatarInventoryItems = {} })
			end

			return Promise.resolve(module16.ReachedLastPage)
		else
			local state = object:getState()
			local getSearchUuidAndAssetTypes = module18.getSearchUuidAndAssetTypes

			local subButton = state.AvatarExperience.AvatarEditor.Categories.subButton
			local v7

			if fFlagAXEditorSubcategoryFilters then
				v7 = state.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
			end

			local searchUuidAndAssetTypes = getSearchUuidAndAssetTypes(p3, subButton, v7)

			if not searchUuidAndAssetTypes then
				return Promise.resolve("No SearchUuid")
			end

			if fFlagAXEnableInventorySearch and p7 ~= nil then
				searchUuidAndAssetTypes = getInventorySearchKey(searchUuidAndAssetTypes)
			end

			local v8 = if fFlagAXRefetchInventoryOnUpdate and data then data.getSearchUuid(false) else nil

			local v9 = if fFlagAXRefetchInventoryOnUpdate and data then data.isRefreshPending() else false
			local v10

			if
				v9
				and performFetch.GetStatus(state, searchUuidAndAssetTypes) == retrievalStatus.Fetching
				and v8
			then
				v10 = `{searchUuidAndAssetTypes}-{v8}`
			else
				v10 = searchUuidAndAssetTypes
			end

			return performFetch.Single(v10, function()
				local v11

				if module23() and data then
					v11 = data.nextPageCursor

					if data.getHasReachedLastPage(false) then
						return Promise.resolve(module16.ReachedLastPage)
					end
				else
					local v12 = searchUuidAndAssetTypes
					v11 = if v12 then MemStorageService:GetItem(v12) else nil

					if v11 == module16.ReachedLastPage then
						return Promise.resolve(module16.ReachedLastPage)
					end
				end

				return Promise.new(function(p8, p9)
					local v13 = {
						networkImpl = p2,
						searchUuid = searchUuidAndAssetTypes,
						categoryInfo = p3,
						store = object,
						resolve = p8,
						reject = p9,
						nextPageCursor = v11,
						categoryInventoryStore = 0,
						sortAndFiltersStore = 0,
						trackTTI = 0,
						searchGeneration = 0,
						query = 0
					}

					local v14 = if module23() then data else nil
					v13.categoryInventoryStore = v14

					local v15 = if module24() then p5 else nil
					v13.sortAndFiltersStore = v15

					v13.trackTTI = if fFlagAXTTIEditorEnableMilestones then p6 else nil
					v13.searchGeneration = v8
					v13.query = if fFlagAXEnableInventorySearch then p7 else nil
					fetchItems(v13)
				end)
			end)(object):catch(function(p8)
				if v9 and data and data.isRefreshPending() then
					data.startNewSearch()
				end

				module21("GetUserInventoryV2 fetch failed: ", p8)
			end)
		end
	end
end
