local function createUniqueKey()
	local v = {}

	return function(p)
		if v[p] == nil then
			v[p] = 1
			return p
		end

		local v2

		repeat
			v[p] += 1
			v2 = `{p}_{v[p]}`
		until v[v2] == nil

		return v2
	end
end

return createUniqueKey
