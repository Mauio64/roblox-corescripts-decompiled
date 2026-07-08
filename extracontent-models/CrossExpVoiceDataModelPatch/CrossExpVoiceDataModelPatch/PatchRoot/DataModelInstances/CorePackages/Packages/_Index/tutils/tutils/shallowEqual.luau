return function(p1, p2, p3) -- line: 5
	if not p1 or not p2 then
		return false
	end

	if p1 == p2 then
		return true
	end

	if not p3 then
		p3 = {}
	end

	for k, v in pairs(p1) do
		if v ~= p2[k] and not p3[k] then
			return false
		end
	end

	for k, v in pairs(p2) do
		if v ~= p1[k] and not p3[k] then
			return false
		end
	end

	return true
end
