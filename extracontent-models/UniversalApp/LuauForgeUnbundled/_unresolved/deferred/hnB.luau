local module = require("@luauforge/deferred/hnC")
local module2 = require("@luauforge/deferred/hnD")

local appPage = require("@luauforge/deferred/hnk").AppPage
local navigateDown = require("@luauforge/deferred/hnE").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/hmG").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/hnF").NavigationCommands else nil

local fFlagCreateConnectionsHub = require("@luauforge/deferred/hmG").FFlagCreateConnectionsHub

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
