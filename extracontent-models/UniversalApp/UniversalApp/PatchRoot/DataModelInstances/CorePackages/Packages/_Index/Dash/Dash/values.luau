local scriptParent = script.Parent

require(scriptParent.Types)

local insert = table.insert

local function values(t1: {[any]: any}) -- line: 14
	-- upvalues: insert (copy)
	local t2 = {}

	for _, v7 in t1 do
		insert(t2, v7)
	end

	return t2
end

return values
