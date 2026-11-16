require(script.Parent.Parent.Stores.types)

local function mergeTTIEventMetadata(p, items)
	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

return mergeTTIEventMetadata
