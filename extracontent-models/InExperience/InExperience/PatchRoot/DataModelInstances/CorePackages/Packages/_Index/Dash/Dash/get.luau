local function get(t1: {[any]: any}, t2: {[any]: any}, p1) -- line: 22
	if t1 == nil then
		return p1
	end

	for _, v6 in t2 do
		if type(t1) ~= "table" then
			return p1
		end

		t1 = t1[v6]

		if t1 == nil then
			return p1
		end
	end

	return t1
end

return get
