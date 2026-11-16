local parent = script.Parent
require(parent.Types)
local assertEqual = require(parent.assertEqual)

local function map(items, callback)
	local result = {}

	for k, item in items do
		local v = callback(item, k)
		assertEqual(v == nil, false, "Returned nil from a Dash.map handler")
		result[k] = v
	end

	return result
end

return map
