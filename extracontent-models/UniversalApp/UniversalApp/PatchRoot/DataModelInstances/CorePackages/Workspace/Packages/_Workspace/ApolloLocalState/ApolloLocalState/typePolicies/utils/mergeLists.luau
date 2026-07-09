local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local Array = require(Parent.LuauPolyfill).Array

return function(p1, p2) -- line: 4
	-- upvalues: Array (copy)
	local v5 = p1 or {}
	local v6 = p2 or {}

	if #v6 == 0 then
		return v5
	end

	if #v5 == 0 then
		return v6
	end

	return Array.concat(table.clone(v5), v6)
end
