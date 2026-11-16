local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/Cryo")

local function mergeListsWithoutDuplicates(list, list2, p2)
	if not list2 or #list2 == 0 then
		return list
	end

	if not list or #list == 0 then
		return list2
	end

	local set = Cryo.List.toSet(Cryo.List.map(list, function(p3)
		if p2 then
			return p3[p2]
		end

		return p3
	end))

	local filtered = Cryo.List.filter(list2, function(p3): boolean
		if p2 then
			p3 = p3[p2]
		end

		return not set[p3]
	end)

	return Cryo.List.join(table.clone(list), filtered)
end

return mergeListsWithoutDuplicates
