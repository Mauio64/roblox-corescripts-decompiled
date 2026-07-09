local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(Modules.AvatarExperience.Catalog.Http.WebApi)

local ItemTileEnums = UIBlox.Tile.ItemTileEnums
local Dash = require(CorePackages.Packages.Dash)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local tutils = require(CorePackages.Packages.tutils)
local t = require(CorePackages.Packages.t)
local mutedError = require(Modules.LuaApp.mutedError)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local GetCatalogCategoriesFromStore = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesFromStore)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local GetCatalogCategoriesMap = require(Modules.AvatarExperience.Catalog.GetCatalogCategoriesMap)

require(Modules.AvatarExperience.Common.Reducers.CollectiblesItemInfo)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellersInstances)
require(Modules.AvatarExperience.Common.Reducers.CollectiblesResellableInstances)
require(Modules.AvatarExperience.Common.Models.CollectibleInfo)
require(Modules.AvatarExperience.Common.Types)

local Constants2 = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local Constants3 = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local selectCurrentAvatarRoute = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Selectors.selectCurrentAvatarRoute
local GetFFlagCollectiblesCatalogFollowUpForSaleLocation = require(Modules.AvatarExperience.Flags.GetFFlagCollectiblesCatalogFollowUpForSaleLocation)
local GetFFlagAXEnableErrorLoggingForSubcategorySelectionById = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableErrorLoggingForSubcategorySelectionById)
local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local t2 = {
	HasAttribution = function(t1: {[any]: any}?) -- line: 57
		if not t1 or not t1.creatingUniverseId then
			return false
		end

		return true
	end,
	GetItemSubType = function(s1: string?, p1) -- line: 64
		-- upvalues: Constants (copy)
		if not p1 then
			return
		end

		if s1 == Constants.ItemType.Asset then
			return p1.assetType
		end

		if s1 == Constants.ItemType.Bundle then
			return p1.bundleType
		end

		return nil
	end,
	Round = function(p2) -- line: 77
		return (math.floor(p2 + 0.5))
	end,
	bankersRounding = function(p3) -- line: 83
		local v33 = math.floor(p3)

		if p3 - v33 == 0.5 then
			if v33 % 2 == 0 then
				return v33
			end

			return v33 + 1
		end

		return (math.round(p3))
	end,
	HasPremiumBenefits = function(p4) -- line: 94
		if not p4 then
			return false
		end

		return p4.premiumPricing ~= nil
	end,
	IsResellable = function(p5) -- line: 102
		-- upvalues: CatalogConstants (copy)
		if not p5 then
			return false
		end

		local numberRobloxHasAvailable = p5.numberRobloxHasAvailable
		local itemRestrictions = p5.itemRestrictions
		local v38 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
		local v39 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
		local v40 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]

		return v38 or (v40 or v39 and (numberRobloxHasAvailable and numberRobloxHasAvailable == 0))
	end,
	isLimitedCollectible = function(p6) -- line: 117
		-- upvalues: CatalogConstants (copy)
		if not p6 then
			return false
		end

		return not not p6.itemRestrictions and (p6.itemRestrictions[CatalogConstants.ItemRestrictions.Collectible] or false)
	end,
	hasLimitedQuantity = function(p7) -- line: 126
		-- upvalues: CatalogConstants (copy)
		if not p7 then
			return nil
		end

		local itemRestrictions = p7.itemRestrictions
		local v44 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Limited]
		local v45 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.LimitedUnique]
		local v46 = itemRestrictions and itemRestrictions[CatalogConstants.ItemRestrictions.Collectible]

		return v44 or (v45 or v46)
	end
}

function t2.isUnlimitedCollectibleAsset(s2: string?, p8) -- line: 139
	-- upvalues: t2 (copy), Constants (copy)
	if not s2 or not p8 then
		return nil
	end

	local v49 = t2.hasLimitedQuantity(p8)
	local v50 = p8.collectibleItemId and p8.collectibleItemId ~= ""
	local v51 = s2 and s2 == Constants.ItemType.Asset

	return not v49 and (v50 and v51)
end
function t2.isLimitedBundle(s3: string?, p9) -- line: 151
	-- upvalues: t2 (copy), Constants (copy)
	if not s3 or not p9 then
		return nil
	end

	local v54 = t2.hasLimitedQuantity(p9)
	local v55 = p9.collectibleItemId and p9.collectibleItemId ~= ""
	local v56 = s3 and s3 == Constants.ItemType.Bundle

	return v54 and (v55 and v56)
