require("@luauforge/bundled/enl")

local function mergeItemsWithoutDuplicates(list, list2)
	if #list2 == 0 then
		return list
	end

	if #list == 0 then
		return list2
	end

	local idSet = {}

	for k, item in list do
		idSet[item.id] = true
	end

	local clone = table.clone(list)

	for k, item in list2 do
		if idSet[item.id] then
			continue
		end

		idSet[item.id] = true
		table.insert(clone, item)
	end

	return clone
end

return mergeItemsWithoutDuplicates
