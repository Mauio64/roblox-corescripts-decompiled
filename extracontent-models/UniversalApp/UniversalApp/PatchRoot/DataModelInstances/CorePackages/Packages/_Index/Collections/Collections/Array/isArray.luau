return function(p1) -- line: 16
	if typeof(p1) ~= "table" then
		return false
	end

	if next(p1) == nil then
		return true
	end

	if #p1 == 0 then
		return false
	end

	local n1 = 0
	local n2 = 0

	for k in pairs(p1) do
		if typeof(k) ~= "number" then
			return false
		end

		if k % 1 ~= 0 or k < 1 then
			return false
		end

		n1 += 1
		n2 += k
	end

	return n2 == n1 * (n1 + 1) / 2
end
