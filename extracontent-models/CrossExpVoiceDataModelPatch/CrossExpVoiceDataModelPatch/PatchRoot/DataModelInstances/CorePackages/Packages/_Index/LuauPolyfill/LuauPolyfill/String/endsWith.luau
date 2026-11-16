local function endsWith(value: string, value2: string, p: number?): boolean
	local v = value2:len()

	if v == 0 then
		return true
	end

	local v2 = value:len()
	local v3 = p or v2

	if v2 < v3 then
		v3 = v2
	end

	if v3 < 1 then
		return false
	end

	local v4 = v3 - v + 1
	return value:find(value2, v4, true) == v4
end

return endsWith
