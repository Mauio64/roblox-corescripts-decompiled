local NetworkingPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Http/NetworkingPresence")

if require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPresenceStoreMigration") then
	return nil
end

return function()
	return function(object)
		local users = object:getState().Users
		local v5 = {}

		for k, user in pairs(users) do
			if k ~= "-1" then
				table.insert(v5, k)
			end
		end

		object:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(v5)):catch(function(p2)
			warn("NetworkingPresence failure in getAllUserPresences, Status: " .. tostring(p2))
		end)
	end
end
