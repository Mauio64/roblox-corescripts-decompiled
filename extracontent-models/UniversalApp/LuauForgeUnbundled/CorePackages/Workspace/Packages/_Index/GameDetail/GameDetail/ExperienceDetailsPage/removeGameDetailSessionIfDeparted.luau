local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage
require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/NavigationRodux")
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppSessionization").SessionType
local hasPageInCurrentRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/DiscoveryRouting").hasPageInCurrentRoute

local function removeGameDetailSessionIfDeparted(object, p2)
	if
		object
		and p2
		and not (hasPageInCurrentRoute(p2, appPage.GameDetail, true) or hasPageInCurrentRoute(p2, appPage.ExperienceDetail, true))
	then
		object:RemoveSession(sessionType.StructuralIdentifier.GameDetailSource)
	end
end

return removeGameDetailSessionIfDeparted
