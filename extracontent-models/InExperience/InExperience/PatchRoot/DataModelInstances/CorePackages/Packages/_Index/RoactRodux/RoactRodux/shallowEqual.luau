local function shallowEqual(p1, p2) -- line: 1
	if p1 == nil then
		return p2 == nil
	end

	if p2 == nil then
		return p1 == nil
	end

	for k, v in pairs(p1) do
		if v ~= p2[k] then
			return false
		end
	end

	for k, v in pairs(p2) do
		if v ~= p1[k] then
			return false
		end
	end

	return true
end

return shallowEqual
