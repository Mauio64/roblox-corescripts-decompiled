local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)

return function(p1) -- line: 16
	-- upvalues: AvatarScreen (copy), GetCatalogCategoriesStore (copy), CatalogConstants (copy), Utils (copy)
	return function(p2) -- line: 17
		-- upvalues: AvatarScreen (copy), GetCatalogCategoriesStore (copy), CatalogConstants (copy), Utils (copy), p1 (copy)
		local EntryPage = p2:getState().AvatarExperience.LayeredClothingSort.EntryPage
		local category, s1

		if EntryPage == AvatarScreen.AvatarEditor then
			category = p2:getState().AvatarExperience.AvatarEditor.Categories.category
			s1 = "avatarEditor"
		else
			if EntryPage ~= AvatarScreen.Catalog and EntryPage ~= AvatarScreen.CatalogSearch then
				return
			end

			category = GetCatalogCategoriesStore.getCatalogSelectionStore().selectedCategoryId(false)
			s1 = CatalogConstants.AnalyticsContext.AvatarShop
		end

		local v13 = Utils.getUserId(p2:getState())
		local SelectedAccessory = p2:getState().AvatarExperience.AccessoryAdjustment.SelectedAccessory

		p1(s1, v13, category, SelectedAccessory)
	end
end
