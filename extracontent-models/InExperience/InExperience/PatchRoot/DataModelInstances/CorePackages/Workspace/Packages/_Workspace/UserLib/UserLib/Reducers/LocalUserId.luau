local UserLib = script:FindFirstAncestor("UserLib")
local SetLocalUserId = require(UserLib.Actions.SetLocalUserId)

return function(s1: string?, p1) -- line: 5
	-- upvalues: SetLocalUserId (copy)
	if p1.type == SetLocalUserId.name then
		return p1.userId
	end

	return s1 or ""
end
