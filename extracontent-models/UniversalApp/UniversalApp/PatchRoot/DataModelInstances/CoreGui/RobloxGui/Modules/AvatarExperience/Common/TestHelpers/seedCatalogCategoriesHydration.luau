local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local GetCatalogCategories = require(Modules.AvatarExperience.Catalog.GetCatalogCategories)

local function toMarketplaceData(p1) -- line: 24
	return {
		id = p1.Id,
		name = p1.CategoryFilter or p1.Name,
		title = p1.Title,
		taxonomyId = p1.TaxonomyUuid,
		assetTypes = p1.AssetTypeIdStrings,
		bundleTypes = p1.BundleTypes,
		tileType = p1.TileType,
		timeToRefresh = p1.TimeToRefresh,
		categoryId = p1.CategoryId,
		subcategoryId = p1.SubcategoryId,
		cameraFocus = p1.CameraFocus,
		cameraZoomRadius = p1.CameraZoomRadius,
		canAnimateCameraBasedMood = p1.CanAnimateCameraBasedMood
	}
end
local function seedCatalogCategoriesHydration(p2) -- line: 46
	-- upvalues: GetCatalogCategories (copy), DataHydration (copy), toMarketplaceData (copy)
	local v10 = p2 or GetCatalogCategories()
	local v11 = DataHydration.MarketplaceCatalogCategory.getMarketplaceCatalogCategoryStore(false)
	local t1 = {}

	for _, v14 in v10 do
		if v14 and v14.Id then
			t1[v14.Id] = toMarketplaceData(v14)

			if v14.Subcategories then
				local t2 = {}

				for _, v17 in v14.Subcategories do
					if v17 and v17.Id then
						table.insert(t2, v17.Id)
						t1[v17.Id] = toMarketplaceData(v17)
					end
				end

				if #t2 > 0 then
					t1[v14.Id].subcategories = t2
				end
			end
		end
	end

	v11.updateMarketplaceCatalogCategories(t1)
end

return seedCatalogCategoriesHydration
