local __DEV__ = _G.__DEV__
local parent = script.Parent
local parent2 = parent.Parent.Parent
local isArray = require(parent.isArray)
require(parent2.ES7Types)

return function(list, ...)
	if __DEV__ and not isArray(list) then
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
