local Parent = script:FindFirstAncestor("AppChat").Parent
local List = require(Parent.Cryo).List

local function isUserInList(p1, p2) -- line: 5
	-- upvalues: List (copy)
	return List.findWhere(p1, function(p3) -- line: 6
		-- upvalues: p2 (copy)
		return p3.id == p2
	end) ~= nil
end

return isUserInList
