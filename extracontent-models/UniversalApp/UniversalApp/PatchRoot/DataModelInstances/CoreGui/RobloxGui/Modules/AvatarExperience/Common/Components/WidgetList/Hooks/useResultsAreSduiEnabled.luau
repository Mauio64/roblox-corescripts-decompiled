local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local selectSearchKeyword = AvatarExperienceCommon.State.Selectors.selectSearchKeyword
local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local t1 = {
	[CatalogCategories.Recommended:rawValue()] = true
}

local function useResultsAreSduiEnabled() -- line: 31
	-- upvalues: useGetSelectedCategoryAndSubcategoryId (copy), useSelector (copy), selectSearchKeyword (copy), selectFilterCount (copy), t1 (copy)
	local v11, _ = useGetSelectedCategoryAndSubcategoryId()
	local v13 = useSelector(selectSearchKeyword)
	local v14 = useSelector(selectFilterCount)

	return v11 ~= nil and (t1[v11] == true and ((v13 == nil or v13 == "") and v14 == 0))
end

return useResultsAreSduiEnabled
