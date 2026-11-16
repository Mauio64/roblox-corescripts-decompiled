local parent = script.Parent
require(parent.Types)
local insert = table.insert

local function values(items)
	local result = {}

	for _, item in items do
		insert(result, item)
	end

	return result
end

return values
