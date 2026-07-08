local scriptParent = script.Parent
local isArray = require(scriptParent.isArray)
local scriptParentParent = scriptParent.Parent

require(scriptParentParent.types)

return function(p1, ...) -- line: 8
	-- upvalues: isArray (copy)
	if _G.__DEV__ and not isArray(p1) then
		error(string.format("Array.unshift called on non-array %s", (typeof(p1))))
	end

	local v5 = select("#", ...)

	if v5 > 0 then
		for i = v5, 1, -1 do
			table.insert(p1, 1, (select(i, ...)))
		end
	end

	return #p1
end
