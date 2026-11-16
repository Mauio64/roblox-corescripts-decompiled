local v = "([" .. ("$%^()-[].?"):gsub("(.)", "%%%1") .. "])"

return function(value: string, value2: string, p: number?)
	local count = #value
	local v2 = p == nil and 1 or p < 1 and 1 or p

	if #value2 == 0 then
		return if count < v2 then count else v2
	else
		if count < v2 then
			return -1
		end

		local v3 = value2:gsub(v, "%%%1")
		local v4 = #v3

		for i = v2, count do
			if string.sub(value, i, i + v4 - 1) == v3 then
				return i
			end
		end

		return -1
	end
end
