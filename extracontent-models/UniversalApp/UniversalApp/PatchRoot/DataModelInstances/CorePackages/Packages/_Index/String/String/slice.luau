local function slice(s1: string, p1, p2) -- line: 16
	local v5, v6 = utf8.len(s1)

	assert(v5 ~= nil, ("string `%s` has an invalid byte at position %s"):format(s1, (tostring(v6))))

	local num = tonumber(p1)

	assert(typeof(num) == "number", "startIndexStr should be a number")

	if num + v5 < 0 then
		num = 1
	end

	if v5 < num then
		return ""
	end

	local v8 = v5 + 1

	if p2 ~= nil then
		v8 = tonumber(p2) or (0/0)
	end

	assert(typeof(v8) == "number", "lastIndexStr should convert to number")

	if v5 < v8 then
		v8 = v5 + 1
	end

	return (string.sub(s1, utf8.offset(s1, num), utf8.offset(s1, v8) - 1))
end

return slice
