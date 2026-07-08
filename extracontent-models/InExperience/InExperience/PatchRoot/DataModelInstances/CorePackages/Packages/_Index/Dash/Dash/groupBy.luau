local scriptParent = script.Parent

require(scriptParent.Types)

local insert = table.insert

local function groupBy(t1: {[any]: any}, p1) -- line: 17
	-- upvalues: insert (copy)
	local t2 = {}

	for v7, v8 in t1 do
		local v9 = if typeof(p1) ~= "function" then v8[p1] else p1(v8, v7)

		if v9 ~= nil then
			if t2[v9] ~= nil then
				insert(t2[v9], v8)
			else
				t2[v9] = { v8 }
			end
		end
	end

	return t2
end

return groupBy
