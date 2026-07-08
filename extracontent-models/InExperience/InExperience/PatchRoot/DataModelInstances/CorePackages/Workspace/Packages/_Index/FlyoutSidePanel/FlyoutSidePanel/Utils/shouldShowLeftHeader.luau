local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigationRodux = require(Parent.NavigationRodux)
local FFlagAppIaHomeSubTab = require(Parent.SharedFlags).FFlagAppIaHomeSubTab

return function(p1, p2, p3) -- line: 13
	-- upvalues: AppPage (copy), FFlagAppIaHomeSubTab (copy), NavigationRodux (copy)
	local v8 = p1 == AppPage.Home or (p1 == AppPage.Games or FFlagAppIaHomeSubTab and p1 == NavigationRodux.Constants.HomeContainerName)
	local v9 = p2 == AppPage.Home or p2 == AppPage.Games

	if not v8 and not v9 then
		return false
	end

	if not v8 or p2 ~= p1 then
		return true
	end

	local v10 = v8 and p2 == AppPage.GameDetail

	return (v9 or v10) and not p3
end
