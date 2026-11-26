local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)

local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dPU")
require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local itemTileEnums = UIBlox.Tile.ItemTileEnums
local Dash = require(CorePackages.Packages.Dash)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local tutils = require(CorePackages.Packages.tutils)
local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/bundled/dFs")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module6 = require("@luauforge/bundled/dSV")
local module7 = require("@luauforge/bundled/dSW")

local module8 = require("@luauforge/bundled/dVp")
require("@luauforge/bundled/dQB")
require("@luauforge/bundled/dQN")

require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Reducers/CollectibleResellableInstances")
require("@luauforge/bundled/dQF")
require("@luauforge/bundled/dPs")
local constants = require("@luauforge/bundled/ciE").Utils.Constants
local module9 = require("@luauforge/bundled/dPN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local selectCurrentAvatarRoute = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.selectCurrentAvatarRoute

local module10 = require("@luauforge/bundled/dVq")

local module11 = require("@luauforge/bundled/dVr")
local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXFixLimitedUniqueResale = AvatarExperienceFlags.FFlagAXFixLimitedUniqueResale
local fFlagAXUseSignalsForAvatarsTabSearchInfo = AvatarExperienceFlags.FFlagAXUseSignalsForAvatarsTabSearchInfo
local getAvatarsTabSearchInfoStore

if fFlagAXUseSignalsForAvatarsTabSearchInfo then
	getAvatarsTabSearchInfoStore = AvatarExperienceCatalog.Stores.getAvatarsTabSearchInfoStore
else
	getAvatarsTabSearchInfoStore = nil
end

local v5 = {}

function v5.HasAttribution(p2): boolean
	if p2 and p2.creatingUniverseId then
		return true
	end

	return false
end

function v5.GetItemSubType(p2, p3)
	if not p3 then
		return
	end

	if p2 == module.ItemType.Asset then
		return p3.assetType
	end

	if p2 == module.ItemType.Bundle then
		return p3.bundleType
	end

	return nil
end

function v5.Round(p2)
	return (math.floor(p2 + 0.5))
end

function v5.bankersRounding(p2)
	local v6 = math.floor(p2)

	if p2 - v6 ~= 0.5 then
		return (math.round(p2))
	end

	if v6 % 2 == 0 then
		return v6
	end

	return v6 + 1
end

function v5.HasPremiumBenefits(p2): boolean
	if p2 then
		return p2.premiumPricing ~= nil
	end

	return false
end

function v5.IsResellable(data)
	if not data then
		return false
	end

	local numberRobloxHasAvailable = data.numberRobloxHasAvailable
	local v6 = if fFlagAXFixLimitedUniqueResale then data.isOffSale else nil
	local itemRestrictions = data.itemRestrictions
	local v7 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.Limited]
	local v8 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.LimitedUnique]
	local v9 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.Collectible]

	if v7 then
		v8 = v7
	elseif v9 then
		v8 = v9
	elseif v8 then
		if not fFlagAXFixLimitedUniqueResale then
			v6 = false
		end

		v8 = v6 or numberRobloxHasAvailable and numberRobloxHasAvailable == 0
	end

	return v8
end

function v5.isLimitedCollectible(p2)
	if p2 then
		return p2.itemRestrictions and p2.itemRestrictions[module2.ItemRestrictions.Collectible] or false
	end

	return false
end

function v5.hasLimitedQuantity(p2)
	if not p2 then
		return nil
	end

	local itemRestrictions = p2.itemRestrictions
	local v6 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.Limited]
	local v7 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.LimitedUnique]
	local v8 = itemRestrictions and itemRestrictions[module2.ItemRestrictions.Collectible]

	return v6 or v7 or v8
end

function v5.isUnlimitedCollectibleAsset(p2, p3)
	if not (p2 and p3) then
		return nil
	end

	local v6 = not v5.hasLimitedQuantity(p3)
	local v7 = p3.collectibleItemId and p3.collectibleItemId ~= ""
	local v8 = p2 and p2 == module.ItemType.Asset

	return v6 and v7 and v8
end

