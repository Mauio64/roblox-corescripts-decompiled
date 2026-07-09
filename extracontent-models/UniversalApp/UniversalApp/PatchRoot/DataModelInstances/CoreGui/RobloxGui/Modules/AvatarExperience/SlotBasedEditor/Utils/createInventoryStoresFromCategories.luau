local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local createCategoryInventoryStore = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Stores.createCategoryInventoryStore
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local photoboothCategories = require(Modules.AvatarExperience.Photobooth.photoboothCategories)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local FFlagAXPhotoboothIsStandalone = AvatarExperienceFlags.FFlagAXPhotoboothIsStandalone

local function createInventoryStoresFromCategories() -- line: 22
	-- upvalues: GetAvatarEditorCategories (copy), FFlagAXPhotoboothIsStandalone (copy), createCategoryInventoryStore (copy), FFlagAXEditorSubcategoryFilters (copy), FFlagAXPhotoboothFunctionality (copy), photoboothCategories (copy)
	local t1 = {}

	for _, v13 in GetAvatarEditorCategories() do
		if v13.Subcategories then
			for _, v15 in v13.Subcategories do
				if not FFlagAXPhotoboothIsStandalone or v15.NavigationKey then
					t1[v15.NavigationKey] = createCategoryInventoryStore()

					if FFlagAXEditorSubcategoryFilters and v15.SubcategoryFilters then
						for _, v17 in v15.SubcategoryFilters do
							t1[v17.NavigationKey] = createCategoryInventoryStore()
						end
					end
				end
			end
		elseif not FFlagAXPhotoboothIsStandalone or v13.NavigationKey then
			t1[v13.NavigationKey] = createCategoryInventoryStore()
		end
	end

	if FFlagAXPhotoboothFunctionality then
		for _, v19 in photoboothCategories do
			t1[v19.NavigationKey] = createCategoryInventoryStore()
		end
	end

	return t1
end

return createInventoryStoresFromCategories
