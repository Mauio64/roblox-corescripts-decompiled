local parent = script.Parent
local isArray = require(parent.isArray)
local parent2 = parent.Parent
require(parent2.types)

return function(list)
	if _G.__DEV__ and not isArray(list) then
		error(string.format("Array.shift called on non-array %s", (typeof(list))))
	end

	if #list > 0 then
		return table.remove(list, 1)
	end

	return nil
end
