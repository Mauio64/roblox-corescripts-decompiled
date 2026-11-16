local UserLib = script:FindFirstAncestor("UserLib")
local SetLocalUserId = require(UserLib.Actions.SetLocalUserId)

return function(value: string?, p)
	if p.type == SetLocalUserId.name then
		return p.userId
	end

	return value or ""
end
