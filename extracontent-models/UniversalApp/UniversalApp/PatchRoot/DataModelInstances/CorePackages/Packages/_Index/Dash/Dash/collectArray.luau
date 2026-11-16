local parent = script.Parent
require(parent.Types)

local insert = table.insert

local function collectArray(items, callback)
	local array = {}

	for k, item in items do
		local v = callback(k, item)

		if v ~= nil then
			insert(array, v)
		end
	end

	return array
end

return collectArray
