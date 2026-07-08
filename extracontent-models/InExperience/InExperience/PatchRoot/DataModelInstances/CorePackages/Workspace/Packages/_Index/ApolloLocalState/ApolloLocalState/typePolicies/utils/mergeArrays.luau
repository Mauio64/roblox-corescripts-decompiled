local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local Array = require(Parent.LuauPolyfill).Array

local function mergeArrays(_, p2, p3) -- line: 6
	-- upvalues: Array (copy)
	local v7 = p2 or {}
	local v8 = p3 or {}

	if #v8 == 0 then
		return v7
	end

	if #v7 == 0 then
		return v8
	end

	return Array.concat(table.clone(v7), v8)
end

return mergeArrays
