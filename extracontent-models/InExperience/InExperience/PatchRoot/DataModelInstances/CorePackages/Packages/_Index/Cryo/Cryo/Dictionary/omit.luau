local function omit(t1: {[any]: any}, ...) -- line: 6
	local v3 = table.clone(t1)

	for _, v5 in { ... } do
		v3[v5] = nil
	end

	return v3
end

return omit
