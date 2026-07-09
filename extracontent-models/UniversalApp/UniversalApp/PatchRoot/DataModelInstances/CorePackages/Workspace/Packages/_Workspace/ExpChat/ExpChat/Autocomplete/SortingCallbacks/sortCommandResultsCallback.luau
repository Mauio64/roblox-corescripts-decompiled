local Parent = script:FindFirstAncestor("ExpChat").Parent
local List = require(Parent.llama).List

return function(p1) -- line: 5
	-- upvalues: List (copy)
	return List.sort(p1)
end
