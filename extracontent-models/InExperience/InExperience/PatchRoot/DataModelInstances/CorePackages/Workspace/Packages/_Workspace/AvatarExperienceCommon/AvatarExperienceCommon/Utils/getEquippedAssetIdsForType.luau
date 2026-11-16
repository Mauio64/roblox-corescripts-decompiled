return function(p, p2: string)
	local result = {}

	if not p then
		return result
	end

	local v = p[p2]

	if v then
		for k, _ in v do
			table.insert(result, k)
		end
	end

	return result
end