end
function t2.isUnlimitedCollectibleBundle(s4: string?, p10) -- line: 163
	-- upvalues: t2 (copy), Constants (copy)
	if not s4 or not p10 then
		return nil
	end

	local v59 = t2.hasLimitedQuantity(p10)
	local v60 = p10.collectibleItemId and p10.collectibleItemId ~= ""
	local v61 = s4 and s4 == Constants.ItemType.Bundle

	return not v59 and (v60 and v61)
end
function t2.isOriginalStockSellableInShop(p11) -- line: 177
	-- upvalues: CatalogConstants (copy)
	if p11 then
		local v63 = p11.saleLocationType or CatalogConstants.SaleLocationType.Invalid

		return v63 == CatalogConstants.SaleLocationType.ShopOnly or (v63 == CatalogConstants.SaleLocationType.ShopAndMyExperiences or (v63 == CatalogConstants.SaleLocationType.ShopAndAllExperiences or v63 == CatalogConstants.SaleLocationType.ShopAndExperiencesById))
	end

	return true
end
function t2.isCollectibleSellableInShop(p12) -- line: 193
	-- upvalues: t2 (copy), CatalogConstants (copy)
	if not p12 then
		return true
	end

	assert(p12, "silence type checker")

	local v65 = t2.isOriginalStockSellableInShop(p12)
	local v66 = (p12.unitsAvailableForConsumption or (p12.numberRobloxHasAvailable or 0)) > 0
	local hasResellers = p12.hasResellers

	if p12.resaleRestriction == CatalogConstants.ResaleRestriction.Disabled and not v66 then
		return false
	end

	local v68 = p12.experiences and #p12.experiences > 0

	return v66 and (v65 or v68) or hasResellers
end

local function reachQuantityLimitInternal(p13, p14) -- line: 219
	-- upvalues: tutils (copy)
	if not p13 or (not p13.quantityLimitPerUser or not p14) then
		return false
	end

	return p13.quantityLimitPerUser > 0 and tutils.fieldCount(p14) >= p13.quantityLimitPerUser
end

function t2.reachQuantityLimit(p15, p16) -- line: 227
	-- upvalues: tutils (copy)
	if not p15 or (not p15.quantityLimitPerUser or not p16) then
		return false
	end

	return p15.quantityLimitPerUser > 0 and tutils.fieldCount(p16) >= p15.quantityLimitPerUser
end
function t2.shouldShowQuantityLimit(p17) -- line: 231
	return p17 and p17 > 0
end
function t2.GetRbxThumbType(p18) -- line: 235
	-- upvalues: Constants (copy), Constants2 (copy)
	if p18 == Constants.ItemType.Asset then
		return Constants2.RbxthumbTypes.Asset
	end

	if p18 == Constants.ItemType.Bundle then
		return Constants2.RbxthumbTypes.BundleThumbnail
	end

	if p18 == Constants.ItemType.Look then
		return Constants2.RbxthumbTypes.Look
	end

	return nil
end
function t2.GetSponsoredItemsKey(p19, n1: number?) -- line: 247
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.SponsoredItemsDataKey .. "." .. tostring(p19) .. "." .. tostring(n1)
end
function t2.GetItemDetailsKey(p20, p21) -- line: 251
	-- upvalues: CatalogConstants (copy)
	if not p20 or not p21 then
		return CatalogConstants.ItemDetailsKey
	end

	return CatalogConstants.ItemDetailsKey .. p20 .. p21
end
function t2.GetBatchItemDetailsKey(p22, p23) -- line: 258
	-- upvalues: CatalogConstants (copy)
	if not p22 or not p23 then
		return CatalogConstants.BatchItemDetailsKey
	end

	return (CatalogConstants.BatchItemDetailsKey .. p23) .. table.concat(p22, ",")
end
function t2.getFetchWidgetInfoFetchKey(s5: string?, s6: string?, p24) -- line: 269
	-- upvalues: FFlagAXPassScreenSizeToWidgetApi (copy), CatalogConstants (copy)
	if FFlagAXPassScreenSizeToWidgetApi then
		return CatalogConstants.FetchWidgetInfoKey .. (s5 or "") .. (s6 or "") .. (p24 or "")
	end

	return CatalogConstants.FetchWidgetInfoKey .. (s5 or "") .. (s6 or "")
