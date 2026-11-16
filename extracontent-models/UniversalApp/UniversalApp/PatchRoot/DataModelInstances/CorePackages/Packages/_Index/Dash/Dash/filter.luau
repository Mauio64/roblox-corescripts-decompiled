local parent = script.Parent
require(parent.Types)

local function filter(items, callback)
	local result = {}

	for k, item in items do
		if callback(item, k) then
			table.insert(result, item)
		end
	end

	return result
end

return filter
