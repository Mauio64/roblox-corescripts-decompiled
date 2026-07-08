local UserLib = script:FindFirstAncestor("UserLib")
local receiveUsersPresence = require(UserLib.Utils.receiveUsersPresence)

return function(p1) -- line: 4
	-- upvalues: receiveUsersPresence (copy)
	return function(p2) -- line: 5
		-- upvalues: receiveUsersPresence (copy), p1 (copy)
		receiveUsersPresence(p1, p2)
	end
end
