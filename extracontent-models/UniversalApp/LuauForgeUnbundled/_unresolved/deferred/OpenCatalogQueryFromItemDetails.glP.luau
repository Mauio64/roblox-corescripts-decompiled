local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
require("@luauforge/deferred/glL")
local module = require("@luauforge/bundled/gkk")
local module2 = require("@luauforge/bundled/dPF")
local module3 = require("@luauforge/deferred/glQ")
local module4 = require("@luauforge/bundled/dPG")
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/deferred/glR")
local module7 = require("@luauforge/bundled/glS")
local module8 = require("@luauforge/bundled/dMx")

local fFlagAXCatalogDeepLinkSearchProps = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogDeepLinkSearchProps

local set = { [avatarScreen.Catalog] = true, [avatarScreen.CatalogSearch] = true }

local function selectSearchResultsCategory(p2)
	local categoryId = p2.categoryId or module8.DefaultCatalogCategoryId
	local v5 = if p2.categoryId then p2.subcategoryId else nil
	module5(module4.getCatalogSearchSelectionStore, categoryId, v5, {
		source = "DeepLink"
	})
end

local function toDeepLinkParams(data, p2)
	local deepLinkParams = {
		keyword = data.keyword,
		creatorName = data.creatorName,
		category = 0,
		subcategory = 0,
		taxonomy = 0,
		salesTypeFilter = 0
	}
	local v5 = if p2.category then tostring(p2.category) else nil
	deepLinkParams.category = v5
	local v6 = if p2.subcategory then tostring(p2.subcategory) else nil
	deepLinkParams.subcategory = v6
	deepLinkParams.taxonomy = data.taxonomy
	deepLinkParams.salesTypeFilter = data.salesTypeFilter

	if not fFlagAXCatalogDeepLinkSearchProps then
		return deepLinkParams
	end

	deepLinkParams.sortType = data.sortType
	deepLinkParams.sortAggregation = data.sortAggregation
	deepLinkParams.minPrice = data.minPrice
	deepLinkParams.maxPrice = data.maxPrice
	deepLinkParams.includeNotForSale = data.includeNotForSale
	deepLinkParams.topics = data.topics

	return deepLinkParams
end

local function openMarketplace(object, p2)
	local v5 = module3(p2, module2())
	local v6 = toDeepLinkParams(p2, v5)
	local v7 = avatarScreen.Catalog

	if p2.keyword then
		local categoryId = v5.categoryId or module8.DefaultCatalogCategoryId
		local v8 = if v5.categoryId then v5.subcategoryId else nil
		module5(module4.getCatalogSearchSelectionStore, categoryId, v8, {
			source = "DeepLink"
		})

		v7 = avatarScreen.CatalogSearch
	elseif not module7.catalogDeepLinkExists({ screen = v7, params = v6 }) then
		object:dispatch(module6())
	end

	object:dispatch(module(v7, v6))
end

local function OpenCatalogQueryFromItemDetails(p2, p3, p4)
	return function(p5)
		local v5 = p4 ~= nil and set[p4.name] == true
		p3.navigate(avatarScreen.DescriptionLinkSearchPrompt, {
			kind = v5 and "ResetSearch" or "GoToMarketplace",
			onConfirm = function()
				openMarketplace(p5, p2)
			end
		})
	end
end

return OpenCatalogQueryFromItemDetails
