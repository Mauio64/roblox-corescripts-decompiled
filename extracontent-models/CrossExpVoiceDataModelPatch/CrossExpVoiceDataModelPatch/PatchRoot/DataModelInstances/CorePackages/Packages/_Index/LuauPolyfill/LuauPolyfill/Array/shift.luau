local scriptParent = script.Parent
local isArray = require(scriptParent.isArray)
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.types)

return function(p1) -- line: 8
	-- upvalues: isArray (copy)
	if _G.__DEV__ and not isArray(p1) then
		error(string.format("Array.shift called on non-array %s", (typeof(p1))))
	end

	if #p1 > 0 then
		return table.remove(p1, 1)
	end

	return nil
end
