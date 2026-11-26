local function parseVersion(value)
	local result = {}

	for k, v5 in string.split(value, ".") do
		if string.match(v5, "^%d+$") == nil then
			return nil
		end

		table.insert(result, (tonumber(v5)))
	end

	return result
end

local function isVersionAtLeast(p2, p3): boolean
	local v5 = parseVersion(p2)
	local v6 = parseVersion(p3)

	if v5 == nil or v6 == nil then
		return false
	end

	for i = 1, math.max(#v5, #v6) do
		local v7 = v5[i] or 0
		local v8 = v6[i] or 0

		if v7 ~= v8 then
			return v8 < v7
		end
	end

	return true
end

return isVersionAtLeast
