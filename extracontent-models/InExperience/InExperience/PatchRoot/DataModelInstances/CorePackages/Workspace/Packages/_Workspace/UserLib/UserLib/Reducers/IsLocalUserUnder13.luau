local UserLib = script:FindFirstAncestor("UserLib")
local SetLocalUserUnder13 = require(UserLib.Actions.SetLocalUserUnder13)

return function(p1, p2) -- line: 4
	-- upvalues: SetLocalUserUnder13 (copy)
	local v5 = p1 == true or false

	if p2.type == SetLocalUserUnder13.name then
		return p2.isUnder13
	end

	return v5
end