end
function t2.GetStatus(p25) -- line: 280
	-- upvalues: CatalogConstants (copy), ItemTileEnums (copy)
	if not p25 then
		return
	end

	local itemStatus = p25.itemStatus

	if not itemStatus then
		return
	end

	if #itemStatus == 0 then
		return
	end

	local t3 = {}

	for _, v88 in itemStatus do
		t3[v88] = true
	end

	local Info = nil
	local New = nil

	if t3[CatalogConstants.ItemStatus.Sale] then
		return ItemTileEnums.StatusStyle.Alert, CatalogConstants.ItemStatusLocale.Sale
	end

	if t3[CatalogConstants.ItemStatus.New] then
		Info = ItemTileEnums.StatusStyle.Info
		New = CatalogConstants.ItemStatusLocale.New
	end

	return Info, New
end
function t2.getIsTradable(p26) -- line: 316
	-- upvalues: CatalogConstants (copy)
	local v92 = p26 and p26.itemRestrictions

	if not v92 then
		return nil
	end

	if v92[CatalogConstants.ItemRestrictions.Limited] then
		return true
	end

	if v92[CatalogConstants.ItemRestrictions.LimitedUnique] then
		return true
	end

	if v92[CatalogConstants.ItemRestrictions.Collectible] then
		return false
	end

	return nil
end

t2.splitEntries = memoize(function(p27, p28, p29) -- line: 334
	-- upvalues: Dash (copy)
	local v96 = math.max(1, 1 + (p28 - 1) * p29)

	return Dash.slice(p27, 1, v96 - 1), (Dash.slice(p27, v96))
end)

function t2.getTopicRequestKey(t4: {[any]: any}, t5: {[any]: any}?, s7: string?) -- line: 351
	-- upvalues: Dash (copy)
	local v100 = not s7 and "" or `[{ s7 or "" }]`

	if #t4 > 0 then
		local v101 = table.clone(t4)

		table.sort(v101)
		v100 ..= table.concat(v101, ",")
	end

	if #v100 > 0 then
		return v100
	end

	if t5 then
		return table.concat(Dash.map(t5, function(p30) -- line: 365
			return tostring(p30.itemType) .. tostring(p30.targetId)
		end))
	end

	return ""
end

local t6 = nil

local function assetTypeHasCatalogPage(p31) -- line: 378
	-- upvalues: GetCatalogCategoriesFromStore (copy)
	for _, v104 in (GetCatalogCategoriesFromStore()) do
		if v104.Subcategories then
			for _, v106 in v104.Subcategories do
				if v106.Name ~= "Community" and v106.AssetTypeIdStrings then
					for _, v108 in v106.AssetTypeIdStrings do
						if v108 == p31 then
							return true
						end
					end
				end
			end
		elseif v104.AssetTypeIdStrings then
			for _, v110 in v104.AssetTypeIdStrings do
				if v110 == p31 then
					return true
				end
			end
		end
	end

	return false
end

function t2.doesAssetTypeHaveCatalogPage(p32) -- line: 405
	-- upvalues: t6 (ref), Constants (copy), assetTypeHasCatalogPage (copy)
	if not t6 then
		t6 = {}

		for _, v113 in Constants.AssetTypeIdStrings do
			if assetTypeHasCatalogPage(v113) then
				t6[v113] = true
			end
		end
	end

	return t6[p32] == true
end
function t2.getRecommendedItemsGridItemTitleHeight(p33, n2: number?) -- line: 418
	local v116 = n2 or 0

	return (p33.BaseSize * p33.Header2.RelativeSize + v116) * 2
end

t2.findCheapestCollectiblePurchaseInfo = memoize(function(s8: string?, p34, p35, p36) -- line: 439
	-- upvalues: GetFFlagCollectiblesCatalogFollowUpForSaleLocation (copy), t2 (copy), tutils (copy)
	local t7 = {}

	if not s8 then
		return t7
	end

	assert(s8, "silence type checker")

	local v122 = p34[s8]

	if not v122 or not v122.unitsAvailableForConsumption or not v122.price then
		return t7
	end

	local v123 = true

	if GetFFlagCollectiblesCatalogFollowUpForSaleLocation() then
		v123 = t2.isOriginalStockSellableInShop(v122)
	end

	local v124 = false

	if v122.quantityLimitPerUser and p36 and p36[s8] then
		local v125 = p36[s8]

		v124 = not not v122 and not not v122.quantityLimitPerUser and if v125 then v122.quantityLimitPerUser > 0 and tutils.fieldCount(v125) >= v122.quantityLimitPerUser else false
	end

	if v123 and not v124 and v122.unitsAvailableForConsumption > 0 then
		t7.price = v122.price
	end

	local v126 = p35[s8]

	if v126 and #v126.InstanceIdsList > 0 then
		local v127 = v126.InstanceIdsList[1]
		local v128 = v126.Instances[v127]

		if not v123 or v122.unitsAvailableForConsumption == 0 or v128.price < t7.price or v124 then
			t7.collectibleInstanceId = v128.collectibleInstanceId
			t7.price = v128.price
			t7.expectedSellerId = v128.seller.sellerId
			t7.sellerName = v128.seller.name
		end
	end

	return t7
end)

