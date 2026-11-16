local createThumbnailLatencyStore = require("@luauforge/bundled/fuM").Stores.createThumbnailLatencyStore
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module2 = require("@luauforge/bundled/dOj")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters

local function createThumbnailLatencyStoresFromCategories()
	local thumbnailLatencyStoresFromCategories = {}

	for k, v5 in module2() do
		if v5.Subcategories then
			for k2, subcategory in v5.Subcategories do
				thumbnailLatencyStoresFromCategories[subcategory.NavigationKey] = createThumbnailLatencyStore()

				if not (fFlagAXEditorSubcategoryFilters and subcategory.SubcategoryFilters) then
					continue
				end

				for k3, subcategoryFilter in subcategory.SubcategoryFilters do
					thumbnailLatencyStoresFromCategories[subcategoryFilter.NavigationKey] = createThumbnailLatencyStore()
				end
			end
		else
			thumbnailLatencyStoresFromCategories[v5.NavigationKey] = createThumbnailLatencyStore()
		end
	end

	return thumbnailLatencyStoresFromCategories
end

return createThumbnailLatencyStoresFromCategories
