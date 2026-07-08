return function(p1) -- line: 7
	local v2 = false
	local v3 = false
	local v4 = true
	local n1 = 1

	for k, _ in pairs(p1) do
		if type(k) == "string" then
			v3 = true
		else
			if type(k) ~= "number" then
				return false
			end

			if n1 ~= k then
				v4 = false
			end

			v2 = true
		end

		if v3 and v2 then
			return false
		end

		n1 += 1
	end

	if v2 then
		return v4
	end

	return true
end
