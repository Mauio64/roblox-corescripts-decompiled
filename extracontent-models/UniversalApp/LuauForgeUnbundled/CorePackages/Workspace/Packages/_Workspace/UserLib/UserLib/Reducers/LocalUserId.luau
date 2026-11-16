local SetLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/SetLocalUserId")

return function(value, p2)
	if p2.type == SetLocalUserId.name then
		return p2.userId
	end

	return value or ""
end
