local function union(p, items)
	local clone = table.clone(p)

	for k, item in items do
		clone[k] = item
	end

	return clone
end

return union
