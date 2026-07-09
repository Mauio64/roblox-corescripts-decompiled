local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Dash = require(CorePackages.Packages.Dash)

require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)

local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)

require(Modules.AvatarExperience.Catalog.SearchTypes)

local SearchUuid = require(Modules.LuaApp.SearchUuid)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

local function NavigateToSearch(p1, p2) -- line: 24
	-- upvalues: SearchUuid (copy), SetSearchType (copy), RobloxAppEnums (copy), FilterUtils (copy), Dash (copy), SetSearchParameters (copy), NavigationUtils (copy)
	return function(p3) -- line: 25
		-- upvalues: SearchUuid (copy), SetSearchType (copy), RobloxAppEnums (copy), p2 (copy), FilterUtils (copy), Dash (copy), SetSearchParameters (copy), NavigationUtils (copy), p1 (copy)
		local v14 = SearchUuid()

		p3:dispatch(SetSearchType(v14, RobloxAppEnums.SearchTypes.Catalog))

		local v15 = p2 or {}
		local v16 = FilterUtils.selectSortAndFilters(p3:getState())
		local v17 = Dash.join(v15, {
			sortAndFilters = v16
		})

		p3:dispatch(SetSearchParameters(v14, v17))
		NavigationUtils.navigateToSearch(p1, v14, v17)
	end
end

return NavigateToSearch
