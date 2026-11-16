local __DEV__ = _G.__DEV__
local parent = script.Parent
local parent2 = parent.Parent.Parent
local isArray = require(parent.isArray)
require(parent2.ES7Types)

return function(list)
	if __DEV__ and not isArray(list) then
		error(string.format("Array.shift called on non-array %s", (typeof(list))))
	end

	if #list > 0 then
		return table.remove(list, 1)
	end

	return nil
end
