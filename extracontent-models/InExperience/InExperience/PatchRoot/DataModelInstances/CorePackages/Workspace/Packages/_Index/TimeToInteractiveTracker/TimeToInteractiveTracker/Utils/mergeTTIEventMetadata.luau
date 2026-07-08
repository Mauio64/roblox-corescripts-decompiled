require(script.Parent.Parent.Stores.types)

local function mergeTTIEventMetadata(p1, p2) -- line: 6
	local v4 = table.clone(p1)

	for v5, v6 in p2 do
		v4[v5] = v6
	end

	return v4
end

return mergeTTIEventMetadata
