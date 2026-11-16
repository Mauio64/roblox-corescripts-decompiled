return function(value: string, value2: string)
	local v = value:gsub("%D", "")
	local v2 = value2:gsub("%D", "")

	if string.find(v, v2) == 1 then
		return value2, (string.sub(v, string.len(v2) + 1))
	end

	return value2, v
end
