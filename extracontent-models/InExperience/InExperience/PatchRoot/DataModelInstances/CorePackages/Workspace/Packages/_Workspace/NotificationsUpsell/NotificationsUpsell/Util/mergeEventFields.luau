local function mergeEventFields(p, items)
	if items == nil then
		return p
	end

	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

return mergeEventFields
