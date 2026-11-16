local function omit(p, ...)
	local clone = table.clone(p)

	for _, v in { ... } do
		clone[v] = nil
	end

	return clone
end

return omit
