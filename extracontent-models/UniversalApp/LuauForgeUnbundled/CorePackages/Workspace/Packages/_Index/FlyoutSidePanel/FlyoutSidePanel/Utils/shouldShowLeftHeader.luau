local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux")

local fFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagAppIaHomeSubTab

return function(p2, p3, p4)
	local v5 = p2 == appPage.Home
		or p2 == appPage.Games
		or fFlagAppIaHomeSubTab and p2 == NavigationRodux.Constants.HomeContainerName
	local v6 = p3 == appPage.Home or p3 == appPage.Games

	if not (v5 or v6) then
		return false
	end

	if not v5 or p3 ~= p2 then
		return true
	end

	local v7 = v5 and p3 == appPage.GameDetail

	if v6 or v7 then
		v7 = not p4
	end

	return v7
end
