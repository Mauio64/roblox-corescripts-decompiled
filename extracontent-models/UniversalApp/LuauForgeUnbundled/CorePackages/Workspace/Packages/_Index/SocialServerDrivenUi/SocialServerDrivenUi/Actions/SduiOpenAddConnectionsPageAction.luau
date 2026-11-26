local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/NavigationRodux").Thunks.NavigateDown
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagCreateConnectionsHub
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

return function(p2, p3, p4, p5)
	if fFlagCreateConnectionsHub then
		p4.dependencies.getNavigation().navigate(appPage.CoHubAddConnections)
		return
	end

	local v5 = { name = appPage.AddFriendsPage }

	if fFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v5))
	else
		p4.dependencies.dispatch(navigateDown(v5))
	end
end
