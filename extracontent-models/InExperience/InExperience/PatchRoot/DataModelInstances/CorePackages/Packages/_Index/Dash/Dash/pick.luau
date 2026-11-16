local parent = script.Parent
require(parent.Types)

local function pick(items, callback)
	local result = {}

	for k, item in items do
		if callback(item, k) then
			result[k] = item
		end
	end

	return result
end

return pick
