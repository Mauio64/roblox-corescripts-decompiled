require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DataHydration")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXM41AllCategoriesToTaxonomy = AvatarExperienceFlags.FFlagAXM41AllCategoriesToTaxonomy
local fFlagAXSduiCatalogSearchShowWidgets = AvatarExperienceFlags.FFlagAXSduiCatalogSearchShowWidgets
local fFlagAXSduiCatalogTaxonomyFromServer = AvatarExperienceFlags.FFlagAXSduiCatalogTaxonomyFromServer

local HttpService = game:GetService("HttpService")

local v5 = {
	AllAnimations = "AllAnimation",
	AnimationBundles = "Animation",
	Emotes = "Emotes"
}

local v6 = {
	Recommended = {
		Name = "All",
		CategoryFilter = "Recommended",
		ShowWidgets = fFlagAXSduiCatalogSearchShowWidgets and true or nil,
		ShowSponsored = fFlagAXSduiCatalogSearchShowWidgets and true or nil,
		ShowTopics = fFlagAXSduiCatalogSearchShowWidgets and true or nil
	},
	HighDefinition = { CategoryFilter = "HighDefinition" }
}

local function widgetContextFromName(value)
	local v7 = value:gsub(" ", "-"):gsub("%.", "-")
	return `catalog-tab:{string.lower(v7)}`
end

local function createMapMarketplaceCategoryToCatalogCategory()
	local v7 = {}

	local function getOrCreateSearchUuid(p2)
		local v8 = v7[p2]

		if v8 then
			return v8
		end

		local guid = HttpService:GenerateGUID(true)
		v7[p2] = guid
		return guid
	end

	local function mapInternal(data, p2, p3, p4)
		p4[data.id] = true
		local v8

		if data.subcategories and #data.subcategories > 0 then
			v8 = {}

			for k, subcategory in data.subcategories do
				if p4[subcategory] then
					continue
				end

				local v9 = p2[subcategory]

				if v9 then
					table.insert(v8, mapInternal(v9, p2, true, p4))
				end
			end

			if #v8 == 0 then
				v8 = nil
			end
		end

		p4[data.id] = nil

		local v9 = v6[data.id]
		local v10 = {
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
		local v11 = if v9 and v9.Name then v9.Name else data.name
		v10.Name = v11
		local v12 = if v9 then v9.CategoryFilter else nil
		v10.CategoryFilter = v12
		local v13 = if fFlagAXSduiCatalogSearchShowWidgets and v9 then v9.ShowWidgets else nil
		v10.ShowWidgets = v13
		local v14 = if fFlagAXSduiCatalogSearchShowWidgets and v9 then v9.ShowSponsored else nil
		v10.ShowSponsored = v14
		local v15 = if fFlagAXSduiCatalogSearchShowWidgets and v9 then v9.ShowTopics else nil
		v10.ShowTopics = v15
		v10.Title = data.title
		v10.LocalizedTitle = data.title
		local v16 = data.name:gsub(" ", "-"):gsub("%.", "-")
		v10.WidgetContext = `catalog-tab:{string.lower(v16)}`
		local id = data.id
		local v17 = v7[id]

		if not v17 then
			v17 = HttpService:GenerateGUID(true)
			v7[id] = v17
		end

		v10.SearchUuid = v17

		local v18 = if (fFlagAXSduiCatalogTaxonomyFromServer or fFlagAXM41AllCategoriesToTaxonomy) and data.taxonomyId ~= nil and data.taxonomyId ~= "" then data.taxonomyId else nil
		v10.TaxonomyUuid = v18

		v10.AssetTypeIdStrings = data.assetTypes
		v10.BundleTypes = data.bundleTypes
		v10.TileType = data.tileType
		v10.TimeToRefresh = data.timeToRefresh
		v10.CategoryId = data.categoryId
		v10.SubcategoryId = data.subcategoryId
		v10.CameraFocus = data.cameraFocus
		v10.CameraZoomRadius = data.cameraZoomRadius
		v10.CanAnimateCameraBasedMood = data.canAnimateCameraBasedMood

		local v19 = if data.looksWidgetContextForOrganicContent ~= nil and data.looksWidgetContextForOrganicContent ~= "" then data.looksWidgetContextForOrganicContent else nil
		v10.LooksWidgetContextForOrganicContent = v19

		v10.PageType = v5[data.name]
		v10.Subcategories = v8
		v10.isSubcategory = p3 and true or nil
		return v10
	end

	return {
		map = function(p2, p3, p4)
			return mapInternal(p2, p3, p4, {})
		end,
		clear = function()
			table.clear(v7)
		end
	}
end

return createMapMarketplaceCategoryToCatalogCategory