function t2.findCheapestCollectiblePurchaseInfoV2(s9: string?, b1: boolean, p37, p38, p39) -- line: 502
	-- upvalues: t2 (copy)
	local t8 = {}

	if not s9 then
		return t8
	end

	assert(s9, "silence type checker")

	local v135 = p37[s9]

	if v135 and not b1 then
		t8.price = v135.price

		return t8
	end

	return (t2.findCheapestCollectiblePurchaseInfo(s9, p37, p38, p39))
end
function t2.getQueryStringForSearchWidgets(p40) -- line: 538
	if not p40 or not p40.searchKeyword then
		return nil
	end

	local t9 = { p40.searchKeyword }

	if p40.sortAndFilters and p40.sortAndFilters.SelectedTopics then
		for _, v139 in p40.sortAndFilters.SelectedTopics do
			table.insert(t9, 1, v139)
		end
	end

	return table.concat(t9, " ")
end
function t2.getCategoryName(n3: number) -- line: 553
	-- upvalues: t (copy), GetCatalogCategoriesFromStore (copy)
	assert(t.number(n3), "Expected categoryIndex to be a number")

	local v141 = GetCatalogCategoriesFromStore()[n3]

	return v141 and v141.Name
end
function t2.getCategoryId(s10: string) -- line: 561
	-- upvalues: GetCatalogCategoriesMap (copy)
	return GetCatalogCategoriesMap()[s10]
end
function t2.extractCategoryById(s11: string, t10: {[any]: any}) -- line: 566
	-- upvalues: t (copy)
	assert(t.string(s11), "Expected categoryId to be a string")

	for _, v146 in t10 do
		if s11 == v146.Id then
			return v146
		end
	end

	return nil
end
function t2.extractSubcategoryById(s12: string, t11: {[any]: any}) -- line: 579
	-- upvalues: t (copy)
	assert(t.string(s12), "Expected subcategoryId to be a string")

	for _, v150 in t11 do
		if s12 == v150.Id then
			return v150
		end
	end

	return nil
end
function t2.findCategoryByCategoryId(n4: number, p41) -- line: 592
	if not n4 then
		return nil
	end

	for _, v154 in p41 do
		if n4 == v154.CategoryId then
			return v154
		end
	end

	return nil
end
function t2.findSubcategoryBySubcategoryId(n5: number, p42) -- line: 608
	if not n5 then
		return nil
	end

	for _, v158 in p42 do
		if n5 == v158.SubcategoryId then
			return v158
		end
	end

	return nil
end
function t2.findCategoryIdsByTaxonomy(s13: string, p43) -- line: 624
	if not s13 then
		return nil, nil
	end

	for _, v162 in p43 do
		if v162.TaxonomyUuid and string.lower(v162.TaxonomyUuid) == string.lower(s13) then
			return v162.Id, nil
		end

		if v162.Subcategories then
			for _, v164 in v162.Subcategories do
				if v164.TaxonomyUuid and string.lower(v164.TaxonomyUuid) == string.lower(s13) then
					return v162.Id, v164.Id
				end
			end
		end
	end

	return nil, nil
end
function t2.getCategoryNameById(s14: string) -- line: 646
	-- upvalues: t2 (copy)
	local v166 = t2.getCategoryId(s14)

	return v166 and v166.Name
end
function t2.getSubcategoryId(s15: string, s16: string) -- line: 651
	-- upvalues: t (copy), t2 (copy)
	assert(t.tuple(t.string, t.string)(s15, s16), "Expected categoryId and subcategoryId to be strings")

	local v169 = nil
	local v170 = t2.getCategoryId(s15)

	if v170 and v170.SubcategoriesMap then
		v169 = v170.SubcategoriesMap[s16]
	end

	return v169
