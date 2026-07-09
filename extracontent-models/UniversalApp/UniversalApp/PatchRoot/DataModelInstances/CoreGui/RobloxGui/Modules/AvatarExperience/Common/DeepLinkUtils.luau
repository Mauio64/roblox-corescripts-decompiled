local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(Modules.AvatarExperience.Common.Types)

local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories

require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local UnavailableItemFilter = require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)

require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
require(Modules.AvatarExperience.Common.Enum.SortType)
require(Modules.AvatarExperience.Common.Enum.SortAggregation)

local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.Reducers.ExternalNavigationRequest)

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local t1 = {
	parseSortType = function(p1) -- line: 46
		-- upvalues: CatalogConstants (copy)
		local num = tonumber(p1)

		for _, v21 in Enum.CatalogSortType:GetEnumItems() do
			if v21.Name:lower() == tostring(p1):lower() then
				return Enum.CatalogSortType[v21.Name].Name
			end

			if num and num == v21.Value then
				return Enum.CatalogSortType[v21.Name].Name
			end
		end

		return CatalogConstants.DefaultFilters.CatalogSort
	end,
	parseSortAggregation = function(p2) -- line: 68
		-- upvalues: CatalogConstants (copy)
		local num = tonumber(p2)

		for _, v25 in Enum.CatalogSortAggregation:GetEnumItems() do
			local v26 = v25.Name:lower() == tostring(p2):lower()
			local v27 = num and num == v25.Value
			local v28 = v25.Name == Enum.CatalogSortAggregation.AllTime.Name or (v25.Name == Enum.CatalogSortAggregation.PastWeek.Name or v25.Name == Enum.CatalogSortAggregation.PastDay.Name)

			if (v26 or v27) and v28 then
				return Enum.CatalogSortAggregation[v25.Name].Name
			end
		end

		return CatalogConstants.DefaultFilters.CatalogSortAggregation
	end,
	parseSalesTypeFilter = function(p3) -- line: 88
		-- upvalues: CatalogConstants (copy)
		local num = tonumber(p3)

		for _, v32 in Enum.SalesTypeFilter:GetEnumItems() do
			if v32.Name:lower() == tostring(p3):lower() then
				return Enum.SalesTypeFilter[v32.Name].Name
			end

			if num and num == v32.Value then
				return Enum.SalesTypeFilter[v32.Name].Name
			end
		end

		return CatalogConstants.DefaultFilters.SalesTypeFilter
	end
}

function t1.buildCatalogFilterFromDeepLinkParams(p4) -- line: 103
	-- upvalues: CatalogConstants (copy), t1 (copy), UnavailableItemFilter (copy)
	local t2 = {
		minPrice = CatalogConstants.DefaultFilters.PriceRange.minPrice,
		maxPrice = CatalogConstants.DefaultFilters.PriceRange.maxPrice
	}

	if p4.minPrice ~= nil then
		t2.minPrice = tonumber(p4.minPrice) or CatalogConstants.DefaultFilters.PriceRange.minPrice
	end

	if p4.maxPrice ~= nil then
		t2.maxPrice = tonumber(p4.maxPrice) or CatalogConstants.DefaultFilters.PriceRange.maxPrice
	end

	local v35 = t1.parseSalesTypeFilter(p4.salesTypeFilter)
	local v36 = p4.creatorName or ""
	local UnavailableItemFilter2 = CatalogConstants.DefaultFilters.UnavailableItemFilter

	if p4.includeNotForSale then
		UnavailableItemFilter2 = UnavailableItemFilter.Show
	end

	local v38 = t1.parseSortType(p4.sortType)
	local v39 = t1.parseSortAggregation(p4.sortAggregation)
	local v40 = tonumber(p4.category) or 1
	local v41 = tonumber(p4.subcategory) or 0
	local t3 = {}

	if p4.topics then
		for match in string.gmatch(p4.topics, "([^,]+)") do
			table.insert(t3, match)
		end
	end

	return {
		wearTimeFilter = nil,
		creatorFilter = v36,
		priceRange = t2,
		salesTypeFilter = v35,
		unavailableItemFilter = UnavailableItemFilter2,
		sortType = v38,
		sortAggregation = v39,
		category = v40,
		subcategory = v41,
		taxonomy = p4.taxonomy,
		topics = t3
	}
end

local function isCatalogScreen(s1: string) -- line: 163
	-- upvalues: AvatarScreen (copy)
	return s1 == AvatarScreen.Catalog or (s1 == AvatarScreen.CatalogSearch or s1 == AvatarScreen.ItemDetails)
end
local function isAvatarEditorScreen(s2: string) -- line: 167
	-- upvalues: AvatarScreen (copy)
	return s2 == AvatarScreen.AvatarEditor or s2 == AvatarScreen.OutfitDetails
end

function t1.catalogDeepLinkExists(p5) -- line: 172
	-- upvalues: AvatarScreen (copy)
	local screen = p5.screen

	if screen ~= AvatarScreen.Catalog and (screen ~= AvatarScreen.CatalogSearch and screen ~= AvatarScreen.ItemDetails) then
		return false
	end

	local v48 = p5.params or {}

	return v48.creatorName ~= nil or (v48.minPrice ~= nil or (v48.maxPrice ~= nil or (v48.salesTypeFilter ~= nil or (v48.includeNotForSale ~= nil or (v48.sortType ~= nil or (v48.sortAggregation ~= nil or (v48.category ~= nil or (v48.subcategory ~= nil or v48.taxonomy ~= nil))))))))
