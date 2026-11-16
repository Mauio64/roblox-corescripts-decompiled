local parent = script.Parent.Parent

require(parent.util.Types)
local getExpectedPartSize = require(parent.util.getExpectedPartSize)

return function(items, callback, p)
	local result = {}

	for _, item in items do
		local v = callback(item)
		result[item] = getExpectedPartSize(v, p) / getExpectedPartSize(v, p, true)
	end

	return result
end
