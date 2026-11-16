local parent = script.Parent
require(parent.Types)

local insert = table.insert

local function groupBy(items, callback)
	local result = {}

	for k, item in items do
		local v

		if typeof(callback) == "function" then
			v = callback(item, k)
		else
			v = item[callback]
		end

		if v == nil then
			continue
		end

		if result[v] == nil then
			result[v] = { item }
		else
			insert(result[v], item)
		end
	end

	return result
end

return groupBy
