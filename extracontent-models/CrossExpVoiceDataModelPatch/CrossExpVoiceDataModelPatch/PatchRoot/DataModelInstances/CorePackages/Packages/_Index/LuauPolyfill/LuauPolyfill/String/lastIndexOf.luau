local function lastIndexOf(value: string, p: string, p2: number?)
	local v = string.len(value)

	local v2 = p2 and p2 < 1 and 1 or p2 or v

	if p2 and v < p2 then
		v2 = v
	end

	if p == "" then
		return v2
	end

	local v3 = nil
	local v4 = 0

	while true do
		local v5
		v5, v4 = string.find(value, p, v4 + 1, true)

		if v5 == nil or v2 < v5 then
			break
		end

		v3 = v5
	end

	return if v3 == nil then -1 else v3
end

return lastIndexOf
