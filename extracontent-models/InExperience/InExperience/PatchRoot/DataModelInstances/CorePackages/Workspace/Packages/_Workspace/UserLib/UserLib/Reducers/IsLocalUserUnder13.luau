local UserLib = script:FindFirstAncestor("UserLib")
local SetLocalUserUnder13 = require(UserLib.Actions.SetLocalUserUnder13)

return function(p, p2)
	local v = p == true

	if p2.type == SetLocalUserUnder13.name then
		return p2.isUnder13
	end

	return v
end
