return function(items)
	local v = 1
	local v2 = false
	local flag = false
	local v3 = true

	for k, _ in pairs(items) do
		if type(k) == "string" then
			v2 = true
		else
			if type(k) ~= "number" then
				return false
			end

			if v ~= k then
				v3 = false
			end

			flag = true
		end

		if v2 and flag then
			return false
		end

		v += 1
	end

	return not flag or v3
end