function v5.isLimitedBundle(p2, p3)
	if not (p2 and p3) then
		return nil
	end

	local limitedQuantity = v5.hasLimitedQuantity(p3)
	local v6 = p3.collectibleItemId and p3.collectibleItemId ~= ""
	local v7 = p2 and p2 == module.ItemType.Bundle

	return limitedQuantity and v6 and v7
end

function v5.isUnlimitedCollectibleBundle(p2, p3)
	if not (p2 and p3) then
		return nil
	end

	local v6 = not v5.hasLimitedQuantity(p3)
	local v7 = p3.collectibleItemId and p3.collectibleItemId ~= ""
	local v8 = p2 and p2 == module.ItemType.Bundle

	return v6 and v7 and v8
end

function v5.isOriginalStockSellableInShop(p2): boolean
	if not p2 then
		return true
	end

	local saleLocationType = p2.saleLocationType or module2.SaleLocationType.Invalid
	return saleLocationType == module2.SaleLocationType.ShopOnly
		or saleLocationType == module2.SaleLocationType.ShopAndMyExperiences
		or saleLocationType == module2.SaleLocationType.ShopAndAllExperiences
		or saleLocationType == module2.SaleLocationType.ShopAndExperiencesById
end

function v5.isCollectibleSellableInShop(data)
	if not data then
		return true
	end

	assert(data, "silence type checker")
	local originalStockSellableInShop = v5.isOriginalStockSellableInShop(data)

	local v6 = (data.unitsAvailableForConsumption or data.numberRobloxHasAvailable or 0) > 0

	local v7 = data.hasResellers

	if data.resaleRestriction == module2.ResaleRestriction.Disabled and not v6 then
		return false
	end

	local v8 = data.experiences and #data.experiences > 0

	if v6 then
		v7 = originalStockSellableInShop or v8 or v7
	end

	return v7
end

local function reachQuantityLimitInternal(p2, p3): boolean
	if not (p2 and p2.quantityLimitPerUser and p3) then
		return false
	end

	return p2.quantityLimitPerUser > 0 and tutils.fieldCount(p3) >= p2.quantityLimitPerUser
end

function v5.reachQuantityLimit(p2, p3): boolean
	if not (p2 and p2.quantityLimitPerUser and p3) then
		return false
	end

	return p2.quantityLimitPerUser > 0 and tutils.fieldCount(p3) >= p2.quantityLimitPerUser
end

function v5.shouldShowQuantityLimit(p2)
	return p2 and p2 > 0
end

function v5.GetRbxThumbType(p2)
	if p2 == module.ItemType.Asset then
		return constants.RbxthumbTypes.Asset
	end

	if p2 == module.ItemType.Bundle then
		return constants.RbxthumbTypes.BundleThumbnail
	end

	if p2 == module.ItemType.Look then
		return constants.RbxthumbTypes.Look
	end

	return nil
end

function v5.GetSponsoredItemsKey(p2, p3)
	return module2.SponsoredItemsDataKey .. "." .. tostring(p2) .. "." .. tostring(p3)
end

function v5.GetItemDetailsKey(p2, p3)
	if p2 and p3 then
		return module2.ItemDetailsKey .. p2 .. p3
	end

	return module2.ItemDetailsKey
end

function v5.GetBatchItemDetailsKey(list, p2)
	if list and p2 then
		return (module2.BatchItemDetailsKey .. p2) .. table.concat(list, ",")
	end

	return module2.BatchItemDetailsKey
end

function v5.getFetchWidgetInfoFetchKey(value, value2, value3)
	if fFlagAXPassScreenSizeToWidgetApi then
		return module2.FetchWidgetInfoKey .. (value or "") .. (value2 or "") .. (value3 or "")
	end

	return module2.FetchWidgetInfoKey .. (value or "") .. (value2 or "")
end

