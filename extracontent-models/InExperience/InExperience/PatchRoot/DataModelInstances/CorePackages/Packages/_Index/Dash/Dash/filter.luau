local scriptParent = script.Parent

require(scriptParent.Types)

local function filter(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 16
	local t2 = {}

	for v6, v7 in t1 do
		if p1(v7, v6) then
			table.insert(t2, v7)
		end
	end

	return t2
end

return filter
