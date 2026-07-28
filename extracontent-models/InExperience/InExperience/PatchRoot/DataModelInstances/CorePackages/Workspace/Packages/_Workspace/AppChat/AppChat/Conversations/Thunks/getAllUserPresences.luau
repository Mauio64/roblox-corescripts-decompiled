local AppChat = script:FindFirstAncestor("AppChat")
local NetworkingPresence = require(AppChat.Http.NetworkingPresence)

if require(AppChat.Flags.FFlagAppChatPresenceStoreMigration) then
	return nil
end

return function() -- line: 8
	-- upvalues: NetworkingPresence (copy)
	return function(p1) -- line: 9
		-- upvalues: NetworkingPresence (copy)
		local Users = p1:getState().Users
		local t1 = {}

		for k, _ in pairs(Users) do
			if k ~= "-1" then
				table.insert(t1, k)
			end
		end

		p1:dispatch(NetworkingPresence.GetPresencesFromUserIds.API(t1)):catch(function(p2) -- line: 20
			warn("NetworkingPresence failure in getAllUserPresences, Status: " .. tostring(p2))
		end)
	end
end
