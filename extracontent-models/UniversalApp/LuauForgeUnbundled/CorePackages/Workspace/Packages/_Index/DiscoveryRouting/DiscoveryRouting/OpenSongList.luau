local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryRouting/RobloxAppNavigation").NavigationCommands else nil

return function(p2, p3)
	return function(object)
		local v5 = {
			name = appPage.SongList,
			detail = p2,
			extraProps = { pageContext = p3 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end
