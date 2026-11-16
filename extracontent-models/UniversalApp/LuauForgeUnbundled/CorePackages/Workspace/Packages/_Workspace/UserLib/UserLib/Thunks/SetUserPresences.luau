local receiveUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/receiveUsersPresence")

return function(p2)
	return function(p3)
		receiveUsersPresence(p2, p3)
	end
end
