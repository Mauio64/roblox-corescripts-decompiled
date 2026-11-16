local parent = script.Parent
require(parent.Types)

local function collectSet(items, callback)
	local set = {}

	for k, item in items do
		if callback ~= nil then
			item = callback(k, item)
		end

		if item ~= nil then
			set[item] = true
		end
	end

	return set
end

return collectSet
