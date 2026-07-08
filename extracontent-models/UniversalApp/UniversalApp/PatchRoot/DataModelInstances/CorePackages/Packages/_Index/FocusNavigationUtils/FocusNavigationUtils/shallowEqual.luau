local function shallowEqual(t1: {[any]: any}, t2: {[any]: any}) -- line: 4
	for v4, v5 in t1 do
		if v5 ~= t2[v4] then
			return false
		end
	end

	for v6, v7 in t2 do
		if v7 ~= t1[v6] then
			return false
		end
	end

	return true
end

return shallowEqual
