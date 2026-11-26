return function(value, value2)
	local v5 = value:gsub("%D", "")
	local v6 = value2:gsub("%D", "")

	if string.find(v5, v6) == 1 then
		return value2, (string.sub(v5, string.len(v6) + 1))
	end

	return value2, v5
end
