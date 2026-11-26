local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local navigateToRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateToRoute
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").NavigationCommands else nil

local v5 = {
	{ name = appPage.Chat }
}

return function(p2, p3)
	return function(object)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]), p3)
		else
			object:dispatch(navigateToRoute(v5, p3))
		end

		object:dispatch(NavigateIntoChat({ screen = EnumScreens.SquadLobby, params = p2 }))
	end
end
