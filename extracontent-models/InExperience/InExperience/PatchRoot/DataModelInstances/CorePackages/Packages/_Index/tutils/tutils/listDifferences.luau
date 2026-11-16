local tableDifference = require(script.Parent.tableDifference)

local function membershipTable(list) -- 2 equivalent calls inferred from this helper
	local result = {}

	for i = 1, #list do
		result[list[i]] = true
	end

	return result
end

local function listOfKeys(items) -- 1 equivalent call inferred from this helper
	local result = {}

	for k, _ in pairs(items) do
		table.insert(result, k)
	end

	return result
end

return function(list, list2)
	return listOfKeys(tableDifference(membershipTable(list), membershipTable(list2))) -- inferred equivalent call
end
