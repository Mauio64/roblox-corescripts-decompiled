local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

return function(s1: string, p1) -- line: 17
	-- upvalues: Constants (copy), NavigationUtils (copy), AvatarScreen (copy)
	local TopLevelFPS = Constants.Counter.TopLevelFPS
	local v10 = NavigationUtils.isWithinViewContext(p1, AvatarScreen.CatalogSearch)

	return ({
		[AvatarScreen.Catalog] = TopLevelFPS.Catalog,
		[AvatarScreen.CatalogSearch] = TopLevelFPS.Search,
		[AvatarScreen.AvatarEditor] = TopLevelFPS.Editor,
		[AvatarScreen.ItemDetails] = v10 and TopLevelFPS.SearchItemDetails or TopLevelFPS.CatalogItemDetails,
		[AvatarScreen.SortAndFilters] = v10 and TopLevelFPS.SearchFilters or TopLevelFPS.CatalogFilters
	})[s1] or Constants.Counter.TopLevelFPS.Unknown
end