end
function t2.getSubcategoryNameById(s17: string, s18: string) -- line: 667
	-- upvalues: t2 (copy)
	local v173 = t2.getSubcategoryId(s17, s18)

	return v173 and v173.Name
end
function t2.getSubcategoryNameByIdWithErrorLogging(s19: string, s20: string) -- line: 672
	-- upvalues: t2 (copy), GetFFlagAXEnableErrorLoggingForSubcategorySelectionById (copy), mutedError (copy)
	local v176 = t2.getSubcategoryNameById(s19, s20)

	if GetFFlagAXEnableErrorLoggingForSubcategorySelectionById() and (s19 and s20 and not v176) then
		mutedError("getSubcategoryNameById returned nil for subcategoryId: " .. s20 .. " and categoryId: " .. s19)
	end

	return v176
end
function t2.findCategoryIndexById(p44, p45) -- line: 690
	for v179, v180 in p44 do
		if p45 == v180.Id then
			return v179
		end
	end

	return nil
end
function t2.getSubcategoryName(n6: number, n7: number) -- line: 699
	-- upvalues: t (copy), GetCatalogCategoriesFromStore (copy)
	assert(t.tuple(t.number, t.number)(n6, n7), "Expected categoryIndex and subcategoryIndex to be numbers")

	local v183 = nil
	local v184 = GetCatalogCategoriesFromStore()[n6]

	if v184 then
		local v185 = v184.Subcategories and v184.Subcategories[n7]

		v183 = v185 and v185.Name
	end

	return v183
end
function t2.getCurrentCategoryNames(p46) -- line: 722
	-- upvalues: GetCatalogCategoriesStore (copy), t2 (copy)
	if not p46 or (not p46.AvatarExperience or not p46.AvatarExperience.Catalog) then
		return nil
	end

	local t12 = {}
	local v188 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v189 = v188.selectedCategoryId(false)
	local v190 = v188.selectedSubcategoryId(false)

	if v189 then
		t12.catalogCategory = t2.getCategoryNameById(v189)

		if v190 then
			t12.catalogSubcategory = t2.getSubcategoryNameByIdWithErrorLogging(v189, v190)
		else
			t12.catalogSubcategory = nil
		end
	end

	local v191 = GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v192 = v191.selectedCategoryId(false)
	local v193 = v191.selectedSubcategoryId(false)

	if v192 then
		t12.catalogSearchCategory = t2.getCategoryNameById(v192)

		if v193 then
			t12.catalogSearchSubcategory = t2.getSubcategoryNameByIdWithErrorLogging(v192, v193)

			return t12
		end

		t12.catalogSearchSubcategory = nil
	end

	return t12
end
function t2.getContextStringForWidgets(t13: {[any]: any}) -- line: 764
	-- upvalues: t (copy)
	assert(t.array(t.string)(t13))

	local v195 = table.concat(t13, ":")
	local v196 = string.gsub(v195, " ", "-")
	local v197 = string.gsub(v196, "%.", "-")

	return (string.lower(v197))
end
function t2.getContextForWidgetsById(s21: string, s22: string, s23: string?) -- line: 786
	-- upvalues: t (copy), Constants3 (copy), t2 (copy)
	assert(t.tuple(t.string, t.string, t.optional(t.string))(s21, s22, s23), "Expected pageName to be a string, categoryId to be a string, and subcategoryId to be a string or nil")

	if not table.find(Constants3.ContextWidgetsAllowedRoutes, s21) then
		return nil
	end

	local v201 = Constants3.AnalyticsContext[s21]
	local v202 = t2.getCategoryNameById(s22)

	if v201 and v202 then
		local t14 = { `{ v201 }-tab` }

		table.insert(t14, v202)

		if s23 then
			local v204 = t2.getSubcategoryNameByIdWithErrorLogging(s22, s23)

			if v204 then
				table.insert(t14, v204)
			end

			if s23 and not v204 then
				return nil
			end
		end

		return t2.getContextStringForWidgets(t14)
	end

	return nil
end
function t2.getCategoryAndSubcategory(p47) -- line: 826
	-- upvalues: t2 (copy), selectCurrentAvatarRoute (copy), AvatarScreen (copy)
	local v206 = t2.getCurrentCategoryNames(p47)
	local v207 = selectCurrentAvatarRoute(p47)
	local v208 = v207 and v207.name == AvatarScreen.CatalogSearch
	local v209 = nil
	local v210 = nil

	if v206 then
		if v208 then
			return v206.catalogSearchCategory or v209, v206.catalogSearchSubcategory or v210
		end

		v209 = v206.catalogCategory or v209
		v210 = v206.catalogSubcategory or v210
	end

	return v209, v210
