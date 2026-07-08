local __DEV__ = _G.__DEV__
local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local isArray = require(scriptParent.isArray)

require(ParentParent.ES7Types)

return function(p1, ...) -- line: 23
	-- upvalues: __DEV__ (copy), isArray (copy)
	if __DEV__ and not isArray(p1) then
		error(string.format("Array.unshift called on non-array %s", (typeof(p1))))
	end

	local v6 = select("#", ...)

	if v6 > 0 then
		for i = v6, 1, -1 do
			table.insert(p1, 1, (select(i, ...)))
		end
	end

	return #p1
end
