local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(parent.AvatarExperienceCommon)
require(parent.DataHydration)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXM41AllCategoriesToTaxonomy = AvatarExperienceFlags.FFlagAXM41AllCategoriesToTaxonomy
local FFlagAXSduiCatalogSearchShowWidgets = AvatarExperienceFlags.FFlagAXSduiCatalogSearchShowWidgets

local HttpService = game:GetService("HttpService")

local v = { AllAnimations = "AllAnimation", AnimationBundles = "Animation", Emotes = "Emotes" }

local v2 = {
	Recommended = {
		Name = "All",
		CategoryFilter = "Recommended",
		ShowWidgets = FFlagAXSduiCatalogSearchShowWidgets and true or nil,
		ShowSponsored = FFlagAXSduiCatalogSearchShowWidgets and true or nil,
		ShowTopics = FFlagAXSduiCatalogSearchShowWidgets and true or nil
	},
	HighDefinition = { CategoryFilter = "HighDefinition" }
}

local function widgetContextFromName(name: string) -- 1 equivalent call inferred from this helper
	local v3 = name:gsub(" ", "-"):gsub("%.", "-")
	return `catalog-tab:{string.lower(v3)}`
end

local function createMapMarketplaceCategoryToCatalogCategory()
	local v3 = {}

	local function getOrCreateSearchUuid(p: string)
		local v4 = v3[p]

		if v4 then
			return v4
		end

		local guid = HttpService:GenerateGUID(true)
		v3[p] = guid
		return guid
	end

	local function mapInternal(data, p, flag: boolean?, p2)
		p2[data.id] = true
		local subcategories

		if data.subcategories and #data.subcategories > 0 then
			subcategories = {}

			for _, subcategory in data.subcategories do
				if p2[subcategory] then
					continue
				end

				local v4 = p[subcategory]

				if v4 then
					table.insert(subcategories, mapInternal(v4, p, true, p2))
				end
			end

			if #subcategories == 0 then
				subcategories = nil
			end
		end

		p2[data.id] = nil

		local v4 = v2[data.id]
		local v5 = {
			Id = data.id,
			Name = 0,
			CategoryFilter = 0,
			ShowWidgets = 0,
			ShowSponsored = 0,
			ShowTopics = 0,
			Title = 0,
			LocalizedTitle = 0,
			WidgetContext = 0,
			SearchUuid = 0,
			TaxonomyUuid = 0,
			AssetTypeIdStrings = 0,
			BundleTypes = 0,
			TileType = 0,
			TimeToRefresh = 0,
			CategoryId = 0,
			SubcategoryId = 0,
			CameraFocus = 0,
			CameraZoomRadius = 0,
			CanAnimateCameraBasedMood = 0,
			LooksWidgetContextForOrganicContent = 0,
			PageType = 0,
			Subcategories = 0,
			isSubcategory = 0
		}
		local name = if v4 and v4.Name then v4.Name else data.name
		v5.Name = name
		local categoryFilter

		if v4 then
			categoryFilter = v4.CategoryFilter
		end

		v5.CategoryFilter = categoryFilter
		local showWidgets

		if FFlagAXSduiCatalogSearchShowWidgets and v4 then
			showWidgets = v4.ShowWidgets
		end

		v5.ShowWidgets = showWidgets
		local showSponsored

		if FFlagAXSduiCatalogSearchShowWidgets and v4 then
			showSponsored = v4.ShowSponsored
		end

		v5.ShowSponsored = showSponsored
		local showTopics

		if FFlagAXSduiCatalogSearchShowWidgets and v4 then
			showTopics = v4.ShowTopics
		end

		v5.ShowTopics = showTopics
		v5.Title = data.title
		v5.LocalizedTitle = data.title
		v5.WidgetContext = widgetContextFromName(data.name) -- inferred equivalent call
		local id = data.id
		local searchUuid = v3[id]

		if not searchUuid then
			searchUuid = HttpService:GenerateGUID(true)
			v3[id] = searchUuid
		end

		v5.SearchUuid = searchUuid
		local taxonomyUuid

		if FFlagAXM41AllCategoriesToTaxonomy and data.taxonomyId ~= nil and data.taxonomyId ~= "" then
			taxonomyUuid = data.taxonomyId
		end

		v5.TaxonomyUuid = taxonomyUuid

		v5.AssetTypeIdStrings = data.assetTypes
		v5.BundleTypes = data.bundleTypes
		v5.TileType = data.tileType
		v5.TimeToRefresh = data.timeToRefresh
		v5.CategoryId = data.categoryId
		v5.SubcategoryId = data.subcategoryId
		v5.CameraFocus = data.cameraFocus
		v5.CameraZoomRadius = data.cameraZoomRadius
		v5.CanAnimateCameraBasedMood = data.canAnimateCameraBasedMood
		local looksWidgetContextForOrganicContent

		if not (data.looksWidgetContextForOrganicContent == nil or data.looksWidgetContextForOrganicContent == "") then
			looksWidgetContextForOrganicContent = data.looksWidgetContextForOrganicContent
		end

		v5.LooksWidgetContextForOrganicContent = looksWidgetContextForOrganicContent

		v5.PageType = v[data.name]
		v5.Subcategories = subcategories
		v5.isSubcategory = flag and true or nil
		return v5
	end

	return {
		map = function(p, p2, flag: boolean?)
			return mapInternal(p, p2, flag, {})
		end,
		clear = function()
			table.clear(v3)
		end
	}
end

return createMapMarketplaceCategoryToCatalogCategory
