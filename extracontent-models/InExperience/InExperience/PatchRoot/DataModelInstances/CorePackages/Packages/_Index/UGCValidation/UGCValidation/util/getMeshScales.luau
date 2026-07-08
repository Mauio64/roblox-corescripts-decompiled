local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local getExpectedPartSize = require(ParentParent.util.getExpectedPartSize)

return function(t1: {[any]: any}, p1: ((...any) -> ...any), p2) -- line: 10
	-- upvalues: getExpectedPartSize (copy)
	local t2 = {}

	for _, v8 in t1 do
		local v9 = p1(v8)

		t2[v8] = getExpectedPartSize(v9, p2) / getExpectedPartSize(v9, p2, true)
	end

	return t2
end
