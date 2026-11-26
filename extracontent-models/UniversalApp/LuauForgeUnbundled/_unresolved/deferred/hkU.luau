local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dXh")

return function(p2, p3)
	local topLevelFPS = module.Counter.TopLevelFPS
	local withinViewContext = module2.isWithinViewContext(p3, avatarScreen.CatalogSearch)
	return ({
		[avatarScreen.Catalog] = topLevelFPS.Catalog,
		[avatarScreen.CatalogSearch] = topLevelFPS.Search,
		[avatarScreen.AvatarEditor] = topLevelFPS.Editor,
		[avatarScreen.ItemDetails] = withinViewContext and topLevelFPS.SearchItemDetails or topLevelFPS.CatalogItemDetails,
		[avatarScreen.SortAndFilters] = withinViewContext and topLevelFPS.SearchFilters or topLevelFPS.CatalogFilters
	})[p2] or module.Counter.TopLevelFPS.Unknown
end
