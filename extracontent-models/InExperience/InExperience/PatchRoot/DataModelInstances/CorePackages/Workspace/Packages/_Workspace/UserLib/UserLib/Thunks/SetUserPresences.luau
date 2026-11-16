local UserLib = script:FindFirstAncestor("UserLib")
local receiveUsersPresence = require(UserLib.Utils.receiveUsersPresence)

return function(p)
	return function(p2)
		receiveUsersPresence(p, p2)
	end
end
