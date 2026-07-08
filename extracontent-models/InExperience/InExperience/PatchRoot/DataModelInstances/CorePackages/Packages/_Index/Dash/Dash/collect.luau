local scriptParent = script.Parent

require(scriptParent.Types)

local function collect(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 16
	local t2 = {}

	for v6, v7 in t1 do
		local v8, v9 = p1(v6, v7)

		if v8 ~= nil then
			t2[v8] = v9
		end
	end

	return t2
end

return collect
