local Parent = script:FindFirstAncestor("ApolloLocalState").Parent
local Cryo = require(Parent.Cryo)

local function mergeListsWithoutDuplicates(t1: {[any]: any}?, t2: {[any]: any}?, s1: string?) -- line: 5
	-- upvalues: Cryo (copy)
	if not t2 or #t2 == 0 then
		return t1
	end

	if not t1 or #t1 == 0 then
		return t2
	end

	local v7 = Cryo.List.toSet(Cryo.List.map(t1, function(p1) -- line: 13
		-- upvalues: s1 (copy)
		if s1 then
			return p1[s1]
		end

		return p1
	end))
	local v8 = Cryo.List.filter(t2, function(p2) -- line: 18
		-- upvalues: s1 (copy), v7 (copy)
		return not v7[if not s1 then p2 else p2[s1]]
	end)

	return Cryo.List.join(table.clone(t1), v8)
end

return mergeListsWithoutDuplicates
