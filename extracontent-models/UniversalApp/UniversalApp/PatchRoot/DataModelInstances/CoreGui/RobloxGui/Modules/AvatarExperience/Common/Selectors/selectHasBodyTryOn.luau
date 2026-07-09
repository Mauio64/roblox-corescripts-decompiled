local selectTryOnBodyIds = require(script.Parent.selectTryOnBodyIds)

local function selectHasBodyTryOn(p1) -- line: 3
	-- upvalues: selectTryOnBodyIds (copy)
	return #selectTryOnBodyIds(p1) > 0
end

return selectHasBodyTryOn
