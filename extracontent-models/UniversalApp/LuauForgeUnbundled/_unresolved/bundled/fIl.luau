local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
require("@luauforge/bundled/dKU")

require("@luauforge/bundled/dPs")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

require("@luauforge/bundled/dPD")
local module3 = require("@luauforge/bundled/dPU")
local module4 = require("@luauforge/bundled/dVl")
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/bundled/dPE")
require("@luauforge/bundled/dPF")
require("@luauforge/bundled/dPG")
require("@luauforge/bundled/dPH")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/bundled/dPz")
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local fFlagAXCatalogHttpLinkSalesTypeFilter = AvatarExperienceFlags.FFlagAXCatalogHttpLinkSalesTypeFilter

local v5 = {}

function v5.parseSortType(p2)
	local v6 = tonumber(p2)

	for k, v7 in Enum.CatalogSortType:GetEnumItems() do
		if v7.Name:lower() == tostring(p2):lower() or v6 and v7.Value == v6 then
			return Enum.CatalogSortType[v7.Name].Name
		end
	end

	return module3.DefaultFilters.CatalogSort
end

function v5.parseSortAggregation(p2)
	local v6 = tonumber(p2)

	for k, v7 in Enum.CatalogSortAggregation:GetEnumItems() do
		local v8 = v7.Name:lower() == tostring(p2):lower()
		local v9 = v6 and v7.Value == v6
		local v10 = v7.Name == Enum.CatalogSortAggregation.AllTime.Name
			or v7.Name == Enum.CatalogSortAggregation.PastWeek.Name
			or v7.Name == Enum.CatalogSortAggregation.PastDay.Name

		if (v8 or v9) and v10 then
			return Enum.CatalogSortAggregation[v7.Name].Name
		end
	end

	return module3.DefaultFilters.CatalogSortAggregation
end

function v5.parseSalesTypeFilter(p2)
	local v6 = tonumber(p2)

	for k, v7 in Enum.SalesTypeFilter:GetEnumItems() do
		if v7.Name:lower() == tostring(p2):lower() or v6 and v7.Value == v6 then
			return Enum.SalesTypeFilter[v7.Name].Name
		end
	end

	return module3.DefaultFilters.SalesTypeFilter
end

function v5.buildCatalogFilterFromDeepLinkParams(data)
	local v6 = {
		minPrice = module3.DefaultFilters.PriceRange.minPrice,
		maxPrice = module3.DefaultFilters.PriceRange.maxPrice
	}

	if data.minPrice ~= nil then
		v6.minPrice = tonumber(data.minPrice) or module3.DefaultFilters.PriceRange.minPrice
	end

	if data.maxPrice ~= nil then
		v6.maxPrice = tonumber(data.maxPrice) or module3.DefaultFilters.PriceRange.maxPrice
	end

	local salesTypeFilter = v5.parseSalesTypeFilter(data.salesTypeFilter)

	local creatorName = data.creatorName or ""

	local v7 = module3.DefaultFilters.UnavailableItemFilter

	if data.includeNotForSale then
		v7 = module6.Show
	end

	local sortType = v5.parseSortType(data.sortType)

	local sortAggregation = v5.parseSortAggregation(data.sortAggregation)

	local category = tonumber(data.category) or 1
	local subcategory = tonumber(data.subcategory) or 0

	local v8 = {}

	if data.topics then
		for k in string.gmatch(data.topics, "([^,]+)") do
			table.insert(v8, k)
		end
	end

	return {
		creatorFilter = creatorName,
		priceRange = v6,
		salesTypeFilter = salesTypeFilter,
		unavailableItemFilter = v7,
		sortType = sortType,
		sortAggregation = sortAggregation,
		category = category,
		subcategory = subcategory,
		taxonomy = data.taxonomy,
		topics = v8,
		wearTimeFilter = nil
	}
end

local function isCatalogScreen(p2): boolean
	return p2 == avatarScreen.Catalog or p2 == avatarScreen.CatalogSearch or p2 == avatarScreen.ItemDetails
end

local function isAvatarEditorScreen(p2): boolean
	return p2 == avatarScreen.AvatarEditor or p2 == avatarScreen.OutfitDetails
end

function v5.catalogDeepLinkExists(p2): boolean
	local screen = p2.screen

	if
		screen ~= avatarScreen.Catalog
		and screen ~= avatarScreen.CatalogSearch
		and screen ~= avatarScreen.ItemDetails
	then
		return false
	end

	local params = p2.params or {}
	return params.creatorName ~= nil
		or params.minPrice ~= nil
		or params.maxPrice ~= nil
		or params.salesTypeFilter ~= nil
		or params.includeNotForSale ~= nil
		or params.sortType ~= nil
		or params.sortAggregation ~= nil
		or params.category ~= nil
		or params.subcategory ~= nil
		or params.taxonomy ~= nil
