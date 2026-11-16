local parent = script.Parent
local isArray = require(parent.isArray)
local parent2 = parent.Parent
require(parent2.types)

return function(list, ...)
	if _G.__DEV__ and not isArray(list) then
		error(string.format("Array.unshift called on non-array %s", (typeof(list))))
	end

	local v = select("#", ...)

	if v > 0 then
		for i = v, 1, -1 do
			table.insert(list, 1, (select(i, ...)))
		end
	end

	return #list
end
