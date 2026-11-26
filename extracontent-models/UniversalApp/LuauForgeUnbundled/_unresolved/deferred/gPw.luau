local module = require("@luauforge/bundled/dVl")
local module2 = require("@luauforge/bundled/dPU")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module3 = require("@luauforge/bundled/dzP")

local module4 = require("@luauforge/bundled/dSW")

return function(p2, callback, p3, p4, p5, p6, p7)
	return function(object)
		local state = object:getState()

		local detail = state.AvatarExperience.AvatarScene.AvatarRoute.opaque.params.detail
		local v5, v6, v7, v8

		if p2 ~= module2.AnalyticsContext.ItemDetailsRecommendedItem then
			v5 = state.Search.SearchesInCatalog[detail]

			if p2 == module2.AnalyticsContext.CatalogSearch then
				module3.isNotNil(v5, "searchInCatalog")

				v6 = state.AvatarExperience.Catalog.SearchCategories.categoryId
				v7 = state.AvatarExperience.Catalog.SearchCategories.subcategoryId
			else
				local catalogSelectionStore = module4.getCatalogSelectionStore()
				v6 = catalogSelectionStore.selectedCategoryId(false)
				v7 = catalogSelectionStore.selectedSubcategoryId(false)
			end

			local v9 = itemData(state.AvatarExperience.Common, p3, p4)
			v8 = module.GetItemSubType(p4, v9)
		end

		local requestId = state.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
		local analyticsMetadata = state.AvatarExperience.AnalyticsMetadata

		local v9 = {
			keyword = v5 and v5.keyword
		}

		callback(p2, math.ceil(p5 / p6), v6, v7, nil, v9, p5, p3, p4, v8, p7, requestId, analyticsMetadata)
	end
end
