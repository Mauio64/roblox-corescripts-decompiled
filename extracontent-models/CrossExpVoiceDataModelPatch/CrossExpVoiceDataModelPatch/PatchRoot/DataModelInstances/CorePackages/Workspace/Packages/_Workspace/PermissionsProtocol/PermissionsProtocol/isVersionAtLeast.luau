local function parseVersion(value: string)
	local result = {}

	for _, v in string.split(value, ".") do
		if string.match(v, "^%d+$") == nil then
			return nil
		end

		table.insert(result, (tonumber(v)))
	end

	return result
end

local function isVersionAtLeast(p: string, p2: string): boolean
	local v = parseVersion(p)
	local v2 = parseVersion(p2)

	if v == nil or v2 == nil then
		return false
	end

	for i = 1, math.max(#v, #v2) do
		local v3 = v[i] or 0
		local v4 = v2[i] or 0

		if v3 ~= v4 then
			return v4 < v3
		end
	end

	return true
end

return isVersionAtLeast
