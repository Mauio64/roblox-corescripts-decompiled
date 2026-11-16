local module = require("@luauforge/bundled/fve")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/dCp")
local fFlagAXEditorSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorSubcategoryFilters

return function(p2)
	local itemDetails = avatarScreen.ItemDetails
	local sortAndFilters = avatarScreen.SortAndFilters
	local gameDetail = module2.GameDetail
	local profilePlatform = module2.ProfilePlatform
	local v7 = if fFlagAXEditorSubcategoryFilters then avatarScreen.SubcategoryFiltersDropdown else nil
	return module(p2, { itemDetails, sortAndFilters, gameDetail, profilePlatform, v7 })
end
