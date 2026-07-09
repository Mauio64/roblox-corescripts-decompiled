local Parent = script:FindFirstAncestor("SquadsCore").Parent
local v2 = require(Parent.RegExp)("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$")

local function validateSquadId(s1: string) -- line: 9
	-- upvalues: v2 (copy)
	if s1 and (s1 ~= "" and v2:exec(s1)) then
		return true
	end

	return false
end

return validateSquadId