end

function v5.catalogDeepLinkExists_deprecated(data): boolean
	return data.creatorName ~= nil
		or data.minPrice ~= nil
		or data.maxPrice ~= nil
		or data.salesTypeFilter ~= nil
		or data.includeNotForSale ~= nil
		or data.sortType ~= nil
		or data.sortAggregation ~= nil
		or data.category ~= nil
		or data.subcategory ~= nil
end

function v5.avatarEditorDeepLinkExists(p2): boolean
	if not p2.params or p2.params.opaquePage ~= avatarScreen.AvatarEditor then
		local screen = p2.screen

		if screen ~= avatarScreen.AvatarEditor and screen ~= avatarScreen.OutfitDetails then
			return false
		end
	end

	local params = p2.params or {}
	return params.category ~= nil or params.subcategory ~= nil
end

function v5.newValidEquipDeepLinkExists(data): boolean
	if data.wasItemEquipped or data.fetchItemFailed or (data.itemId == nil or data.itemType == nil) then
		return false
	end

	if tonumber(data.itemId) == nil then
		return false
	end

	return data.itemType == module5.ItemType.Asset:lower()
		or data.itemType == module5.ItemType.Bundle:lower()
end

function v5.parseItemSubType(p2, p3)
	return (module4.GetItemSubType(p2, p3))
end

function v5.parseItemIdAndItemType(p2)
	local v6 = p2.itemType

	if v6 and p2.itemType:lower() == module5.ItemType.Asset:lower() then
		v6 = module5.ItemType.Asset
	elseif v6 and p2.itemType:lower() == module5.ItemType.Bundle:lower() then
		v6 = module5.ItemType.Bundle
	end

	return p2.itemId, v6
end

function v5.wasItemFromDeepLinkEquipped(p2, p3): boolean
	if p2 and p2.wasItemEquipped and p3 and p3.opaque.name ~= avatarScreen.Catalog then
		return true
	end

	return false
end

function v5.removeDeepLinkEntries(list)
	if list then
		for k, item in list do
			if item.fromDeepLink then
				table.remove(list, k)
				return
			end
		end
	end
end

function v5.isValidCategorySubtypeForEquippedItem(data, p2)
	local joined = {}
	local total = 0

	if data.Id == module5.DefaultCatalogCategoryId then
		return true
	end

	if data.AssetTypeIdStrings then
		for k, assetTypeIdString in data.AssetTypeIdStrings do
			joined = Cryo.Dictionary.join(joined, {
				[assetTypeIdString] = module5.ItemType.Asset
			})
		end

		total += #data.AssetTypeIdStrings
	end

	if data.BundleTypes then
		for k, bundleType in data.BundleTypes do
			joined = Cryo.Dictionary.join(joined, {
				[bundleType] = module5.ItemType.Bundle
			})
		end

		total += #data.BundleTypes
	end

	if total > 0 then
		return p2.itemSubType and joined[p2.itemSubType] == p2.itemType and true or false
	end

	return false
end

function v5.addEquippedItemToCatalogEntries(p2, p3, p4, list)
	local itemIdAndItemType, v6 = v5.parseItemIdAndItemType(p2)
	local v7

	if itemIdAndItemType and v6 then
		v7 = getTryOnItemReducerKey(itemIdAndItemType, v6)
	else
		v7 = itemIdAndItemType
	end

	local v8 = p3 and p3[v7] ~= nil
	local v9 = p3 and p3[v7]

	if v8 and list and #list > 0 and list[1].id ~= itemIdAndItemType then
		v5.removeDeepLinkEntries(list)

		if v5.isValidCategorySubtypeForEquippedItem(p4, v9) then
			table.insert(list, 1, {
				id = itemIdAndItemType,
				type = v6,
				fromDeepLink = true
			})
		end
	elseif not v8 and list then
		v5.removeDeepLinkEntries(list)
	end
end

function v5.convertCatalogSearchParamsV1ToV2(p2)
	local v6 = {}

	if not p2 or type(p2) ~= "table" then
		return v6
	end

	if p2.creatorname then
		v6.creatorName = p2.creatorname
	end

	if fFlagAXCatalogHttpLinkSalesTypeFilter and p2.salestypefilter then
		v6.salesTypeFilter = p2.salestypefilter
	end

	return v6
end

return v5
