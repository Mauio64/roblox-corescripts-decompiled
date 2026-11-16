local module = require("@luauforge/bundled/fuM")
require("@luauforge/bundled/dMd")
local createCategoryInventoryStore = module.Stores.createCategoryInventoryStore
local module2 = require("@luauforge/bundled/dNQ")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module4 = require("@luauforge/bundled/dOj")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp

local function createInventoryStoresFromCategories()
	local inventoryStoresFromCategories = {}

	for k, v5 in module4() do
		if v5.Subcategories then
			for k2, subcategory in v5.Subcategories do
				inventoryStoresFromCategories[subcategory.NavigationKey] = createCategoryInventoryStore()

				if not (fFlagAXEditorSubcategoryFilters and subcategory.SubcategoryFilters) then
					continue
				end

				for k3, subcategoryFilter in subcategory.SubcategoryFilters do
					inventoryStoresFromCategories[subcategoryFilter.NavigationKey] = createCategoryInventoryStore()
				end
			end
		else
			inventoryStoresFromCategories[v5.NavigationKey] = createCategoryInventoryStore()
		end
	end

	if fFlagAXOutfitPageRevamp then
		inventoryStoresFromCategories[module2.EditableMakeupOutfitKey] = createCategoryInventoryStore()
	end

	return inventoryStoresFromCategories
end

return createInventoryStoresFromCategories
