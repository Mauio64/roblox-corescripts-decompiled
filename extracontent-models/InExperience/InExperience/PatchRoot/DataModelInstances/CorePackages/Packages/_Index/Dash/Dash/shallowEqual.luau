local function shallowEqual(p1, p2) -- line: 8
	if p1 == p2 then
		return true
	end

	if typeof(p1) ~= "table" or typeof(p2) ~= "table" or #p1 ~= #p2 then
		return false
	end

	if p1 == nil or p2 == nil then
		return false
	end

	for v4, v5 in p1 do
		if v5 ~= p2[v4] then
			return false
		end
	end

	for v6, v7 in p2 do
		if v7 ~= p1[v6] then
			return false
		end
	end

	return true
end

return shallowEqual
