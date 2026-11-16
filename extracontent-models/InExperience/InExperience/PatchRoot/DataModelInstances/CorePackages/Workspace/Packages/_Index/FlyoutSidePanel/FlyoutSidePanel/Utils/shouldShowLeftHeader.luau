local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab

return function(p, p2, p3)
	local v = p == AppPage.Home
		or p == AppPage.Games
		or FFlagAppIaHomeSubTab and p == NavigationRodux.Constants.HomeContainerName
	local v2 = p2 == AppPage.Home or p2 == AppPage.Games

	if not (v or v2) then
		return false
	end

	if not v or p2 ~= p then
		return true
	end

	local v3 = v and p2 == AppPage.GameDetail

	if v2 or v3 then
		return not p3
	end

	return v3
end
