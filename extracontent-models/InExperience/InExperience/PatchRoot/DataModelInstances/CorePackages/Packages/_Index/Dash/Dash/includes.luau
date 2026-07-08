local function includes(t1: {[any]: any}, p1) -- line: 10
	if p1 == nil then
		return false
	end

	for _, v5 in t1 do
		if v5 == p1 then
			return true
		end
	end

	return false
end

return includes
