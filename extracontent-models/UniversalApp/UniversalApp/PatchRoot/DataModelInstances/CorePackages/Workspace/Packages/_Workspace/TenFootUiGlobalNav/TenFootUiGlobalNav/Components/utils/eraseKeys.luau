function eraseKeys(t1: {[any]: any}, t2: {[any]: any}) -- line: 1
	local v3 = table.clone(t2)

	for _, v in pairs(t1) do
		v3[v] = nil
	end

	return v3
end

return eraseKeys
