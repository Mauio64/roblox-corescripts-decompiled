local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")
local navigateToRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").Thunks.NavigateToRoute
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local getFFlagEnableStandaloneAppChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagEnableStandaloneAppChat")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").NavigationCommands else nil

local v5 = {
	{ name = appPage.Chat }
}

return function(params, p2)
	return function(object)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.to(navigationCommands.fromLegacyPage(v5[#v5]), p2)
		else
			object:dispatch(navigateToRoute(v5, p2))
		end

		local v8 = if getFFlagEnableStandaloneAppChat() then EnumScreens.ChatConversation else EnumScreens.RoactChat
		object:dispatch(NavigateIntoChat({ screen = v8, params = params }))
	end
end
