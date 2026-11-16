local function startsWith(value: string, value2: string, p: number?): boolean
	if string.len(value2) == 0 then
		return true
	end

	local v = (p == nil or p < 1) and 1 or p

	return not (string.len(value) < v) and value:find(value2, v, true) == v
end

return startsWith
