local parent = script.Parent
require(parent.Types)

local function collect(items, callback)
	local result = {}

	for k, item in items do
		local v, v2 = callback(k, item)

		if v ~= nil then
			result[v] = v2
		end
	end

	return result
end

return collect
