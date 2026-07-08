local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local isArray = require(scriptParent.isArray)

require(ParentParent.ES7Types)

return function(p1) -- line: 23
	-- upvalues: __DEV__ (copy), isArray (copy)
	if __DEV__ and not isArray(p1) then
		error(string.format("Array.shift called on non-array %s", (typeof(p1))))
	end

	if #p1 > 0 then
		return table.remove(p1, 1)
	end

	return nil
end
