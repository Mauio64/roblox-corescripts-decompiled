local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigateToRoute = require(AppChatParent.NavigationRodux).Thunks.NavigateToRoute
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local EnumScreens = require(AppChat.EnumScreens)
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v8 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local t1 = {{
	name = AppPage.Chat
}}

return function(t2: {[any]: any}, b1: boolean) -- line: 23
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), t1 (copy), NavigateToRoute (copy), NavigateIntoChat (copy), EnumScreens (copy)
	return function(p1) -- line: 24
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v8 (copy), t1 (copy), b1 (copy), NavigateToRoute (copy), NavigateIntoChat (copy), EnumScreens (copy), t2 (copy)
		if FFlagSignalsNavP3Dispatch then
			v8.to(v8.fromLegacyPage(t1[#t1]), b1)
		else
			p1:dispatch(NavigateToRoute(t1, b1))
		end

		p1:dispatch(NavigateIntoChat({
			screen = EnumScreens.SquadLobby,
			params = t2
		}))
	end
end
