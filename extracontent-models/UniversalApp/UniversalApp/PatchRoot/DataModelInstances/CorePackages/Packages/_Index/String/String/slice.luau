local function slice(value: string, p, p2)
	local v, v2 = utf8.len(value)
	assert(v ~= nil, ("string `%s` has an invalid byte at position %s"):format(value, (tostring(v2))))
	local v3 = tonumber(p)
	assert(typeof(v3) == "number", "startIndexStr should be a number")

	local v4 = v3 + v < 0 and 1 or v3

	if v < v4 then
		return ""
	end

	local v5 = v + 1

	local v6 = p2 ~= nil and (tonumber(p2) or (0 / 0)) or v5

	assert(typeof(v6) == "number", "lastIndexStr should convert to number")

	if v < v6 then
		v6 = v + 1
	end

	return (string.sub(value, utf8.offset(value, v4), utf8.offset(value, v6) - 1))
end

return slice
