local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateToRoute = NavigationRodux.Thunks.NavigateToRoute
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local getFFlagEnableStandaloneAppChat = require(AppChat.Flags.getFFlagEnableStandaloneAppChat)
local EnumScreens = require(AppChat.EnumScreens)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local v = {
	{ name = AppPage.Chat }
}

return function(params, flag: boolean)
	return function(object)
		if FFlagSignalsNavP3Dispatch then
			navigationCommands.to(navigationCommands.fromLegacyPage(v[#v]), flag)
		else
			object:dispatch(NavigateToRoute(v, flag))
		end

		local screen

		if getFFlagEnableStandaloneAppChat() then
			screen = EnumScreens.ChatConversation
		else
			screen = EnumScreens.RoactChat
		end

		object:dispatch(NavigateIntoChat({ screen = screen, params = params }))
	end
end
