local Parent = script:FindFirstAncestor("SocialTab").Parent
local fetchChatMetadata = require(Parent.AppChat.fetchChatMetadata)
local NavigateIntoChat = require(Parent.AppChat.NavigateIntoChat)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v7 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub

return function(p1) -- line: 17
	-- upvalues: fetchChatMetadata (copy), NavigateIntoChat (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), NavigateDown (copy)
	return {
		fetchChatSettings = function(_) -- line: 19
			-- upvalues: p1 (copy), fetchChatMetadata (copy)
			return p1(fetchChatMetadata()):andThen(function(_: boolean) -- line: 20
			end)
		end,
		navigateIntoChat = function(p3) -- line: 22
			-- upvalues: p1 (copy), NavigateIntoChat (copy)
			p1(NavigateIntoChat(p3))
		end,
		navigateToAddFriends = not FFlagCreateConnectionsHub and function() -- line: 27
			-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v7 (copy), p1 (copy), NavigateDown (copy)
			local t1 = {
				name = AppPage.AddFriendsPage
			}

			if FFlagSignalsNavP3Dispatch then
				v7.down(v7.fromLegacyPage(t1))

				return
			end

			p1(NavigateDown(t1))
		end or nil
	}
end
