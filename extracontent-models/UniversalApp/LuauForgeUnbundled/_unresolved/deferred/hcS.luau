local module = require("@luauforge/deferred/hcT")
local module2 = require("@luauforge/deferred/hcU")

local appPage = require("@luauforge/deferred/hcB").AppPage
local navigateDown = require("@luauforge/deferred/hcV").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/hbX").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/hcW").NavigationCommands else nil

local fFlagCreateConnectionsHub = require("@luauforge/deferred/hbX").FFlagCreateConnectionsHub

return function(callback)
	return {
		fetchChatSettings = function(p2)
			return callback(module()):andThen(function(p3) end)
		end,
		navigateIntoChat = function(p2)
			callback(module2(p2))
		end,
		navigateToAddFriends = not fFlagCreateConnectionsHub and function()
			local v5 = { name = appPage.AddFriendsPage }

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				callback(navigateDown(v5))
			end
		end or nil
	}
end
