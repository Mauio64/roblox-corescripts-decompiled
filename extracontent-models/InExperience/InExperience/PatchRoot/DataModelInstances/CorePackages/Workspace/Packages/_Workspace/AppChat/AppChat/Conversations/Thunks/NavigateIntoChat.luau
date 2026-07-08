local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigateToRoute = require(AppChatParent.NavigationRodux).Thunks.NavigateToRoute
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local getFFlagEnableStandaloneAppChat = require(AppChat.Flags.getFFlagEnableStandaloneAppChat)
local EnumScreens = require(AppChat.EnumScreens)
local FFlagSignalsNavP3Dispatch = require(AppChatParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(AppChatParent.RobloxAppNavigation).NavigationCommands
local t1 = {{
	name = AppPage.Chat
}}

return function(t2: {[any]: any}, b1: boolean) -- line: 25
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), t1 (copy), NavigateToRoute (copy), NavigateIntoChat (copy), getFFlagEnableStandaloneAppChat (copy), EnumScreens (copy)
	return function(p1) -- line: 26
		-- upvalues: FFlagSignalsNavP3Dispatch (copy), v9 (copy), t1 (copy), b1 (copy), NavigateToRoute (copy), NavigateIntoChat (copy), getFFlagEnableStandaloneAppChat (copy), EnumScreens (copy), t2 (copy)
		if FFlagSignalsNavP3Dispatch then
			v9.to(v9.fromLegacyPage(t1[#t1]), b1)
		else
			p1:dispatch(NavigateToRoute(t1, b1))
		end

		p1:dispatch(NavigateIntoChat({
			screen = if not getFFlagEnableStandaloneAppChat() then EnumScreens.RoactChat else EnumScreens.ChatConversation,
			params = t2
		}))
	end
end
