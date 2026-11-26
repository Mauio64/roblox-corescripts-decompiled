local function mergeEventFields(p2, items)
	if items == nil then
		return p2
	end

	local clone = table.clone(p2)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

return mergeEventFields
