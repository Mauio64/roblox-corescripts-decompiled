local scriptParent = script.Parent

require(scriptParent.Types)

local assertEqual = require(scriptParent.assertEqual)

local function map(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 20
	-- upvalues: assertEqual (copy)
	local t2 = {}

	for v7, v8 in t1 do
		local v9 = p1(v8, v7)

		assertEqual(v9 == nil, false, "Returned nil from a Dash.map handler")
		t2[v7] = v9
	end

	return t2
end

return map
