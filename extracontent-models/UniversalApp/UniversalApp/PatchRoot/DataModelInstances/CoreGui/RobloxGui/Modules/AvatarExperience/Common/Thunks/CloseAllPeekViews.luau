local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CloseMatchingScreens = require(Modules.AvatarExperience.Common.Thunks.CloseMatchingScreens)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AppPage = require(Modules.LuaApp.AppPage)
local FFlagAXEditorSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEditorSubcategoryFilters

return function(p1) -- line: 14
	-- upvalues: CloseMatchingScreens (copy), AvatarScreen (copy), AppPage (copy), FFlagAXEditorSubcategoryFilters (copy)
	return CloseMatchingScreens(p1, {
		AvatarScreen.ItemDetails,
		AvatarScreen.SortAndFilters,
		AppPage.GameDetail,
		AppPage.ProfilePlatform,
		if not FFlagAXEditorSubcategoryFilters then nil else AvatarScreen.SubcategoryFiltersDropdown
	})
end
