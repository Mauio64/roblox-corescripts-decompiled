local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 12
	-- upvalues: CatalogConstants (copy), ArgCheck (copy), GetCatalogCategoriesStore (copy), ItemData (copy), CatalogUtils (copy)
	return function(p8) -- line: 13
		-- upvalues: p1 (copy), CatalogConstants (copy), ArgCheck (copy), GetCatalogCategoriesStore (copy), ItemData (copy), p3 (copy), p4 (copy), CatalogUtils (copy), p5 (copy), p6 (copy), p2 (copy), p7 (copy)
		local v16 = p8:getState()
		local detail = v16.AvatarExperience.AvatarScene.AvatarRoute.opaque.params.detail
		local categoryId = nil
		local subcategoryId = nil
		local v20 = nil
		local v21 = nil

		if p1 ~= CatalogConstants.AnalyticsContext.ItemDetailsRecommendedItem then
			v20 = v16.Search.SearchesInCatalog[detail]

			if p1 == CatalogConstants.AnalyticsContext.CatalogSearch then
				ArgCheck.isNotNil(v20, "searchInCatalog")
				categoryId = v16.AvatarExperience.Catalog.SearchCategories.categoryId
				subcategoryId = v16.AvatarExperience.Catalog.SearchCategories.subcategoryId
			else
				local v22 = GetCatalogCategoriesStore.getCatalogSelectionStore()

				categoryId = v22.selectedCategoryId(false)
				subcategoryId = v22.selectedSubcategoryId(false)
			end

			local v23 = ItemData(v16.AvatarExperience.Common, p3, p4)

			v21 = CatalogUtils.GetItemSubType(p4, v23)
		end

		local RequestId = v16.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
		local AnalyticsMetadata = v16.AvatarExperience.AnalyticsMetadata
		local t1 = {
			keyword = v20 and v20.keyword
		}
		local v27 = math.ceil(p5 / p6)

		p2(p1, v27, categoryId, subcategoryId, nil, t1, p5, p3, p4, v21, p7, RequestId, AnalyticsMetadata)
	end
end
