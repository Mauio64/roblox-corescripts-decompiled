local function tryGetPathFromData(t1: {[any]: any}?, t2: {[any]: any}?, n1: number?) -- line: 12
	if t1 == nil or t2 == nil then
		return false, nil
	end

	for i = n1 or 1, #t2 do
		local v6 = t2[i]

		if t1 == nil then
			return false, nil
		end

		t1 = t1[v6]
	end

	return t1 ~= nil, t1
end

return tryGetPathFromData
