local scriptParent = script.Parent

require(scriptParent.Types)

local function pick(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 12
	local t2 = {}

	for v6, v7 in t1 do
		if p1(v7, v6) then
			t2[v6] = v7
		end
	end

	return t2
end

return pick