function v5.GetStatus(p2)
	if not p2 then
		return
	end

	local itemStatus = p2.itemStatus

	if not (itemStatus and #itemStatus ~= 0) then
		return
	end

	local set = {}

	for k, v6 in itemStatus do
		set[v6] = true
	end

	local info = nil
	local new = nil

	if set[module2.ItemStatus.Sale] then
		return itemTileEnums.StatusStyle.Alert, module2.ItemStatusLocale.Sale
	end

	if set[module2.ItemStatus.New] then
		info = itemTileEnums.StatusStyle.Info
		new = module2.ItemStatusLocale.New
	end

	return info, new
end

function v5.getIsTradable(p2): nil | boolean
	local itemRestrictions = p2 and p2.itemRestrictions

	if not itemRestrictions then
		return nil
	end

	if
		itemRestrictions[module2.ItemRestrictions.Limited]
		or itemRestrictions[module2.ItemRestrictions.LimitedUnique]
	then
		return true
	end

	if itemRestrictions[module2.ItemRestrictions.Collectible] then
		return false
	end

	return nil
end

v5.splitEntries = memoize(function(p2, p3, p4)
	local v6 = math.max(1, 1 + (p3 - 1) * p4)
	return Dash.slice(p2, 1, v6 - 1), (Dash.slice(p2, v6))
end)

function v5.getTopicRequestKey(list, p2, value)
	local v6 = not value and "" or `[{value or ""}]`

	if #list > 0 then
		local clone = table.clone(list)
		table.sort(clone)
		v6 ..= table.concat(clone, ",")
	end

	if #v6 > 0 then
		return v6
	end

	if p2 then
		return table.concat(Dash.map(p2, function(p3)
			return tostring(p3.itemType) .. tostring(p3.targetId)
		end))
	end

	return ""
end

local assetTypeIdStringSet = nil

local function assetTypeHasCatalogPage(assetTypeIdString): boolean
	local v6 = module6()

	for k, v7 in v6 do
		if v7.Subcategories then
			for k2, subcategory in v7.Subcategories do
				if not (subcategory.Name ~= "Community" and subcategory.AssetTypeIdStrings) then
					continue
				end

				for k3, assetTypeIdString2 in subcategory.AssetTypeIdStrings do
					if assetTypeIdString2 == assetTypeIdString then
						return true
					end
				end
			end
		elseif v7.AssetTypeIdStrings then
			for k2, assetTypeIdString2 in v7.AssetTypeIdStrings do
				if assetTypeIdString2 == assetTypeIdString then
					return true
				end
			end
		end
	end

	return false
end

function v5.doesAssetTypeHaveCatalogPage(p2): boolean
	if assetTypeIdStringSet then
		return assetTypeIdStringSet[p2] == true
	end

	assetTypeIdStringSet = {}

	for k, assetTypeIdString in module.AssetTypeIdStrings do
		if assetTypeHasCatalogPage(assetTypeIdString) then
			assetTypeIdStringSet[assetTypeIdString] = true
		end
	end

	return assetTypeIdStringSet[p2] == true
end

function v5.getRecommendedItemsGridItemTitleHeight(p2, value)
	return (p2.BaseSize * p2.Header2.RelativeSize + (value or 0)) * 2
end

v5.findCheapestCollectiblePurchaseInfo = memoize(function(p2, p3, p4, p5)
	local v6 = {}

	if not p2 then
		return v6
	end

	assert(p2, "silence type checker")

	local v7 = p3[p2]

	if not (v7 and v7.unitsAvailableForConsumption and v7.price) then
		return v6
	end

	local v8 = not module10() or v5.isOriginalStockSellableInShop(v7)
	local v9

	if v7.quantityLimitPerUser and p5 and p5[p2] then
		local v10 = p5[p2]

		if v7 and v7.quantityLimitPerUser and v10 and v7.quantityLimitPerUser > 0 then
			v9 = tutils.fieldCount(v10) >= v7.quantityLimitPerUser
		else
			v9 = false
		end
	else
		v9 = false
	end

	if v8 and not v9 and v7.unitsAvailableForConsumption > 0 then
		v6.price = v7.price
	end

	local v10 = p4[p2]

	if v10 and #v10.InstanceIdsList > 0 then
		local instanceId = v10.InstanceIdsList[1]
		local instance = v10.Instances[instanceId]

		if not v8 or v7.unitsAvailableForConsumption == 0 or instance.price < v6.price or v9 then
			v6.collectibleInstanceId = instance.collectibleInstanceId
			v6.price = instance.price
			v6.expectedSellerId = instance.seller.sellerId
			v6.sellerName = instance.seller.name
		end
	end

	return v6
end)

function v5.findCheapestCollectiblePurchaseInfoV2(p2, p3, p4, p5, p6)
	local v6 = {}

	if not p2 then
		return v6
	end

	assert(p2, "silence type checker")

	local v7 = p4[p2]

	if v7 and not p3 then
		v6.price = v7.price
		return v6
	end

	return (v5.findCheapestCollectiblePurchaseInfo(p2, p4, p5, p6))
end

function v5.getQueryStringForSearchWidgets(p2)
	if not (p2 and p2.searchKeyword) then
		return nil
	end

	local v6 = { p2.searchKeyword }

	if p2.sortAndFilters and p2.sortAndFilters.SelectedTopics then
		for k, selectedTopic in p2.sortAndFilters.SelectedTopics do
			table.insert(v6, 1, selectedTopic)
		end
	end

	return table.concat(v6, " ")
end

function v5.getCategoryName(p2)
	assert(t.number(p2), "Expected categoryIndex to be a number")

	local v6 = module6()[p2]
	return v6 and v6.Name
end

function v5.getCategoryId(p2)
	return module8()[p2]
end

function v5.extractCategoryById(p2, items)
	assert(t.string(p2), "Expected categoryId to be a string")

	for k, item in items do
		if item.Id == p2 then
			return item
		end
	end

	return nil
end

function v5.extractSubcategoryById(p2, items)
	assert(t.string(p2), "Expected subcategoryId to be a string")

	for k, item in items do
		if item.Id == p2 then
			return item
		end
	end

	return nil
end

function v5.findCategoryByCategoryId(p2, items)
	if not p2 then
		return nil
	end

	for k, item in items do
		if item.CategoryId == p2 then
			return item
		end
	end

	return nil
end

function v5.findSubcategoryBySubcategoryId(p2, items)
	if not p2 then
		return nil
	end

	for k, item in items do
		if item.SubcategoryId == p2 then
			return item
		end
	end

	return nil
end

function v5.findCategoryIdsByTaxonomy(value, items)
	if not value then
		return nil, nil
	end

	for k, item in items do
		if item.TaxonomyUuid and string.lower(item.TaxonomyUuid) == string.lower(value) then
			return item.Id, nil
		end

		if not item.Subcategories then
			continue
		end

		for k2, subcategory in item.Subcategories do
			if
				subcategory.TaxonomyUuid
				and string.lower(subcategory.TaxonomyUuid) == string.lower(value)
			then
				return item.Id, subcategory.Id
			end
		end
	end

	return nil, nil
end

function v5.getCategoryNameById(p2)
	local categoryId = v5.getCategoryId(p2)
	return categoryId and categoryId.Name
end

function v5.getSubcategoryId(p2, p3)
	assert(t.tuple(t.string, t.string)(p2, p3), "Expected categoryId and subcategoryId to be strings")

	local categoryId = v5.getCategoryId(p2)
	local subcategoryId

	if categoryId and categoryId.SubcategoriesMap then
		subcategoryId = categoryId.SubcategoriesMap[p3]
	end

	return subcategoryId
end

function v5.getSubcategoryNameById(p2, p3)
	local subcategoryId = v5.getSubcategoryId(p2, p3)
	return subcategoryId and subcategoryId.Name
end

function v5.getSubcategoryNameByIdWithErrorLogging(p2, p3)
	local subcategoryNameById = v5.getSubcategoryNameById(p2, p3)

	if module11() and p2 and p3 and not subcategoryNameById then
		module3("getSubcategoryNameById returned nil for subcategoryId: " .. p3 .. " and categoryId: " .. p2)
	end

	return subcategoryNameById
end

function v5.findCategoryIndexById(items, p2)
	for k, item in items do
		if item.Id == p2 then
			return k
		end
	end

	return nil
end

function v5.getSubcategoryName(p2, p3)
	assert(t.tuple(t.number, t.number)(p2, p3), "Expected categoryIndex and subcategoryIndex to be numbers")

	local v6 = module6()[p2]
	local name

	if v6 then
		local v7 = v6.Subcategories and v6.Subcategories[p3]
		name = v7 and v7.Name
	end

	return name
end

function v5.getCurrentCategoryNames(p2)
	if not (p2 and p2.AvatarExperience and p2.AvatarExperience.Catalog) then
		return nil
	end

	local v6 = {}

	local catalogSelectionStore = module7.getCatalogSelectionStore()
	local selectedCategoryId = catalogSelectionStore.selectedCategoryId(false)
	local selectedSubcategoryId = catalogSelectionStore.selectedSubcategoryId(false)

	if selectedCategoryId then
		v6.catalogCategory = v5.getCategoryNameById(selectedCategoryId)

		if selectedSubcategoryId then
			v6.catalogSubcategory = v5.getSubcategoryNameByIdWithErrorLogging(
				selectedCategoryId,
				selectedSubcategoryId
			)
		else
			v6.catalogSubcategory = nil
		end
	end

	local catalogSearchSelectionStore = module7.getCatalogSearchSelectionStore()
	local selectedCategoryId2 = catalogSearchSelectionStore.selectedCategoryId(false)
	local selectedSubcategoryId2 = catalogSearchSelectionStore.selectedSubcategoryId(false)

	if not selectedCategoryId2 then
		return v6
	end

	v6.catalogSearchCategory = v5.getCategoryNameById(selectedCategoryId2)

	if selectedSubcategoryId2 then
		v6.catalogSearchSubcategory = v5.getSubcategoryNameByIdWithErrorLogging(
			selectedCategoryId2,
			selectedSubcategoryId2
		)
		return v6
	end

	v6.catalogSearchSubcategory = nil

	return v6
end

function v5.getContextStringForWidgets(list)
	assert(t.array(t.string)(list))

	local joined = table.concat(list, ":")

	local v6 = string.gsub(joined, " ", "-")

	local v7 = string.gsub(v6, "%.", "-")

	return (string.lower(v7))
end

function v5.getContextForWidgetsById(p2, p3, p4)
	assert(
		t.tuple(t.string, t.string, t.optional(t.string))(p2, p3, p4),
		"Expected pageName to be a string, categoryId to be a string, and subcategoryId to be a string or nil"
	)

	if not table.find(module9.ContextWidgetsAllowedRoutes, p2) then
		return nil
	end

	local v6 = module9.AnalyticsContext[p2]
	local categoryNameById = v5.getCategoryNameById(p3)

	if not (v6 and categoryNameById) then
		return nil
	end

	local v7 = { `{v6}-tab` }

	table.insert(v7, categoryNameById)

	if not p4 then
		return v5.getContextStringForWidgets(v7)
	end

	local subcategoryNameByIdWithErrorLogging = v5.getSubcategoryNameByIdWithErrorLogging(p3, p4)

	if subcategoryNameByIdWithErrorLogging then
		table.insert(v7, subcategoryNameByIdWithErrorLogging)
	end

	if p4 and not subcategoryNameByIdWithErrorLogging then
		return nil
	end

	return v5.getContextStringForWidgets(v7)
end

function v5.getCategoryAndSubcategory(p2)
	local currentCategoryNames = v5.getCurrentCategoryNames(p2)
	local v6 = selectCurrentAvatarRoute(p2)
	local v7 = v6 and v6.name == avatarScreen.CatalogSearch
	local catalogCategory = nil
	local catalogSubcategory = nil

	if not currentCategoryNames then
		return catalogCategory, catalogSubcategory
	end

	if v7 then
		return
			currentCategoryNames.catalogSearchCategory or catalogCategory,
			currentCategoryNames.catalogSearchSubcategory or catalogSubcategory
	end

	catalogCategory = currentCategoryNames.catalogCategory or catalogCategory
	catalogSubcategory = currentCategoryNames.catalogSubcategory or catalogSubcategory

	return catalogCategory, catalogSubcategory
end

function v5.removeItemFootersFromConfigs(p2, p3, p4, p5, p6)
	local function removeEntriesFromItemFooters(list)
		local function removeEntryFromItemFooter(p7)
			local v6 = nil

			for k, item in list do
				if item.contentType == p7 then
					v6 = k
				end

				if v6 then
					table.remove(list, v6)
				end
			end
		end

		if p4 then
			removeEntryFromItemFooter("ItemName")
		end

		if p5 then
			removeEntryFromItemFooter("AgentName")
		end

		if p6 then
			removeEntryFromItemFooter("Price")
		end
	end

	local copy = tutils.deepCopy(p2)
	local copy2 = tutils.deepCopy(p3)

	if copy2 and copy2.template and copy2.template.itemFooters then
		local itemFooters = copy2.template.itemFooters

		local function removeEntryFromItemFooter(p7)
			local v6 = nil

			for k, itemFooter in itemFooters do
				if itemFooter.contentType == p7 then
					v6 = k
				end

				if v6 then
					table.remove(itemFooters, v6)
				end
			end
		end

		if p4 then
			removeEntryFromItemFooter("ItemName")
		end

		if p5 then
			removeEntryFromItemFooter("AgentName")
		end

		if p6 then
			removeEntryFromItemFooter("Price")
		end
	end

	if copy and copy.defaultItemGroupTemplate and copy.defaultItemGroupTemplate.itemFooters then
		local itemFooters = copy.defaultItemGroupTemplate.itemFooters

		local function removeEntryFromItemFooter(p7)
			local v6 = nil

			for k, itemFooter in itemFooters do
				if itemFooter.contentType == p7 then
					v6 = k
				end

				if v6 then
					table.remove(itemFooters, v6)
				end
			end
		end

		if p4 then
			removeEntryFromItemFooter("ItemName")
		end

		if p5 then
			removeEntryFromItemFooter("AgentName")
		end

		if p6 then
			removeEntryFromItemFooter("Price")
		end
	end

	if copy and copy.defaultItemCarouselTemplate and copy.defaultItemCarouselTemplate.itemFooters then
		local itemFooters = copy.defaultItemCarouselTemplate.itemFooters

		local function removeEntryFromItemFooter(p7)
			local v6 = nil

			for k, itemFooter in itemFooters do
				if itemFooter.contentType == p7 then
					v6 = k
				end

				if v6 then
					table.remove(itemFooters, v6)
				end
			end
		end

		if p4 then
			removeEntryFromItemFooter("ItemName")
		end

		if p5 then
			removeEntryFromItemFooter("AgentName")
		end

		if p6 then
			removeEntryFromItemFooter("Price")
		end
	end

	if copy and copy.customizedDataMap and copy.customizedDataMap.creatorNameTileFooterEnabled and p5 then
		copy.customizedDataMap.creatorNameTileFooterEnabled = false
	end

	return copy, copy2
end

function v5.getAvatarsTabAnalyticsInfo(p2)
	local currentCategoryNames = v5.getCurrentCategoryNames(p2)
	local name = p2.AvatarExperience.AvatarScene.AvatarRoute.opaque.name
	local v6 = nil
	local v7 = nil
	local v8, v9

	if name == avatarScreen.CatalogSearch then
		if fFlagAXUseSignalsForAvatarsTabSearchInfo then
			v6 = getAvatarsTabSearchInfoStore(false).getKeyword(false)
		else
			v6 = p2.AvatarExperience.Catalog.AvatarsTabSearchInfo.keyword
		end

		if fFlagAXUseSignalsForAvatarsTabSearchInfo then
			v7 = getAvatarsTabSearchInfoStore(false).getSearchUuid(false)
		else
			v7 = p2.AvatarExperience.Catalog.AvatarsTabSearchInfo.searchUuid
		end

		v8 = currentCategoryNames and currentCategoryNames.catalogSearchCategory
		v9 = currentCategoryNames and currentCategoryNames.catalogSearchSubcategory
	else
		v8 = currentCategoryNames and currentCategoryNames.catalogCategory
		v9 = currentCategoryNames and currentCategoryNames.catalogSubcategory
	end

	return v6, v8, v9, v7, name
end

return v5
