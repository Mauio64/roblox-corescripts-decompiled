local parent = script:FindFirstAncestor("ApolloLocalState").Parent

local Cryo = require(parent.Cryo)

local function mergeListsWithoutDuplicates(list, list2, p: string?)
	if not list2 or #list2 == 0 then
		return list
	end

	if not list or #list == 0 then
		return list2
	end

	local set = Cryo.List.toSet(Cryo.List.map(list, function(p2)
		if p then
			return p2[p]
		end

		return p2
	end))

	local filtered = Cryo.List.filter(list2, function(p2): boolean
		if p then
			p2 = p2[p]
		end

		return not set[p2]
	end)

	return Cryo.List.join(table.clone(list), filtered)
end

return mergeListsWithoutDuplicates
