local scriptParent = script.Parent

require(scriptParent.Types)

local insert = table.insert

local function collectArray(t1: {[any]: any}, p1: ((...any) -> ...any)) -- line: 18
	-- upvalues: insert (copy)
	local t2 = {}

	for v7, v8 in t1 do
		local v9 = p1(v7, v8)

		if v9 ~= nil then
			insert(t2, v9)
		end
	end

	return t2
end

return collectArray
