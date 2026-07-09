local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function useGetCurrentCategoryNames() -- line: 8
	-- upvalues: useSelector (copy), CatalogUtils (copy), getUseSelectorDeepEquals (copy)
	return useSelector(function(p1) -- line: 9
		-- upvalues: CatalogUtils (copy)
		return CatalogUtils.getCurrentCategoryNames(p1)
	end, getUseSelectorDeepEquals())
end

return useGetCurrentCategoryNames
