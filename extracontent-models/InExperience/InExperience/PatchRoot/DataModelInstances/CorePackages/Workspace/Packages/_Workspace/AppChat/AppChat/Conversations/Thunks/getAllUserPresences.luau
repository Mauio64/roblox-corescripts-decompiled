local AppChat = script:FindFirstAncestor("AppChat")

local NetworkingPresence = require(AppChat.Http.NetworkingPresence)
local FFlagAppChatPresenceStoreMigration = require(AppChat.Flags.FFlagAppChatPresenceStoreMigration)

if FFlagAppChatPresenceStoreMigration then
	return nil
end

return function()
	return function(object)
		local users = object:getState().Users
		local v = {}

		for k, _ in pairs(users) do
			if k ~= "-1" then
				table.insert(v, k)
			end
		end

		object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v)):catch(function(p)
			warn("NetworkingPresence failure in getAllUserPresences, Status: " .. tostring(p))
		end)
	end
end