end
function t1.catalogDeepLinkExists_deprecated(p6) -- line: 189
	return p6.creatorName ~= nil or (p6.minPrice ~= nil or (p6.maxPrice ~= nil or (p6.salesTypeFilter ~= nil or (p6.includeNotForSale ~= nil or (p6.sortType ~= nil or (p6.sortAggregation ~= nil or (p6.category ~= nil or p6.subcategory ~= nil)))))))
end
function t1.avatarEditorDeepLinkExists(p7) -- line: 202
	-- upvalues: AvatarScreen (copy)
	if not p7.params or p7.params.opaquePage ~= AvatarScreen.AvatarEditor then
		local screen = p7.screen

		if screen ~= AvatarScreen.AvatarEditor and screen ~= AvatarScreen.OutfitDetails then
			return false
		end
	end

	local v52 = p7.params or {}

	return v52.category ~= nil or v52.subcategory ~= nil
end
function t1.newValidEquipDeepLinkExists(p8) -- line: 217
	-- upvalues: Constants (copy)
	if p8.wasItemEquipped or p8.fetchItemFailed then
		return false
	end

	if p8.itemId == nil or p8.itemType == nil then
		return false
	end

	if tonumber(p8.itemId) == nil then
		return false
	end

	if p8.itemType ~= Constants.ItemType.Asset:lower() and p8.itemType ~= Constants.ItemType.Bundle:lower() then
		return false
	end

	return true
end
function t1.parseItemSubType(s3: string, p9) -- line: 244
	-- upvalues: CatalogUtils (copy)
	return (CatalogUtils.GetItemSubType(s3, p9))
end
function t1.parseItemIdAndItemType(p10) -- line: 250
	-- upvalues: Constants (copy)
	local itemType = p10.itemType

	if itemType and p10.itemType:lower() == Constants.ItemType.Asset:lower() then
		itemType = Constants.ItemType.Asset
	elseif itemType and p10.itemType:lower() == Constants.ItemType.Bundle:lower() then
		itemType = Constants.ItemType.Bundle
	end

	return p10.itemId, itemType
end
function t1.wasItemFromDeepLinkEquipped(p11, p12) -- line: 265
	-- upvalues: AvatarScreen (copy)
	if p11 and (p11.wasItemEquipped and p12 and p12.opaque.name ~= AvatarScreen.Catalog) then
		return true
	end

	return false
end
function t1.removeDeepLinkEntries(p13) -- line: 281
	if p13 then
		for v61, v62 in p13 do
			if v62.fromDeepLink then
				table.remove(p13, v61)

				return
			end
		end
	end
end
function t1.isValidCategorySubtypeForEquippedItem(p14, p15) -- line: 297
	-- upvalues: FFlagAXRemoveCatalogCategoryNavKey (copy), Constants (copy), CatalogCategories (copy), Cryo (copy)
	local t4 = {}
	local n1 = 0

	if FFlagAXRemoveCatalogCategoryNavKey then
		if p14.Id == Constants.DefaultCatalogCategoryId then
			return true
		end
	elseif p14.NavigationKey == CatalogCategories.Recommended then
		return true
	end

	if p14.AssetTypeIdStrings then
		for _, v68 in p14.AssetTypeIdStrings do
			t4 = Cryo.Dictionary.join(t4, {
				[v68] = Constants.ItemType.Asset
			})
		end

		n1 += #p14.AssetTypeIdStrings
	end

	if p14.BundleTypes then
		for _, v70 in p14.BundleTypes do
			t4 = Cryo.Dictionary.join(t4, {
				[v70] = Constants.ItemType.Bundle
			})
		end

		n1 += #p14.BundleTypes
	end

	if n1 > 0 then
		return not not p15.itemSubType and (t4[p15.itemSubType] == p15.itemType or false)
	end

	return false
end
function t1.addEquippedItemToCatalogEntries(p16, p17, p18, t5: {[any]: any}) -- line: 341
	-- upvalues: t1 (copy), getTryOnItemReducerKey (copy)
	local v75, v76 = t1.parseItemIdAndItemType(p16)
	local v77 = if not v75 or not v76 then v75 else getTryOnItemReducerKey(v75, v76)
	local v78 = p17 and p17[v77] ~= nil
	local v79 = p17 and p17[v77]

	if v78 and (t5 and #t5 > 0 and v75 ~= t5[1].id) then
		t1.removeDeepLinkEntries(t5)

		if t1.isValidCategorySubtypeForEquippedItem(p18, v79) then
			table.insert(t5, 1, {
				fromDeepLink = true,
				id = v75,
				type = v76
			})

			return
		end
	elseif not v78 and t5 then
		t1.removeDeepLinkEntries(t5)
	end
end
function t1.convertCatalogSearchParamsV1ToV2(t6: {[any]: any}) -- line: 375
	local t7 = {}

	if not t6 or type(t6) ~= "table" then
		return t7
	end

	if t6.creatorname then
		t7.creatorName = t6.creatorname
	end

	return t7
end

return t1
