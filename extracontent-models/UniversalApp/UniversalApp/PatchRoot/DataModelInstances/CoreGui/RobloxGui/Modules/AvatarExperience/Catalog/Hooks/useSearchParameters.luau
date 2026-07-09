local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen

require(Modules.AvatarExperience.Catalog.SearchTypes)

local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals

local function useSearchParameters() -- line: 16
	-- upvalues: useNavigation (copy), AvatarScreen (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v8 = useNavigation()
	local v9 = if v8.state.routeName ~= AvatarScreen.CatalogSearch then nil else v8.getParam("detail")

	return (useSelector(function(p1) -- line: 21
		-- upvalues: v9 (copy)
		if v9 then
			return p1.SearchesParameters[v9]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end

return useSearchParameters