end
function t2.removeItemFootersFromConfigs(p48, p49, p50, p51, p52) -- line: 846
	-- upvalues: tutils (copy)
	local function removeEntriesFromItemFooters(p53) -- line: 853
		-- upvalues: p50 (copy), p51 (copy), p52 (copy)
		local function removeEntryFromItemFooter(p54) -- line: 854
			-- upvalues: p53 (copy)
			local v248 = nil

			for v249, v250 in p53 do
				if p54 == v250.contentType then
					v248 = v249
				end

				if v248 then
					table.remove(p53, v248)
				end
			end
		end

		if p50 then
			removeEntryFromItemFooter("ItemName")
		end

		if p51 then
			removeEntryFromItemFooter("AgentName")
		end

		if p52 then
			removeEntryFromItemFooter("Price")
		end
	end

	local v217 = tutils.deepCopy(p48)
	local v218 = tutils.deepCopy(p49)

	if v218 and (v218.template and v218.template.itemFooters) then
		local itemFooters = v218.template.itemFooters

		local function removeEntryFromItemFooter(p55) -- line: 854
			-- upvalues: itemFooters (copy)
			local v236 = nil

			for v237, v238 in itemFooters do
				if p55 == v238.contentType then
					v236 = v237
				end

				if v236 then
					table.remove(itemFooters, v236)
				end
			end
		end

		if p50 then
			removeEntryFromItemFooter("ItemName")
		end

		if p51 then
			removeEntryFromItemFooter("AgentName")
		end

		if p52 then
			removeEntryFromItemFooter("Price")
		end
	end

	if v217 and v217.defaultItemGroupTemplate and v217.defaultItemGroupTemplate.itemFooters then
		local itemFooters = v217.defaultItemGroupTemplate.itemFooters

		local function removeEntryFromItemFooter(p56) -- line: 854
			-- upvalues: itemFooters (copy)
			local v240 = nil

			for v241, v242 in itemFooters do
				if p56 == v242.contentType then
					v240 = v241
				end

				if v240 then
					table.remove(itemFooters, v240)
				end
			end
		end

		if p50 then
			removeEntryFromItemFooter("ItemName")
		end

		if p51 then
			removeEntryFromItemFooter("AgentName")
		end

		if p52 then
			removeEntryFromItemFooter("Price")
		end
	end

	if v217 and v217.defaultItemCarouselTemplate and v217.defaultItemCarouselTemplate.itemFooters then
		local itemFooters = v217.defaultItemCarouselTemplate.itemFooters

		local function removeEntryFromItemFooter(p57) -- line: 854
			-- upvalues: itemFooters (copy)
			local v244 = nil

			for v245, v246 in itemFooters do
				if p57 == v246.contentType then
					v244 = v245
				end

				if v244 then
					table.remove(itemFooters, v244)
				end
			end
		end

		if p50 then
			removeEntryFromItemFooter("ItemName")
		end

		if p51 then
			removeEntryFromItemFooter("AgentName")
		end

		if p52 then
			removeEntryFromItemFooter("Price")
		end
	end

	if v217 and v217.customizedDataMap and v217.customizedDataMap.creatorNameTileFooterEnabled and p51 then
		v217.customizedDataMap.creatorNameTileFooterEnabled = false
	end

	return v217, v218
end
function t2.getAvatarsTabAnalyticsInfo(p58) -- line: 912
	-- upvalues: t2 (copy), AvatarScreen (copy)
	local v226 = t2.getCurrentCategoryNames(p58)
	local name = p58.AvatarExperience.AvatarScene.AvatarRoute.opaque.name
	local keyword = nil
	local searchUuid = nil
	local v230, v231

	if name == AvatarScreen.CatalogSearch then
		keyword = p58.AvatarExperience.Catalog.AvatarsTabSearchInfo.keyword
		searchUuid = p58.AvatarExperience.Catalog.AvatarsTabSearchInfo.searchUuid
		v230 = v226 and v226.catalogSearchCategory
		v231 = v226 and v226.catalogSearchSubcategory
	else
		v230 = v226 and v226.catalogCategory
		v231 = v226 and v226.catalogSubcategory
	end

	return keyword, v230, v231, searchUuid, name
end

return t2
