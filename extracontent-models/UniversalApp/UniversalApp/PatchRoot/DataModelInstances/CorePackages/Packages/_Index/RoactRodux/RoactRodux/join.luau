local function join(...)
	local result = {}

	for i = 1, select("#", ...) do
		local v = select(i, ...)

		if v == nil then
			continue
		end

		for k, v2 in pairs(v) do
			result[k] = v2
		end
	end

	return result
end

return join
