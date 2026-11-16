local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUILinks = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUILinks
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXSduiProcessCatalogDeepLink = AvatarExperienceFlags.FFlagAXSduiProcessCatalogDeepLink

local module2 = require("@luauforge/bundled/dMn")
local module3 = require("@luauforge/bundled/dRQ")
local module4 = require("@luauforge/bundled/dPG")
local module5 = require("@luauforge/bundled/dPF")
local module6 = require("@luauforge/bundled/dPN")
local function NavigateToDeepLinkCatalogFilterThunk(data, p2)
	return function(object)
		object:dispatch(module2(data))

		if fFlagAXCatalogCategoriesSDUILinks or fFlagAXMigrateAllTabToSduiDev then
			local catalogCategoriesStore = module4.getCatalogCategoriesStore()

			if not catalogCategoriesStore.getHasFetchedCategories(false) then
				if not fFlagAXSduiProcessCatalogDeepLink then
					return
				end

				if p2 == false then
					local clearPendingDeepLinkAction = catalogCategoriesStore.clearPendingDeepLinkAction

					if clearPendingDeepLinkAction then
						clearPendingDeepLinkAction()
						return
					end
				else
					local setPendingDeepLinkAction = catalogCategoriesStore.setPendingDeepLinkAction

					if setPendingDeepLinkAction then
						setPendingDeepLinkAction(function()
							return NavigateToDeepLinkCatalogFilterThunk(data)
						end)
					end
				end

				return
			end
		end

		local catalogSelectionStore = module4.getCatalogSelectionStore()

		local taxonomy = data.taxonomy

		if taxonomy then
			local v5 = module5()

			local categoryIdsByTaxonomy, v6 = module3.findCategoryIdsByTaxonomy(taxonomy, v5)

			if categoryIdsByTaxonomy then
				if fFlagAXMigrateAllTabToSduiDev then
					module6(module4.getCatalogSelectionStore, categoryIdsByTaxonomy, v6, {
						source = "DeepLink"
					})
				else
					catalogSelectionStore.changeCategory(categoryIdsByTaxonomy, v6)
				end
			end
		else
			local v5

			if data.category then
				local v6 = module5()

				v5 = module3.findCategoryByCategoryId(data.category, v6)
			else
				local selectedCategoryId = catalogSelectionStore.selectedCategoryId(false)
				v5 = module3.getCategoryId(selectedCategoryId)
			end

			if v5 == nil then
				return
			end

			local id = v5.Id
			local id2 = nil

			if data.subcategory and v5 and v5.Subcategories then
				local subcategoryBySubcategoryId = module3.findSubcategoryBySubcategoryId(
					data.subcategory,
					v5.Subcategories
				)

				if subcategoryBySubcategoryId then
					id2 = subcategoryBySubcategoryId.Id
				end
			end

			if fFlagAXMigrateAllTabToSduiDev then
				module6(module4.getCatalogSelectionStore, id, id2, {
					source = "DeepLink"
				})
			else
				catalogSelectionStore.changeCategory(id, id2)
			end
		end
	end
end

return NavigateToDeepLinkCatalogFilterThunk
